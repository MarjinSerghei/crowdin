module Crowdin
  module Translations
    module Endpoints
      class ChangeDirectoryEndpoint < Endpoint
        def call(options = {})
          RestClient.post(url, options)
        rescue RestClient::BadRequest, RestClient::NotFound => error
          Crowdin::Translations::Logger.warning error_message(error), color: :yellow
        end
      end
    end
  end
end
