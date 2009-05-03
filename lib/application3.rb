require 'hotcocoa'
framework 'webkit'
class Application
  include HotCocoa
  FULL={:expand => [:width,:height]}
  def local_page_url
    bundle=NSBundle.mainBundle
    raise "no mainBundle" unless bundle
    path=NSBundle.pathForResource("index",
        :ofType => "html",
        :inDirectory => bundle.bundlePath)
    raise "no Contents/Resources/index.html" unless path
    "file://#{path}"
  end
  def start
    application :name => "MyBundle" do |app|
      app.delegate = self
      window :title => "MyBundle",
        :frame => [10, 620, 330, 230] do |win|
          win << web_view(:url =>local_page_url,
            :layout => FULL)
        win.contentView.margin = 5
        win.will_close { exit }
      end
    end
  end
end
Application.new.start
