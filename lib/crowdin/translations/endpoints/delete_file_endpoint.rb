module Crowdin
  module Translations
    module Endpoints
      class DeleteFileEndpoint < Endpoint
        def call(file:)
          RestClient.post(url, file: file)
        rescue RestClient::BadRequest => error
          Crowdin::Translations::Logger.warning error_message(error), color: :yellow
        end
      end
    end
  end
end
