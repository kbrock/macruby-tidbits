require 'hotcocoa'
require 'erb'
framework 'webkit'
class Application
  include HotCocoa
  def initialize
    base_erb=ERB.new(%Q{<html><head>
<style type="text/css">* { font-family: Monaco; }
.cmd { color:red}</style></head>
<body><h3><%=title%></h3><div id='content'></div></body>
</html>})
    template_erb=ERB.new(%Q{the person typed
      <span class="cmd"><%=cmd%></span>})
    @base = Proc.new { |title|
      base_erb.result(binding)
    }
    @template = Proc.new { |cmd|
      template_erb.result(binding)
    }
  end
  def document
    @web_view.mainFrame.DOMDocument
  end
  def write_text(cmd)
    root = document.createElement('div');
    root.innerHTML = @template.call(cmd);
    document.getElementById('content').appendChild(root)
  end
  #aka 'onload' event (see frameLoadDelegate)
  def webView view, didFinishLoadForFrame: frame
    write_text("first thing")
    write_text("second thing")
  end
  FULL={:expand => [:width,:height]}
  def start
    application :name => "MyErbTemplate" do |app|
      app.delegate = self
      window :title => "MyErbTemplate",
        :frame => [10, 620, 330, 230] do |win|
        win << @web_view = web_view(:layout => FULL) do |wv|
          wv.mainFrame.loadHTMLString @base.call('Hello ERB'),
            baseURL: nil
          wv.frameLoadDelegate = self #didFinishLoadForFrame
        end
        win.contentView.margin = 5
        win.will_close { exit }
      end
    end
  end
end
Application.new.start
