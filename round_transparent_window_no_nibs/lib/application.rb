require 'hotcocoa'
SOURCE_DIR = File.expand_path(File.dirname(__FILE__))
require SOURCE_DIR + '/custom_view_behaviors'
require SOURCE_DIR + '/custom_window_behaviors'

class Application
  include HotCocoa
  
  def start
    application :name => "HotCocoa: Round Transparent Window" do |app|
      app.delegate = self
      @main_window = window :frame => [434, 297, 128, 128],
                            :title => "no border",
                            :style => [:borderless] do |win|
        win.setBackgroundColor(color(:name => 'clear'))
        win.level = NSStatusWindowLevel #ontop of all
        win.alphaValue = 1.0 #transparency
        win.opaque = false
        win.hasShadow = true
        win.extend(CustomWindowBehaviors) #drag support
        win.contentView.extend(CustomViewBehaviors) #override drawRect
        #:size => [42,42]
        win << button(:text => 'Bug',  :layout => {:align => :center, }, :on_action => lambda { |s|
          puts "clicked"
          })
      end
    end
  end
  
  # def slider_layout(label, &block)
  #   layout_view(:frame => [42, 42, 42,42] :on_action => lambda { |s}) do |view|
  #     view << label(:text => label, :layout => {:align => :center})
  #     s = slider :min => 0, :max => 1.0, :layout => {:expand => :width, :align => :top}, :on_action => lambda { |slider|
  #       win.alphaValue = slider.floatValue #0-1
  #       win.display #redraw
  #       }
  #     s.floatValue = 1.0
  #     s.frameSize  = [0, 24]
  #     view << s
  #   end
  # end
  
  # file/open
  def on_open(menu)
  end
  
  # file/new 
  def on_new(menu)
  end
  
  # help menu item
  def on_help(menu)
  end
  
  # This is commented out, so the minimize menu item is disabled
  #def on_minimize(menu)
  #end
  
  # window/zoom
  def on_zoom(menu)
  end
  
  # window/bring_all_to_front
  def on_bring_all_to_front(menu)
  end
  
end

Application.new.start
