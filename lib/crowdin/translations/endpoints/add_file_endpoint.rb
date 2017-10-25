module Crowdin
  module Translations
    module Endpoints
      class AddFileEndpoint < Endpoint
        def call(files:)
          RestClient.post(url, files: files)
        rescue RestClient::BadRequest, RestClient::InternalServerError => error
          Crowdin::Translations::Logger.warning error_message(error), color: :yellow
        end
      end
    end
  end
end
