package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.swizframework.Swiz;
	import org.swizframework.factory.IInitializingBean;

	public class GUIListener implements IInitializingBean
	{	
		
		
		[Autowire]
		public var painterWindow : PainterWindow;
		
		[Autowire]
		public var drawingParams : DrawingParams;

		private function onMouseMove (e : MouseEvent) : void
		{
				drawingParams.currentTool.mouseMove(new Point(e.localX, e.localY), e.buttonDown);
		}
		
		private function onMouseDown(e : MouseEvent) : void
		{
				drawingParams.currentTool.mouseDown(new Point(e.localX, e.localY));
		}
		
		public function setup () : void
		{
			
		}
		
		public function initialize() : void {
			
			painterWindow.bottle.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			painterWindow.bottle.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
		} 
		
	}
}