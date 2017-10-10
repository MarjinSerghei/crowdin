module Crowdin
  module Translations
    module Endpoints
      class UpdateFileEndpoint < Endpoint
        def call(files:, update_option: :update_without_changes, escape_quotes: 2)
          files_to_update = files.each_with_object({}) do |pair, updated|
            pair.each_key { |name| updated[name] = pair[name] }
          end

          RestClient.post(url, files: files_to_update, update_option: update_option)
        rescue RestClient::ResourceNotFound, RestClient::BadRequest, RestClient::InternalServerError => error
          Crowdin::Translations::Logger.warning error_message(error), color: :yellow
        end
      end
    end
  end
end
