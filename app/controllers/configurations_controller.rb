class ConfigurationsController < ApplicationController
  def show
    #Check for valid api key
    if Utility.latest_version_object_class('ApiKey').all(:'auth_key' => params.with_indifferent_access[:apiKey]).first.blank?
      render :file => 'public/401.html', :status => :unauthorized, :layout => false
      return
    else
      # First, establish the latest version of the product model
      # and then get the first one matching the part number passed in.
      product = Utility.latest_version_object_class('Product')
      if params.has_key?(:version)
        @product = product.first(product_id: params[:id], version: params[:version])
        @is_preview = true
        session[:preview] = true
      else
        @product = product.first(product_id: params[:id], is_published: true)
        @is_preview = false
        session[:preview] = false  if !params.has_key?(:solution)
      end
      if params.has_key?(:solution)
        if session[:preview] || !@product
          @product = product.last(product_id: params[:id])
        end
        @is_nested = true
        @solution = JSON.parse(params[:solution])
        ov = @product.options.option_values.first(:subset_sku => @solution['product_subset'])
        if ov
          @product_subset_nested = ov.value
        else
          @product_subset_nested = @solution['product_subset']
        end

        @id = @solution['product_subset']
        @max_capacity = params[:maxcap]

      end
      if @product.blank?
        render :file => 'public/404.html', :status => :not_found, :layout => false
        return
      end
      # Next, set up the configurations which will be used by the javascript
      # to display different configurations.
      ap = Rails.cache.fetch(params[:id] + @product.version)
      if ap
        @ap = ap
      else
        option_labels = {}
        configurations = product.repository.adapter.select("
        select solutions.id as solution_id, solutions.capacity, option_values.value, options.label,
  options.id as option_id
        from option_values
          inner join option_value_solutions ON option_values.id = option_value_solutions.option_value_id
          inner join solutions ON option_value_solutions.solution_id = solutions.id
          inner join options on options.id = option_values.option_id
        where solutions.product_id = #{@product.id};")
        .group_by{|struct| {solution_id: struct.solution_id, capacity: struct.capacity}}
        .collect do |configuration, options|
          configuration.tap do |hash|
            options.each do |option|
              option_labels[option.option_id] ||= option.label.gsub(/\W/,'_').downcase
              hash[option_labels[option.option_id]] = option.value.gsub(/\W/,'_').downcase
            end
          end
        end

        rtype = Utility.latest_version_object_class('Rtype')
        rtypes = rtype.repository.adapter.select("
        select rtypes.label as part, rtypes.desc as description, rtypes.image_url as image, rtypes.thumbnail_image_url as thumb,
          rtype_solutions.max_quantity, rtype_solutions.button_text as button, rtype_solutions.min_quantity, rtype_solutions.rtype_type as type, rtype_solutions.unit_capacity,
          solutions.id as solution_id, rtype_solutions.max_capacity as capacity, rtype_solutions.nested_subset
        from rtypes
          inner join rtype_solutions on rtype_solutions.rtype_id = rtypes.id
          inner join solutions on rtype_solutions.solution_id = solutions.id
        and solutions.product_id = #{@product.id};")
        .group_by{|struct| struct.type}
        analytics_url = request.protocol + request.host + "/analytics"
        @ap = {solutions: configurations, accessories: rtypes['accessory'] || [], parts: rtypes['part'] || [], ca: rtypes['configured_accessory'] || [], analytics_url: analytics_url}
        p params[:id] + @product.version
        Thread.new do
          Rails.cache.write(params[:id] + @product.version, JSON.parse(@ap.to_json), :expires_in => 7.days )
        end
      end
      if params.has_key?(:solution)
        render 'stacked-left-right.html.haml', layout: false
      else
        render layout: params[:layout].present?
      end
      # Last, we render out the view, including a layout for testing if requested.
=begin      respond_to do |format|
        p format
        format.html{ render 'show.html'} # show.html.erb
        format.js{render 'show.js.erb'}
      end
=end

    end
  end

  def rtype_is_published

    prod = Utility.latest_version_object_class('Product').first(product_id: params[:rtype_id], is_published: true)
    if prod || session[:preview]
      render :text => "true"
    else
      render :text =>  ""
    end
  end

end
