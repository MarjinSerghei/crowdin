module Crowdin
  module Translations
    module Endpoints
      class InfoEndpoint < Endpoint
        attr_reader :locale, :response

        private :locale, :response

        # :reek:TooManyStatements
        def call(locale:)
          @response = RestClient.get(url).body
          @locale = locale
          self
        rescue RestClient::BadRequest, RestClient::ResourceNotFound => error
          Crowdin::Translations::Logger.warning error_message(error), color: :yellow
        end

        # :reek:NestedIterators
        def files
          parse_response_items do |resource|
            resource.reduce([]) { |items, item| items << extract_files(item) }
              .flatten.map { |file| locale.to_s + "/" + file }
          end
        end

        # :reek:NestedIterators
        def folders
          parse_response_items do |resource|
            resource.reduce([]) { |items, item| items << extract_folders(item) }
              .flatten.map { |folder| (locale.to_s + "/" + folder) }.uniq
          end
        end

        private

        def fetch_response_as_hash
          Hash.from_xml(response)
        end

        def fetch_items
          fetch_response_as_hash.dig("info", "files", "item")
        end

        def parse_response_items
          result = fetch_items.select { |item| item["name"] == locale.to_s }.first.dig("files", "item")

          yield result if block_given?
        end

        # rubocop:disable Metrics/AbcSize
        # :reek:FeatureEnvy and :reek:TooManyStatements
        def extract_files(item, result = [], dirs = [item["name"]])
          item_type = item["node_type"]
          directory = item_type == "directory"

          if directory && item["files"]
            [item.dig("files", "item")].flatten.compact.map do |inner_node|
              dirs << inner_node["name"]
              extract_files(inner_node, result, dirs)
              dirs.pop
            end
          elsif directory
            ""
          else
            result << dirs.join("/")
          end

          result
        end

        # :reek:DuplicateMethodCall and :reek:FeatureEnvy and :reek:TooManyStatements
        def extract_folders(item, result = [], dirs = [item["name"]])
          item_type = item["node_type"]
          directory = item_type == "directory"

          if directory && item["files"]
            [item.dig("files", "item")].flatten.compact.map do |inner_node|
              dirs << inner_node["name"]
              extract_folders(inner_node, result, dirs)
              dirs.pop
              result << dirs.join("/")
            end
          elsif directory
            result << dirs.join("/")
          else
            ""
          end

          result
        end
      end
    end
  end
end
