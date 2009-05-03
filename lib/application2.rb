require 'hotcocoa'
framework 'webkit'
class Application
  include HotCocoa
  def start
    application :name => "Myapp" do |app|
      app.delegate = self
      window :frame => [100, 100, 600, 400],
             :title => "Myapp" do |win|
        win << web_view(:frame => [0,0,200,300],
             :layout => {:expand => [:width, :height]}
             ) do |wv|
          wv.url='http://google.com/'
        end
        win.contentView.margin = 5
        win.will_close { exit }
      end
    end
  end
end
Application.new.start
