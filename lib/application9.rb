#!/usr/bin/env macruby
#taken from CGI::escape - tweaked to fix exception
def escape(string)
  string.gsub(/([^ a-zA-Z0-9_.-]+)/) do
    $1.nil? ? nil : ('%' + $1.unpack('H2' * $1.bytesize).
      compact.join('%').upcase)
  end.tr(' ','+')
end

framework 'ScriptingBridge'
mail = SBApplication.applicationWithBundleIdentifier(
  'com.apple.mail')
mail.selection.each do |msg|
  params=[[:summary,msg.subject.chomp],
    [:description,msg.content.get.chomp]]
  url= "https://trac.eons.dev/newticket?"+
    (params.collect{ |n,v| "#{n}=#{escape(v)}"}.join('&'))
  NSWorkspace.new.openURL(NSURL.URLWithString(url))
end
#thanks to @lrz for help here
#TODO:
#safari = SBApplication.applicationWithBundleIdentifier('com.apple.safari')
#currentTab=safari.windows.last.currentTab
#safari.doJavascript("document.form.summary.value = \"#{msg.subject.chomp}"\"")
#safari.doJavascript("document.form.description.value = \"#{escape(msg.content.get.chomp}"\"")


#see: http://pastie.org/469018
#see: http://developer.apple.com/documentation/Cocoa/Conceptual/RubyPythonCocoa/Articles/UsingScriptingBridge.html
#see: http://www.apple.com/applescript/features/scriptingbridge.html

# tell application "Safari"
#   do JavaScript "document.login.username.value = \"user\";" in document 1
#   do JavaScript "document.login.password.value = \"pass\";" in document 1
#   do JavaScript "document.login.submit();" in document 1
# end tell