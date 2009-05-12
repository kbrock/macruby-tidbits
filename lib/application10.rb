framework 'ScriptingBridge'
require 'hotcocoa'
require 'hotcocoa/graphics'
include HotCocoa
include Graphics
module CustomViewBehaviors
  def redraw
    needsDisplay = true
  end
  def drawRect(rect)
#     NSColor.darkGrayColor.set
#     NSRectFill(bounds)
#    window.invalidateShadow
    @frame_image ||= NSImage.imageNamed("frame.png")
    @frame_image.drawAtPoint([0,0], fromRect:frame,
        operation:NSCompositeSourceOver, fraction:1.0)
    window.invalidateShadow
  end
end
module CustomWindowBehaviors
  def initWithContentRect(contentRect,
      styleMask:aStyle,backing:bufferingType,defer:flag)
    super(contentRect,aStyle,NSBackingStoreBuffered,false)
  end
  def canBecomeKeyWindow
    true
  end
  def mouseDragged(theEvent) #move the window with drag
    cur = loc(mouseLocationOutsideOfEventStream, @start)
    new_origin = NSPoint.new(cur.x, cur.y)

    screen = NSScreen.mainScreen.frame
    new_origin.y = [new_origin.y,
      screen.origin.y+screen.size.height-frame.size.height
      ].min
    self.frameOrigin = new_origin
  end
  def mouseDown(evt) #drag start
    @start = loc(evt.locationInWindow, frame.origin)
  end
  def loc(src1,offset)
    loc=convertBaseToScreen(src1)
    loc.x -= offset.x ; loc.y -= offset.y
    loc
  end
end
class Application
  include HotCocoa
  FULL={:expand => [:width,:height]}
  def start
    application :name => "Report Bug" do |app|
      app.delegate = self
      @main_window = window(:frame => [450,300,128,128],
      :level=>NSStatusWindowLevel,:style=>[:borderless],
      :alphaValue=>0.8,:opaque=>false,:hasShadow=>true
      ) do |win|
        win.setBackgroundColor(color(:name => 'clear'))
        win.extend(CustomWindowBehaviors)
        win.contentView.extend(CustomViewBehaviors)

        win << layout_view(:layout => FULL,
          :frame => [0, 0, 42, 42]) do |view|
          view << bezelbutton("Bug",lambda { |s| sayit })
          view << bezelbutton("Quit",lambda { |s| exit })
        end
      end
    end
  end
  def bezelbutton(title,act)
    button(:bezel=>:recessed,:title=>title,:on_action=>act,
      :layout => {:expand=>[:width],:start => false})
  end  
  def escape(string)
    string.gsub(/([^ a-zA-Z0-9_.-]+)/) do
      $1.nil? ? nil : ('%' + $1.unpack('H2' * $1.bytesize).
        compact.join('%').upcase)
    end.tr(' ','+')
  end
  def sayit
    mail = SBApplication.applicationWithBundleIdentifier(
      'com.apple.mail')
    mail.selection.each do |msg|
      params=[[:summary,msg.subject.chomp],
        [:description,msg.content.get.chomp]]
      url= "https://trac.eons.dev/newticket?"+
        params.collect{|n,v| "#{n}=#{escape(v)}"}.join('&')
      NSWorkspace.new.openURL(NSURL.URLWithString(url))
    end
  end
end
Application.new.start
