module Crowdin
  module Translations
    module Endpoints
      class UpdateFileEndpoint < Endpoint
        def call(files:, update_option: :update_without_changes, escape_quotes: 0)
          RestClient.post(url, files: files, update_option: update_option, escape_quotes: escape_quotes)
        rescue RestClient::ResourceNotFound, RestClient::BadRequest => error
          Crowdin::Translations::Logger.warning error_message(error), color: :yellow
        end
      end
    end
  end
end
