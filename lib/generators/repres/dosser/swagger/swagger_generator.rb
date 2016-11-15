# rails generate repres:dosser:swagger administration --version 2
require 'rails/generators'

class Repres::Dosser::SwaggerGenerator < Rails::Generators::NamedBase

  # https://github.com/erikhuda/thor/blob/master/lib/thor/base.rb#L273
  class_option :version, type: :numeric, required: false, default: 1, desc: 'a positive integer, the default value is 1'

  source_root File.expand_path('../templates', __FILE__)

  def produce

    bind_options

    generate 'repres:dosser:platform', "#{@platform_name} --version #{@version_number}"

    generate_gemfile
    generate_initializer
    generate_swagger
    generate_route

  end

  def bind_options
    @platform_name          = file_name.downcase
    @version_number         = options['version'].to_i
    @platform_module_name   = @platform_name.camelize
    @version_module_name    = "V#{@version_number}"
    @version_name           = "v#{@version_number}"
    @application_name       = application_name
    @application_name_const = application_name.upcase
  end

  # gemfile
  #
  #   Gemfile
  #
  def generate_gemfile
    gem 'swagger_engine'
  end

  # initializer
  #
  #   config/initializers/swagger_engine.rb
  #
  def generate_initializer
    template 'config/initializers/swagger_engine.rb.erb', 'config/initializers/swagger_engine.rb'

    line = "'#{@platform_module_name} API #{@version_name}': 'lib/swagger/#{@platform_name}_api_#{@version_name}.json'"
    file = Rails.root.join 'config', 'initializers', 'swagger_engine.rb'
    if :invoke==behavior
      puts "Please make sure the following line is in the file #{file}:\n\n    #{line}\n\n"
    elsif :revoke==behavior
      puts "Please remove the following line from the file #{file}:\n\n    #{line}\n\n"
    end

  end

  # swagger
  #
  #   lib/swagger/{platform}_api_{version}.json
  #
  def generate_swagger
    template 'lib/swagger/api.json.erb', "lib/swagger/#{@platform_name}_api_#{@version_name}.json"
  end

  # route
  #
  #   config/routes.rb
  #
  def generate_route
    source  = File.expand_path find_in_source_paths('config/routes.rb.erb')
    content = ERB.new(File.binread(source).strip, nil, '-', "@output_buffer").result instance_eval('binding')
    route content
  end

  private :generate_gemfile, :generate_initializer, :generate_swagger, :generate_route

end
