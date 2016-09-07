# rails generate repres:dosser:platform administration --version 2

class Repres::Dosser::PlatformGenerator < Rails::Generators::NamedBase

  # https://github.com/erikhuda/thor/blob/master/lib/thor/base.rb#L273
  class_option :version, type: :numeric, required: false, default: 1, desc: 'a positive integer, the default value is 1'

  source_root File.expand_path('../templates', __FILE__)

  def produce

    @platform_name  = file_name.downcase
    @version_number = options['version'].to_i
    bind_options

    generate_controller
    generate_route

  end

  def bind_options
    @platform_module_name = @platform_name.camelize
    @version_module_name  = "V#{@version_number}"
    @version_name         = "v#{@version_number}"
  end

  # controller
  #
  #   app/controllers/platform/version/presentation_controller.rb
  #   app/controllers/platform/version/portals_controller.rb
  #
  def generate_controller
    template 'controllers/portals_controller.rb',      "app/controllers/#{@platform_name}/dosser/#{@version_name}/portals_controller.rb"
    template 'controllers/presentation_controller.rb', "app/controllers/#{@platform_name}/dosser/#{@version_name}/presentation_controller.rb"
  end

  # route
  #
  #   config/routes.rb
  #
  def generate_route
    source  = File.expand_path find_in_source_paths('routes.rb')
    content = ERB.new(File.binread(source).strip, nil, '-', "@output_buffer").result instance_eval('binding')
    route content
  end

  private :bind_options,   :generate_controller,  :generate_route

end
