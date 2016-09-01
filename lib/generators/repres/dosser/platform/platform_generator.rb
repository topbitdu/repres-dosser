# rails generate repres:dosser:platform administration --version 2

class Repres::Dosser::PlatformGenerator < Rails::Generators::NamedBase

  # https://github.com/erikhuda/thor/blob/master/lib/thor/base.rb#L273
  class_option :version, type: :numeric, required: false, default: 1, desc: 'a positive integer, the default value is 1'

  source_root File.expand_path('../templates', __FILE__)

  def produce

    @platform_name  = file_name.downcase
    @version_number = options['version'].to_i

    generate_controller
    generate_route

  end

  def define_namespace(content)
    content.gsub! /PlatformModuleName/, platform_module_name
    content.gsub! /VersionModuleName/,  version_module_name
    content.gsub! /platform_name/,      platform_name
    content.gsub! /version_name/,       version_name
    content.gsub! /version_number/,     version_number.to_s
    content
  end

  # controller
  #
  #   app/controllers/platform/version/presentation_controller.rb
  #   app/controllers/platform/version/portals_controller.rb
  #
  def generate_controller
    copy_file('app/controllers/presentation_controller.rb', "app/controllers/#{platform_name}/dosser/#{version_name}/presentation_controller.rb") { |content| define_namespace content }
    copy_file('app/controllers/portals_controller.rb',      "app/controllers/#{platform_name}/dosser/#{version_name}/portals_controller.rb"     ) { |content| define_namespace content }
  end

  # route
  #
  #   config/routes.rb
  #
  def generate_route
    source = File.expand_path find_in_source_paths('config/routes.rb')
    File.open(source, 'rb') { |f| route define_namespace(f.read.to_s.strip) }
  end

  # Administration
  def platform_module_name
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
    :generate_controller,  :generate_route,
    :platform_module_name, :platform_name,  :platform_version_module_name,
    :version_module_name,  :version_name,   :version_number

end
