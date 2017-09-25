module Crowdin
  module Configuration
    module Messages
      def load
        file = File.join __FILE__.gsub(/\.rb/, ".yml")
        YAML.load_file(file).fetch("messages", {})
      end

      module_function :load

      module Extractor
        # :reek:NestedIterators and :reek:DuplicateMethodCall and :reek:TooManyStatements
        def call(messages)
          messages.each_key.with_object({}) do |scope, msgs|
            context = messages[scope]
            context.each_key do |rule|
              msg = context[rule]["msg"]
              color = context[rule]["color"]
              msgs.merge!(msg => color)
            end
          end
        end

        module_function :call
      end

      module Warnings
        def load
          messages = Messages.load.fetch("warnings", {})
          Messages::Extractor.call(messages)
        end

        module_function :load
      end
    end
  end
end
