package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
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
		
		[Autowire]
		public var localFileLoader : LocalFileLoader;
		

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
		private function onMouseOut (e : MouseEvent) : void
		{
			if  (!e.buttonDown)
			{
				drawingParams.currentTool.mouseUp(new Point (e.localX,e.localY));
			}
		}
//		private function onKeyDown (e : *) : void
//		{
//			var i;
//			//drawingParams.currentTool.pushKey(e.keyCode);
//		}
		
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
			painterWindow.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOut);
			
			//stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			
			painterWindow.settings.frame1.alpha = 1;
			painterWindow.settings.frame2.alpha = 0;
			painterWindow.settings.frame3.alpha = 0;
			painterWindow.settings.frame4.alpha = 0;
			painterWindow.settings.frame5.alpha = 0;
			painterWindow.settings.frame6.alpha = 0;
			
			painterWindow.settings.frame1.addEventListener(MouseEvent.MOUSE_DOWN,onFrame1)
			painterWindow.settings.frame2.addEventListener(MouseEvent.MOUSE_DOWN,onFrame2)
			painterWindow.settings.frame3.addEventListener(MouseEvent.MOUSE_DOWN,onFrame3)
			painterWindow.settings.frame4.addEventListener(MouseEvent.MOUSE_DOWN,onFrame4)
			painterWindow.settings.frame5.addEventListener(MouseEvent.MOUSE_DOWN,onFrame5)
			painterWindow.settings.frame6.addEventListener(MouseEvent.MOUSE_DOWN,onFrame6)
		
			//painterWindow.addEventListener(MouseEvent.MOUSE_MOVE,onMoveOverStage)
			painterWindow.addEventListener(Event.ENTER_FRAME,onDoFrame);	
		
			painterWindow.backActive.addEventListener(MouseEvent.MOUSE_DOWN,onGoBack);
			painterWindow.forwardActive.addEventListener(MouseEvent.MOUSE_DOWN,onGoForward);
			
			painterWindow.settings.fileLoad.addEventListener(MouseEvent.MOUSE_DOWN,onFileLoad);
			
		} 
		
		
		
		private function onFileLoad (e : *) : void
		{
		
			localFileLoader.load();
		}
		
		private function onGoBack (e : *) : void
		{
			history.undo();
		}
		
		private function onGoForward (e : *) : void
		{
			history.redo();
		}
		
		public  function set backActive ( b : Boolean) : void
		{
			painterWindow.backActive.visible = b;
			painterWindow.backPassive.visible = !b;
		}
		public function set forwardActive (b : Boolean) : void
		{
			painterWindow.forwardActive.visible = b;
			painterWindow.forwardPassive.visible = !b;
		}
		
		
		
		public function onFrame1 ( e : *) : void
		{
			drawingParams.currentTool = toolSet.tools[0];	
			painterWindow.settings.frame1.alpha = 1;
			painterWindow.settings.frame2.alpha = 0;
			painterWindow.settings.frame3.alpha = 0;
			painterWindow.settings.frame4.alpha = 0;
			painterWindow.settings.frame5.alpha = 0;
			painterWindow.settings.frame6.alpha = 0
		}
		public function onFrame2 ( e : *) : void
		{
			drawingParams.currentTool = toolSet.tools[1];	
			painterWindow.settings.frame1.alpha = 0;
			painterWindow.settings.frame2.alpha = 1;
			painterWindow.settings.frame3.alpha = 0;
			painterWindow.settings.frame4.alpha = 0;
			painterWindow.settings.frame5.alpha = 0;
			painterWindow.settings.frame6.alpha = 0

		}
		public function onFrame3 ( e : *) : void
		{
			drawingParams.currentTool = toolSet.tools[2];	
			painterWindow.settings.frame1.alpha = 0;
			painterWindow.settings.frame2.alpha = 0;
			painterWindow.settings.frame3.alpha = 1;
			painterWindow.settings.frame4.alpha = 0;
			painterWindow.settings.frame5.alpha = 0;
			painterWindow.settings.frame6.alpha = 0
		}
		public function onFrame4 ( e : *) : void
		{
			drawingParams.currentTool = toolSet.tools[3];	
			painterWindow.settings.frame1.alpha = 0;
			painterWindow.settings.frame2.alpha = 0;
			painterWindow.settings.frame3.alpha = 0;
			painterWindow.settings.frame4.alpha = 1;
			painterWindow.settings.frame5.alpha = 0;
			painterWindow.settings.frame6.alpha = 0
		}
		public function onFrame5 ( e : *) : void
		{
			drawingParams.currentTool = toolSet.tools[4];	
			painterWindow.settings.frame1.alpha = 0;
			painterWindow.settings.frame2.alpha = 0;
			painterWindow.settings.frame3.alpha = 0;
			painterWindow.settings.frame4.alpha = 0;
			painterWindow.settings.frame5.alpha = 1;
			painterWindow.settings.frame6.alpha = 0
		}
		public function onFrame6 ( e : *) : void
		{
			drawingParams.currentTool = toolSet.tools[5];	
			painterWindow.settings.frame1.alpha = 0;
			painterWindow.settings.frame2.alpha = 0;
			painterWindow.settings.frame3.alpha = 0;
			painterWindow.settings.frame4.alpha = 0;
			painterWindow.settings.frame5.alpha = 0;
			painterWindow.settings.frame6.alpha = 1
		}
		
		private function onDoFrame(e : *) : void
		{
			
		}
		
	
		
	}
}