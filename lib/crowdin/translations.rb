module Crowdin
  module Translations
    def endpoint(name)
      locator = EndpointLocator.new
      (locator[name] || Endpoints::NullEndpoint).new(endpoint: name)
    end

    module_function :endpoint
  end
end
