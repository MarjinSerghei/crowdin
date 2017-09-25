module Crowdin
  module Translations
    module Endpoints
      class AddFileEndpoint < Endpoint
        def call(args)
          RestClient.post(url, files: args)
        rescue RestClient::BadRequest => error
          Crowdin::Translations::Logger.warning error_message(error), color: :yellow
        end
      end
    end
  end
end
