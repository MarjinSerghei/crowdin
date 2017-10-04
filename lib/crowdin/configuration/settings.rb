module Crowdin
  module Configuration
    module Settings
      def all
        file = File.join(__dir__, 'settings.yml')

        YAML.load_file(file).fetch("settings", {})
      end

      def options
        @options ||= all
      end

      module_function :all, :options

      options.each_key do |option|
        define_method(option) { options[option] }
        module_function option
      end
    end
  end
end
