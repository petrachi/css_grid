namespace "css:grid" do
  desc "Copy grid.scss"
  task :setup => :environment do
    stylesheet_file = Rails.root.join(if Rails.configuration.respond_to?(:assets) && Rails.configuration.assets.enabled
      "app/assets/stylesheets/"
    else
      "public/stylesheets"
    end, "i18n.js")
    
    # Copy stylesheet file to <tt>public/stylesheets/grid.css</tt>.
    FileUtils.cp(File.dirname(__FILE__) + "/../assets/stylesheets/grid.scss", javascript_file) unless Rails.version >= "3.1"
  end
end