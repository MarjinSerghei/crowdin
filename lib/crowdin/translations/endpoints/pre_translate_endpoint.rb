module Crowdin
  module Translations
    module Endpoints
      class PreTranslateEndpoint < Endpoint
        # rubocop:disable Metrics/LineLength, Metrics/ParameterLists
        # :reek:LongParameterList and :reek:BooleanParameter
        def call(languages:, files:, method: :tm, engine: :microsoft, approve_translated: false, import_duplicates: true, apply_untranslated_strings_only: false, perfect_match: false)
          RestClient.post(
            url,
            languages: languages,
            files: files,
            method: method.to_s,
            engine: engine,
            approve_translated: approve_translated,
            import_duplicates: import_duplicates,
            apply_untranslated_strings_only: apply_untranslated_strings_only,
            perfect_match: perfect_match
          )
        rescue RestClient::BadRequest, RestClient::InternalServerError => error
          Crowdin::Translations::Logger.warning error_message(error), color: :red
        end
      end
    end
  end
end
