module GridHelper
  class Railtie < Rails::Railtie
    rake_tasks do
      require "css_grid/rake"
    end
  end
end