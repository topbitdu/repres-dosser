require 'unidom'

class PlatformModuleName::Dosser::VersionModuleName::PresentationController < ActionController::Base

  clear_helpers

  include Repres::Dosser::Concerns::ResourcePresentation

  layout nil

  before_action :load_unidom

  def load_unidom
    initialize_unidom
  end

end
