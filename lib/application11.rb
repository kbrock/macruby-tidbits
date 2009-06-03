framework 'ScriptingBridge'
require 'hotcocoa'
require 'hotcocoa/graphics'
include HotCocoa
require File.dirname(__FILE__)+"/bezel.rb";

class Application
  include HotCocoa
  def start
    application :name => "Report Bug" do |app|
      app.delegate = self
      @main_window = bezel_window(
        :frame => [450,300,128,128]) do |win|
          win << bezel_button(:title=>"Bug",
            :on_action=>lambda { |s| doit })
          win << bezel_button(:title=>"Quit",
            :on_action=>lambda { |s| exit })
      end
    end
  end
  def safari_do(cmd)
    @safari.performSelector(:"doJavaScript:in:", withObject:cmd, withObject:@google_tab)
  end
  def doit
    @safari = SBApplication.applicationWithBundleIdentifier('com.apple.Safari')
    @google_tab=safari.windows.first.currentTab
    safari_do "document.f.q.value='mac ruby'"
  end
end
Application.new.start
#thanks: http://griddlenoise.blogspot.com/2007/11/applescripting-across-universe.html
#thanks: @lrc
