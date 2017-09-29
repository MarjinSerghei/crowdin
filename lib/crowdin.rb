%w(crowdin/version pathname yaml zip rest-client).each { |dependency| require dependency }

require_relative "crowdin/configuration/messages.rb"
require_relative "crowdin/configuration/settings.rb"
require_relative "crowdin/translations/folder_detector.rb"
require_relative "crowdin/translations/logger/colorizer.rb"
require_relative "crowdin/translations/logger.rb"
require_relative "crowdin/translations/logger/warnings.rb"
require_relative "crowdin/translations/endpoint.rb"
require_relative "crowdin/translations/endpoint_locator.rb"
require_relative "crowdin/translations/endpoints/add_file_endpoint.rb"
require_relative "crowdin/translations/endpoints/change_directory_endpoint.rb"
require_relative "crowdin/translations/endpoints/add_directory_endpoint.rb"
require_relative "crowdin/translations/endpoints/delete_directory_endpoint.rb"
require_relative "crowdin/translations/endpoints/delete_file_endpoint.rb"
require_relative "crowdin/translations/endpoints/download_endpoint.rb"
require_relative "crowdin/translations/endpoints/info_endpoint.rb"
require_relative "crowdin/translations/endpoints/null_endpoint.rb"
require_relative "crowdin/translations/endpoints/language_status_endpoint.rb"
require_relative "crowdin/translations/endpoints/export_endpoint.rb"
require_relative "crowdin/translations/endpoints/pre_translate_endpoint.rb"
require_relative "crowdin/translations/endpoints/update_file_endpoint.rb"

module Crowdin
  def configure(api:, api_key:)
    configuration[:api] = api if api
    configuration[:api_key] = api_key if api_key
  end

  def configurable
    Crowdin::Translations::Logger.info <<-EOF
      api: <value>
      api_key: <value>
    EOF
  end

  def configuration
    @configuration ||= { api: Configuration::Settings.api, api_key: Configuration::Settings.api_key }
  end

  def root
    File.dirname(__dir__)
  end

  def lib
    File.join(root, 'lib')
  end

  module_function :configure, :configurable, :configuration, :root, :lib
end
