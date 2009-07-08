framework 'ScriptingBridge'
require 'hotcocoa'
require 'hotcocoa/graphics'
include HotCocoa
#temporary
@safari = SBApplication.applicationWithBundleIdentifier('com.apple.Safari')
@safari.classForScriptingClass('document').alloc.initWithProperties({:URL => 'http://www.yahoo.com'})


SafariDocument.initWithProperties({:URL => 'http://www.yahoo.com', :source => '', :text => ''})

#SafariDocument
#@safari.documents << 

require File.dirname(__FILE__)+"/bezel.rb";

class Application
  include HotCocoa
  def start
    application :name => "Report Bug" do |app|
      app.delegate = self
      @main_window = bezel_window(
        :frame => [450,300,128,128]) do |win|
          win << bezel_button(:title=>"find it",
            :on_action=>lambda { |s| doit })
          win << bezel_button(:title=>"Quit",
            :on_action=>lambda { |s| exit })
      end
    end
  end
  def open_url(url)
    # tell application "Safari"
    #     make new document at end of documents
    #     set URL of first document to "http://www.google.com/"
    # end tell
    
    # #2: http://www.cocoadev.com/index.pl?ScriptingBridgeAndMail
    #doc=@safari.classForScriptingClass('document').alloc.initWithProperties({:URL => 'http://www.yahoo.com'})
    #@safari.documents.addObjects(doc)
    @safari.documents.first.URL=url
  end
  def fill_field(field,value)
    safari_do "document.#{field}.value='#{value}'"
  end
  def submit(form)
    safari_do "document.#{form}.submit()"
  end
  def safari_do(cmd)
    @safari.performSelector(:"doJavaScript:in:", withObject:cmd, withObject:@google_tab)
  end
  def doit
    @safari = SBApplication.applicationWithBundleIdentifier('com.apple.Safari')
    #also have front document
    open_url('http://www.google.com/')
    @google_tab=@safari.windows.first.currentTab
    fill_field "f.q","macruby"
    submit 'f'
  end
end
Application.new.start
#thanks: http://griddlenoise.blogspot.com/2007/11/applescripting-across-universe.html
#thanks: @lrc
