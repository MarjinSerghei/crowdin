module Crowdin
  module Translations
    module Endpoints
      class DeleteDirectoryEndpoint < Endpoint
        def call(options = {})
          RestClient.post(url, options)
        rescue RestClient::ResourceNotFound
          name = options[:name]
          Crowdin::Translations::Logger.warning "No such folder: #{name}/ in current Crowdin project.", color: :blue
        end
      end
    end
  end
end
