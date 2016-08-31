# rails generate repres:dosser:swagger administration --version 2

class Repres::Dosser::SwaggerGenerator < Rails::Generators::NamedBase

  # https://github.com/erikhuda/thor/blob/master/lib/thor/base.rb#L273
  class_option :version, type: :numeric, required: false, default: 1, desc: 'a positive integer, the default value is 1'

  source_root File.expand_path('../templates', __FILE__)

  def produce

    @platform_name  = file_name.downcase
    @version_number = options['version'].to_i

    generate 'repres:dosser:platform', "#{@platform_name} --version #{@version_number}"

    generate_gemfile
    generate_swagger

  end

  def define_namespace(content)
    content.gsub! /PlatformModuleName/, platform_module_name
    content.gsub! /VersionModuleName/,  version_module_name
    content.gsub! /platform_name/,      platform_name
    content.gsub! /version_name/,       version_name
    content.gsub! /version_number/,     version_number.to_s
    content
  end

  # gemfile
  #
  #   Gemfile
  #
  def generate_gemfile
    gem 'swagger_engine'
    gem 'repres-dosser', ">= #{Repres::Dosser::VERSION}"
  end

  # swagger
  #
  #   lib/swagger/administration_api_v1.json
  #
  def generate_swagger
    copy_file('lib/swagger/api.json', "lib/swagger/#{platform_name}_api_#{version_name}.json") { |content| define_namespace content }
  end

  # Administration
  def platform_module_name
    #@platform_name.capitalize
    @platform_name.camelize
  end

  # administration
  def platform_name
    @platform_name
  end

  # Administration::V1
  def platform_version_module_name
    "#{platform_module_name}::Dosser::#{version_module_name}"
  end

  # V1
  def version_module_name
    "V#{version_number}"
  end

  # v1
  def version_name
    "v#{version_number}"
  end

  # 1
  def version_number
    @version_number
  end

  private :define_namespace,
    :generate_gemfile,     :generate_swagger,
    :platform_module_name, :platform_name,    :platform_version_module_name,
    :version_module_name,  :version_name,     :version_number

end
