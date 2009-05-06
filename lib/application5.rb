require 'hotcocoa'
require 'erb'
framework 'webkit'
class Application
  include HotCocoa
  FULL={:expand => [:width,:height]}
  def loadFile(name,type,erb=false)
    @bundle||=NSBundle.mainBundle
    raise "no mainBundle" unless @bundle
    path=NSBundle.pathForResource(name,
        :ofType => type,
        :inDirectory => @bundle.bundlePath)
    raise "no resource #{name}.#{type}" unless path
    ret="file://#{path}"
    if erb
      template=ERB.new(IO.readlines(path).to_s)
      ret=Proc.new { |params| template.result(binding)}
    end
  end
  def initialize
    @page_url=loadFile("index","html")
    @line=loadFile("line","erb",true)
  end
  def content_body #html/body/div.content
    document.getElementById('content')
  end
  def document
    @web_view.mainFrame.DOMDocument
  end
  def write(cmd)
    cdiv=document.createElement('div')
    cdiv.innerText=@line.call(cmd)
    content_body.appendChild(cdiv)
  end
  def start
    application :name => "Myapp" do |app|
      app.delegate = self
      window :title => "Myapp",
        :frame => [50, 500, 330, 330] do |win|
        win << split_view(:horizontal => true,
          :layout => FULL) do |sv|
          sv << @web_view=web_view(:url =>@page_url,
            :frame => [0,0,0,300], :layout => FULL)
          sv << @prompt=text_field(:text => 'type here',
            :frame => [0,0,0,100], :layout => FULL, 
            :font => font(:name=>'Monaco', :size => 16),
            :on_action => Proc.new { |p|
              write(p.to_s)
              p.text=''
            })
        end
        win.contentView.margin = 5
        win.makeFirstResponder @prompt
        win.will_close { exit }
      end
    end
  end
end
Application.new.start
