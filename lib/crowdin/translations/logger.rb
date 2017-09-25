module Crowdin
  module Translations
    module Logger
      include Colorizer

      def info(msg, color:)
        $stdout.puts colorize(msg, color)
      end

      def colorize(msg, color)
        msg.respond_to?(color) ? msg.public_send(color) : msg
      end

      alias_method :debug, :info
      alias_method :warning, :info

      module_function :debug, :info, :colorize, :warning
    end
  end
end
