class PlatformModuleName::Dosser::VersionModuleName::PortalsController < PlatformModuleName::Dosser::VersionModuleName::PresentationController

  def show
    render_ok collection: [
      {
        name: 'PlatformModuleName API version_name',
        links: [
          { rel: 'self',      href: platform_name_dosser_version_name_portal_url(Unidom::Common::SELF, format: request.format.symbol) },
          { rel: 'canonial',  href: platform_name_dosser_version_name_portal_url(Unidom::Common::SELF, format: :json                ) },
          { rel: 'alternate', href: platform_name_dosser_version_name_portal_url(Unidom::Common::SELF, format: :xml                 ) }
        ]
      }
    ]
  end

end
