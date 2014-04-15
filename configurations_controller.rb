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
      else
        @product = product.first(product_id: params[:id], is_published: true)
        @is_preview = false
      end
      if params.has_key?(:solution)
        p "has solution"
        @is_nested = true
        options_holder = @product.options.first(:label => 'Product Subset')
        p 'LAHAAHAHAHAHAHAHAHAHAHAHAHAAHHA'
        @solution = JSON.parse(params[:solution])
        @product_subset_nested = @solution['product_subset']
        p @solution
      end
      if @product.blank?
        render :file => 'public/404.html', :status => :not_found, :layout => false
        return
      end
      # Next, set up the configurations which willbe used by the javascript
      # to display different configurations.
      option_labels = {}
      configurations = product.repository.adapter.select("
      select solutions.id as solution_id, option_values.value, options.label,
options.id as option_id
      from option_values
        inner join option_value_solutions ON option_values.id = option_value_solutions.option_value_id
        inner join solutions ON option_value_solutions.solution_id = solutions.id
        inner join options on options.id = option_values.option_id
      where solutions.product_id = #{@product.id};")
      .group_by{|struct| {solution_id: struct.solution_id}}
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
        rtype_solutions.max_quantity, rtype_solutions.min_quantity, rtype_solutions.rtype_type as type, rtype_solutions.unit_capacity,
        solutions.id as solution_id, solutions.capacity as capacity
      from rtypes
        inner join rtype_solutions on rtype_solutions.rtype_id = rtypes.id
        inner join solutions on rtype_solutions.solution_id = solutions.id
      and solutions.product_id = #{@product.id};")
      .group_by{|struct| struct.type}

      analytics_url = request.protocol + request.host + "/analytics"
      @ap = {solutions: configurations, accessories: rtypes['accessory'] || [], parts: rtypes['part'] || [], ca: rtypes['configured_accessory'], analytics_url: analytics_url}
      if request.xhr?
        render 'show.js.erb'
      else
        render 'show.html'
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
end
