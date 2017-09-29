module Crowdin
  module Translations
    module Endpoints
      class LanguageStatusEndpoint < Endpoint
        def call(language:)
          response = RestClient.post(url, language: language).body
          translations = fetch_translations_for(response)
          stats = fetch_stats_for(translations)
          display_stats(stats)
        rescue RestClient::BadRequest, RestClient::ResourceNotFound => error
          Crowdin::Translations::Logger.warning error_message(error), color: :yellow
        end

        private

        def fetch_translations_for(response)
          Hash.from_xml(response).dig("status", "files", "item")
        end

        def fetch_stats_for(translations)
          translations.each_with_object(%w()) do |locale, statistics|
            statistics << locale.reject { |node, _| node =~ /files|node_type|id/ }
          end
        end

        def display_stats(stats)
          stats.each { |locale| Crowdin::Translations::Logger.info locale.inspect, color: :green }
        end
      end
    end
  end
end
