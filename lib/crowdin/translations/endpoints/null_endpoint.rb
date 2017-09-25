module Crowdin
  module Translations
    module Endpoints
      class NullEndpoint < Endpoint
        def call(*)
          raise NotImplementedError, Crowdin::Translations::Logger.warning(
            "#{endpoint} could not be found. Fallback to NullEndpoint.", :red
          )
        end
      end
    end
  end
end
