# Add additional routes
Rails.application.routes.prepend do
  # See: http://rubular.com/r/CK8ggq4HWy
  resources :'product-configurator', only: [:show],
            constraints: {id: /[A-Z0-9]{4}/i},
            controller: :configurations,
            as: :configurations

  resources :'product-preview', only: [:show],
            constraints: {id: /[A-Z0-9]{4}/i},
            controller: :previews,
            as: :previews

  match "/product-configurator/rtype", to: "configurations#rtype_is_published"
  # Admin tool route

  mount ImporterExtension::Engine => '/employee'

  # Make sure analytics always hits latest version
  match 'analytics' => "api/v#{Utility.latest_api_version}/audits#create", :via => :post

end

puts ">>> Starting with Rails.env '#{Rails.env}'"
if Rails.env.production?
  ActionController::Base.cache_store = :dalli_store, { :expires_in => 7.days, :compress => true }
  ActionController::Base.perform_caching = (ENV['PERFORM_CACHING'] == 'TRUE')

  # Hack for proxy relative URL
  #ActionController::Base.relative_url_root = ENV['ASSET_URL_ROOT']

end

module Advisor
  class Application < Rails::Application
    config.time_zone = 'Eastern Time (US & Canada)'
    #config.assets.prefix = '/assets'
    if Rails.env.production?
      #config.action_controller.relative_url_root = ENV['ASSET_URL_ROOT']
    end
    config.middleware.use Rack::Deflater
    config.assets.paths << Rails.root.join("vendor", "gems", "import_extension", "app", "assets")
    # Cors middleware configuration.
    config.middleware.insert_after Rails::Rack::Logger, Rack::Cors, :logger => Rails.logger do
      allow do
        origins '*'
        resource '/assets/*', headers: :any, methods: [:any, :get]
        resource '/analytics', headers: :any, methods: [:any, :post]
        resource '/product-configurator/*', headers: :any, methods: [:any, :get]
      end
    end

  end
end

module DataMapper
  module Timestamps

    # Saves the record with the updated_at/on attributes set to the current time.
    def touch
      set_timestamps
      retval = save
      self.class.relationships.values.select do |rel|
        case rel.class.to_s.deconstantize.demodulize
          when 'ManyToOne', 'OneToOne'
            assoc = rel.instance_variable_name.gsub('@','').to_sym
            obj = self.send(assoc)
            # TODO Should we join the retvals to assert that all touches have succeeded?
            obj.touch if obj.present?
        end
      end
      retval
    end
  end
end


