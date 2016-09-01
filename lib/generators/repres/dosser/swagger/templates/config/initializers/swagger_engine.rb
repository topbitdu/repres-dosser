SwaggerEngine.configure do |config|

  config.admin_username = ENV['APPLICATION_NAME_SWAGGER_USERNAME']||'swagger'
  config.admin_password = ENV['APPLICATION_NAME_SWAGGER_PASSWORD']||'application_name'

  config.json_files = {
    'PlatformModuleName API version_name': 'lib/swagger/platform_name_api_version_name.json'
  }

end
