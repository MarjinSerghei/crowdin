module Crowdin
  module Translations
    module Endpoints
      class DownloadEndpoint < Endpoint
        def call(locale:)
          @locale = locale

          return yield self, RestClient.get(url) if block_given?

          raise ArgumentError, Crowdin::Translations::Logger.colorize(
            "Please supply a block with 2 args: -> (endpoint, response) and save the response as a file.", :red
          )
        end

        private

        def url_params
          "/" + @locale + ".zip"
        end
      end
    end
  end
end
