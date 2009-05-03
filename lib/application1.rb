require 'hotcocoa'
class Application
  include HotCocoa
  def start
    application :name => "Myapp" do |app|
      app.delegate = self
      window :frame => [100, 100, 500, 500],
             :title => "Myapp" do |win|
        win << label( :text => "Hello World",
                      :layout => {:start => false})
        win.will_close { exit }
      end
    end
  end
end
Application.new.start