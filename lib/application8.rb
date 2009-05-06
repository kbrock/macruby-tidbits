#<pre><code class="ruby">
require 'hotcocoa'
framework 'webkit'
class Application
  include HotCocoa
  FULL={:expand => [:width,:height]}
  BASE=<<-END
    <html><head><style type="text/css">
    * { font-family: Monaco; }
    </style><script type="text/javascript">
    function say(arg) { window.TheBridge.click(arg);}
    </script>
    </head><body><h3>Ruby JavaScript Bridge</h3>
    <a href="#" onclick="say('hi')">tell</a></body></html>
  END
  def click(arg) #called from javascript
    root = document.createElement("div");
    root.innerHTML="javascript tells ruby: #{arg}"
    document.body.appendChild(root)
  end
  def document
    @web_view.mainFrame.DOMDocument
  end
  def self.webScriptNameForSelector(sel) #hide : in name
    sel.to_s.sub(/:$/,'') if is_available_selector?(sel)
  end
  def self.isSelectorExcludedFromWebScript(sel)
    ! is_available_selector?(sel)
  end
  def self.isKeyExcludedFromWebScript(key)
    true
  end
  def self.is_available_selector?(sel)
    ['click:'].include?(sel.to_s)
  end
  def start
    application :name => "MyBridge" do |app|
      app.delegate = self
      window :title => "MyBridge",
        :frame => [10, 620, 330, 230] do |win|
        win << @web_view=web_view(:layout => FULL) do |wv|
          wv.mainFrame.loadHTMLString BASE, baseURL: nil
          wv.frameLoadDelegate=self
          wso=wv.windowScriptObject #make visible to JS
          wso.setValue(self, forKey:"TheBridge")
        end
        win.will_close { exit }
      end
    end
  end
end
Application.new.start
#</code></pre>