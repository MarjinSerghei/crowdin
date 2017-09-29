module Crowdin
  module Translations
    class Endpoint
      def initialize(endpoint:)
        @endpoint = endpoint
      end

      def call
        raise NotImplementedError, "Abstract method"
      end

      private

      def endpoint
        (@endpoint.to_s + "_endpoint").camelize
      end

      def url
        Crowdin.configuration.fetch(:api) + resource + Crowdin.configuration.fetch(:api_key)
      end

      def resource
        @endpoint.to_s.tr("_", "-") + url_params + "?key="
      end

      def url_params
        ""
      end

      def error_message(error)
        Nokogiri::XML(error.response.body).css("message").text
      end
    end
  end
end
