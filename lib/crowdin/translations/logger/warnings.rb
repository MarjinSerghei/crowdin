module Crowdin
  module Translations
    module Logger
      module Warnings
        MSGS = Configuration::Messages::Warnings.load

        def each
          MSGS.each { |msg, color| yield msg, color } if block_given?
        end

        def add(msg, color)
          MSGS[msg] = color if msg.is_a?(String) && msg.respond_to?(color.to_sym)
        end

        module_function :each, :add
      end
    end
  end
end
