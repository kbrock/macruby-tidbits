# Description: 	This is the header file for the CustomView class, which handles the drawing of the window content.
#               we use a circle graphic and a pentagram graphic, switching between the two depending upon the 
#               window's transparency.

module CustomViewBehaviors

  def set_images
    @frame_image  = NSImage.imageNamed("frame.png")
  end
  
  def redraw
    needsDisplay = true
  end
  
  # When it's time to draw, this method is called.
  # This view is inside the window, the window's opaqueness has been turned off,
  # and the window's styleMask has been set to NSBorderlessWindowMask on creation,
  # so what this view draws *is all the user sees of the window*.  The first two lines below
  # then fill things with "clear" color, so that any images we draw are the custom shape of the window,
  # for all practical purposes.  Furthermore, if the window's alphaValue is <1.0, drawing will use
  # transparency.
  def drawRect(rect)
    set_images unless @circle_image
    # erase whatever graphics were there before with clear
    NSColor.clearColor.set
    NSRectFill(frame)   
    @frame_image.drawAtPoint([0,0], fromRect:frame, operation:NSCompositeSourceOver, fraction:1.0)
    window.invalidateShadow
  end
  
end