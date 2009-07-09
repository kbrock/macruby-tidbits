require 'hotcocoa'
include HotCocoa
require "lib/bezel.rb"
framework 'ScriptingBridge'

class Application
  def start
    application :name => "Ask Google" do |app|
      app.delegate = self
      @main_window = bezel_window(
        :frame => [450,300,128,128],
        :buttons => [
          ["Google it",lambda { |s| doit }],
          ["Quit",lambda { |s| exit }]
        ])
    end
  end
  def open_url(url)
    # tell application "Safari"
    #     make new document at end of documents
    # end tell
    #doc=@safari.classForScriptingClass('document').alloc.initWithProperties({'URL' => url})
    #@safari.documents.addObjects(doc)
    @safari.documents.first.URL=url
    sleep(1) #wait for safari to load url
    @safari.windows.first.currentTab
  end
  def fill_form(tab,form,values={})
    values.each_pair do |n,v|
      safari_do tab,"document.#{form}.#{n}.value='#{v}'"
    end
    safari_do tab,"document.#{form}.submit()"
  end
  def safari_do(tab,cmd)
    @safari.doJavaScript(cmd, :'in'=>tab)
  end
  def doit
    @safari = SBApplication.applicationWithBundleIdentifier('com.apple.Safari')
    @safari.activate #bring to front
    tab=open_url('http://www.google.com/')
    fill_form tab,:f, :q=>"macruby"
  end
end
Application.new.start
#thanks: <a href="http://griddlenoise.blogspot.com/2007/11/applescripting-across-universe.html">python guy</a> and
#thanks: <a href="http://twitter.com/lrc">@lrc</a>
#thanks open_url => http://www.cocoadev.com/index.pl?ScriptingBridgeAndMail
