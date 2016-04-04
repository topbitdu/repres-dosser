module Repres
  module Dosser

    class Engine < ::Rails::Engine

      config.autoload_paths += %W(
        #{config.root}/lib
        #{config.root}/app/controllers/repres/dosser/concerns
        #{config.root}/app/models/repres/dosser/concerns
      )

      config.eager_load_paths += %W(
        #{config.root}/lib
        #{config.root}/app/controllers/repres/dosser/concerns
        #{config.root}/app/models/repres/dosser/concerns
      )

      isolate_namespace Repres::Dosser

    end

  end
end
