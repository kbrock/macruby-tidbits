require 'hotcocoa/graphics'
include Graphics

module CustomViewBehaviors
  def redraw
    needsDisplay = true
  end
  def drawRect(rect)
    color(:rgb => 0x1e1422, :alpha => 0.9).set
    clipShape=NSBezierPath.bezierPath
    clipShape.appendBezierPathWithRoundedRect(bounds,
      xRadius: 40, yRadius: 30)
    clipShape.fill
    window.invalidateShadow
  end
end
module CustomWindowBehaviors
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

def bezel_window(opts)
  default_opts={:level=>NSStatusWindowLevel,:defer=>false,
    :style=>[:borderless],:opaque=>false,:hasShadow=>true}
  buttons=opts.delete(:buttons)
  window(default_opts.merge(opts)) do |w|
    w.setBackgroundColor(color(:name => 'clear'))
    w.extend(CustomWindowBehaviors)
    w.contentView.extend(CustomViewBehaviors)
    w << l=layout_view(:layout=>{:expand =>[:width,:height]},
      :frame => [0, 0, opts[:frame][2]/4, opts[:frame][3]/4])

    if buttons
      buttons.each do |n,v|
        l << bezel_button(:title=>n, :on_action=>v)
      end
    end

    yield l if block_given?
  end
end

def bezel_button(opts)
  button({:layout => {:expand=>[:width],:start => false},
    :bezel=>:recessed}.merge(opts))
end