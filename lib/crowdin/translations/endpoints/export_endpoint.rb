module Crowdin
  module Translations
    module Endpoints
      class ExportEndpoint < Endpoint
        def call
          Crowdin::Translations::Logger.info RestClient.get(url), color: :green
        end
      end
    end
  end
end
