require 'hotcocoa'
framework 'webkit'
class Application
  include HotCocoa
  FULL={:expand => [:width,:height]}
  def start
    application :name => "MySplitView" do |app|
      app.delegate = self
      window :title => "MySplitView",
        :frame => [10, 620, 330, 230] do |win|
        win << split_view(:horizontal => true,
          :layout => FULL) do |sv|
          sv << web_view(:url =>nil,
             :frame => [0,0,0,200], :layout => FULL)
          sv << @prompt = text_field(:text => 'type here',
             :frame => [0,0,0,100], :layout => FULL, 
             :font => font(:name=>'Monaco', :size => 16))
        end
        win.contentView.margin = 5
        win.makeFirstResponder @prompt
        win.will_close { exit }
      end
    end
  end
end
a=Application.new.start
