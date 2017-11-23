module Crowdin
  module Translations
    module Endpoints
      class ExportEndpoint < Endpoint
        def call
          Crowdin::Translations::Logger.info(
            RestClient::Request.execute(method: :get, url: url, timeout: 100),
            color: :green
          )
        end
      end
    end
  end
end
