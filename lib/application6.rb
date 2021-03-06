#<pre><code class="ruby">
require 'hotcocoa'
require 'erb'
framework 'webkit'
class Application
  include HotCocoa
  FULL={:expand => [:width,:height]}
  LINE="They typed <span class='cmd'><%=cmd%></span>"
  BASE=<<-END
  <html><head><style type='text/css'>
  * { font-family: Monaco; }
  .cmd { color:red; }
  </style></head><body><h3>Hello ERB</h3></body></html>
  END
  def initialize
    @line=Proc.new {|cmd| ERB.new(LINE).result(binding)}
  end
  def document
    @web_view.mainFrame.DOMDocument
  end
  def write(cmd)
    root = document.createElement("div");
    root.innerHTML=@line.call(cmd);
    document.body.appendChild(root)
  end
  #basically onload event (frameLoadDelegate)
  def webView view, didFinishLoadForFrame: frame
    write("first")
    write("second")
  end
  def start
    application :name => "MyErbTemplate" do |app|
      app.delegate = self
      window :title => "MyErbTemplate",
        :frame => [10, 620, 330, 230] do |win|
        win << @web_view=web_view(:layout => FULL) do |wv|
          wv.mainFrame.loadHTMLString BASE, baseURL: nil
          wv.frameLoadDelegate=self
        end
        win.will_close { exit }
      end
    end
  end
end
Application.new.start
#</code></pre>