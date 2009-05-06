#<pre><code class="ruby">
require 'hotcocoa'
require 'erb'
require 'lib/http_request_callback'
require 'lib/twitter_api'
framework 'webkit'
class Application
  include HotCocoa
  FULL={:expand => [:width,:height]}
#  LINE="<%=tweet.person%> said <span class='cmd'><%=tweet.result%></span>"
  LINE="<%=tweet%>"
  BASE=<<-END
  <html><head><style type='text/css'>
  * { font-family: Monaco; }
  .cmd { color:red; }
  </style></head><body><h3>Hello Web</h3></body></html>
  END
  def initialize
    @line=Proc.new {|tweet| ERB.new(LINE).result(binding)}
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
    showTimeline
  end
  def showTimeline()
    twitter = TwitterApi.new(:username => 'kbrock', :password => )
    twitter.getTimeline(lambda { |data|
      write data.inspect
      File.open('/Users/kbrock/friends.json', 'w') { |f|
        f.write(data.inspect)
      }
    })
  end
  def start
    application :name => "MyWebConnect" do |app|
      app.delegate = self
      window :title => "MyWebConnect",
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