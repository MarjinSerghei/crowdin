module Crowdin
  module Translations
    Logger::Warnings.each { |msg, col| Logger.warning msg, color: col }

    def endpoint(name)
      locator = EndpointLocator.new
      (locator[name] || Endpoints::NullEndpoint).new(endpoint: name)
    end

    module_function :endpoint
  end
end
