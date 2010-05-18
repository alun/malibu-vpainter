package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	import org.swizframework.Swiz;
	import org.swizframework.factory.IInitializingBean;

	public class GUIListener implements IInitializingBean
	{	
		
		
		[Autowire]
		public var painterWindow : PainterWindow;
		
		[Autowire]
		public var drawingParams : DrawingParams;
		
		[Autowire]
		public var toolSet : ToolSet;
		
		[Autowire]
		public var history : History;
		

		private function onMouseMove (e : MouseEvent) : void
		{
				var bitmapPoint : Point = history.currentLayer.globalToLocal (new Point(e.stageX,e.stageY))
				drawingParams.currentTool.mouseMove(bitmapPoint, e.buttonDown);
				
				
		}
		
		private function onMouseDown(e : MouseEvent) : void
		{
			var bitmapPoint : Point = history.currentLayer.globalToLocal (new Point(e.stageX,e.stageY))
			
			drawingParams.currentTool.mouseDown(bitmapPoint);
		}
		
		public function setup () : void
		{
			
		}
		
		public function initialize() : void 
		{
			/*
			history.currentLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			history.currentLayer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			*/
			painterWindow.bottle.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			painterWindow.bottle.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			painterWindow.frame1.alpha = 1;
			painterWindow.frame2.alpha = 0;
			painterWindow.frame3.alpha = 0;
			painterWindow.frame4.alpha = 0;
			painterWindow.frame5.alpha = 0;
			painterWindow.frame6.alpha = 0;
			
			painterWindow.frame1.addEventListener(MouseEvent.MOUSE_DOWN,onFrame1)
			painterWindow.frame2.addEventListener(MouseEvent.MOUSE_DOWN,onFrame2)
			painterWindow.frame3.addEventListener(MouseEvent.MOUSE_DOWN,onFrame3)
			painterWindow.frame4.addEventListener(MouseEvent.MOUSE_DOWN,onFrame4)
			painterWindow.frame5.addEventListener(MouseEvent.MOUSE_DOWN,onFrame5)
			painterWindow.frame6.addEventListener(MouseEvent.MOUSE_DOWN,onFrame6)
		
			painterWindow.addEventListener(MouseEvent.MOUSE_MOVE,onMoveOverStage)
				
		} 
		private function onMoveOverStage (e : MouseEvent) : void
		{
			var p : Point = history.currentLayer.globalToLocal (new Point(e.stageX,e.stageY));
			if (p.x >=0 && p.y>=0 && p.x <=history.currentLayer.width && p.y <= history.currentLayer.height )
			{//на бутылке
				//Mouse.hide();
				//addEvent
			}
			else
			{
				//Mouse.show();
			}
		}
		
		public function onFrame1 ( e : *) : void
		{
			drawingParams.currentTool = toolSet.tools[0];	
			painterWindow.frame1.alpha = 1;
			painterWindow.frame2.alpha = 0;
			painterWindow.frame3.alpha = 0;
			painterWindow.frame4.alpha = 0;
			painterWindow.frame5.alpha = 0;
			painterWindow.frame6.alpha = 0
		}
		public function onFrame2 ( e : *) : void
		{
			drawingParams.currentTool = toolSet.tools[1];	
			painterWindow.frame1.alpha = 0;
			painterWindow.frame2.alpha = 1;
			painterWindow.frame3.alpha = 0;
			painterWindow.frame4.alpha = 0;
			painterWindow.frame5.alpha = 0;
			painterWindow.frame6.alpha = 0

		}
		public function onFrame3 ( e : *) : void
		{
			drawingParams.currentTool = toolSet.tools[2];	
			painterWindow.frame1.alpha = 0;
			painterWindow.frame2.alpha = 0;
			painterWindow.frame3.alpha = 1;
			painterWindow.frame4.alpha = 0;
			painterWindow.frame5.alpha = 0;
			painterWindow.frame6.alpha = 0
		}
		public function onFrame4 ( e : *) : void
		{
			drawingParams.currentTool = toolSet.tools[3];	
			painterWindow.frame1.alpha = 0;
			painterWindow.frame2.alpha = 0;
			painterWindow.frame3.alpha = 0;
			painterWindow.frame4.alpha = 1;
			painterWindow.frame5.alpha = 0;
			painterWindow.frame6.alpha = 0
		}
		public function onFrame5 ( e : *) : void
		{
			drawingParams.currentTool = toolSet.tools[4];	
			painterWindow.frame1.alpha = 0;
			painterWindow.frame2.alpha = 0;
			painterWindow.frame3.alpha = 0;
			painterWindow.frame4.alpha = 0;
			painterWindow.frame5.alpha = 1;
			painterWindow.frame6.alpha = 0
		}
		public function onFrame6 ( e : *) : void
		{
			drawingParams.currentTool = toolSet.tools[5];	
			painterWindow.frame1.alpha = 0;
			painterWindow.frame2.alpha = 0;
			painterWindow.frame3.alpha = 0;
			painterWindow.frame4.alpha = 0;
			painterWindow.frame5.alpha = 0;
			painterWindow.frame6.alpha = 1
		}
		
		
	}
}