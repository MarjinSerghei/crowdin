module Crowdin
  module Translations
    module Endpoints
      class LanguageStatusEndpoint < Endpoint
        # :reek:NestedIterators and :reek:TooManyStatements
        def call(language:)
          translations = Hash.from_xml(RestClient.post(url, language: language).body).dig("status", "files", "item")

          stats = translations.each_with_object(%w()) do |locale, statistics|
            statistics << locale.reject { |node, _| node =~ /files|node_type|id/ }
          end

          stats.each { |locale| Crowdin::Translations::Logger.info locale.inspect, color: :green }
        rescue RestClient::BadRequest, RestClient::ResourceNotFound => error
          Crowdin::Translations::Logger.warning error_message(error), color: :yellow
        end
      end
    end
  end
end
