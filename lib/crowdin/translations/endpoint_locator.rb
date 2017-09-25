module Crowdin
  module Translations
    class EndpointLocator
      # :reek:TooManyStatements
      def initialize
        endpoint_names.each do |filename|
          filename = filename.to_s
          localizer = filename.sub(/_endpoint/, "").to_sym
          const = filename.camelize
          endpoints[localizer] = Endpoints.const_get(const)
        end

        self
      end

      # rubocop:disable Rails/Delegate
      def [](locator)
        endpoints[locator]
      end

      alias_method :find, :[]

      private

      def endpoint_names
        translation_endpoints.each_with_object(%w()) do |full_path, endpoints|
          endpoint_name = File.basename(full_path, File.extname(full_path))
          endpoints << endpoint_name.to_sym
        end
      end

      def translation_endpoints
        Dir[File.dirname(__FILE__) + "/endpoints/*.{rb}"]
      end

      def endpoints
        @endpoints ||= {}
      end
    end
  end
end
