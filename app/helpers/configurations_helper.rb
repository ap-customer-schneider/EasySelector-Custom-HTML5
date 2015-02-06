module ConfigurationsHelper

  def product_subset
    # XXX This is fragile for products with multiple subset options.
    # TODO Add identifier as top level subset
    @product_subset ||= @product.options.select{|option| option.is_subset}.first
  end

  def product_options
    @product_options ||= @product.options.all(order: :sort_order.asc).select{|option| !option.is_subset}
  end

  def sanitize_name(name)
    # Apply same logic to all name fields. Currently only
    # down casing and replacement of non-word characters.
    name.gsub(/\W/,'_').downcase
  end

  def is_type(type, option)
    option.field_type.downcase.to_sym == type.to_sym
  end

  def asset_url asset
    "#{request.protocol}#{request.host_with_port}#{asset_path(asset)}"
  end
end
