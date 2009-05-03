require 'hotcocoa'
framework 'webkit'
class Application
  include HotCocoa
  def content_body #html/body/div.content
    document.getElementById('content')
  end
  def document
    @web_view.mainFrame.DOMDocument
  end
  def write_text(cmd)
    cdiv=document.createElement('div')
    cdiv.innerText=cmd
    content_body.appendChild(cdiv)
  end
  def local_page_url
    bundle=NSBundle.mainBundle
    raise "no mainBundle" unless bundle
    path=NSBundle.pathForResource("index",
        :ofType => "html",
        :inDirectory => bundle.bundlePath)
    raise "no Contents/Resources/index.html" unless path
    "file://#{path}"
  end
  FULL={:expand => [:width,:height]}
  def start
    application :name => "Myapp" do |app|
      app.delegate = self
      window :title => "Myapp",
        :frame => [50, 500, 330, 330] do |win|
        win << split_view(:horizontal => true,
          :layout => FULL) do |sv|
          sv << @web_view=web_view(:url =>local_page_url,
            :frame => [0,0,0,300], :layout => FULL)
          sv << @prompt=text_field(:text => 'type here',
            :frame => [0,0,0,100], :layout => FULL, 
            :font => font(:name=>'Monaco', :size => 16),
            :on_action => Proc.new { |p|
              write_text(p.to_s)
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
