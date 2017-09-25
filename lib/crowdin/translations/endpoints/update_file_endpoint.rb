module Crowdin
  module Translations
    module Endpoints
      class UpdateFileEndpoint < Endpoint
        def call(files:, update_option: :update_without_changes)
          RestClient.post(url, files: files, update_option: update_option)
        rescue RestClient::ResourceNotFound, RestClient::BadRequest => error
          Crowdin::Translations::Logger.warning error_message(error), color: :yellow
        end
      end
    end
  end
end
