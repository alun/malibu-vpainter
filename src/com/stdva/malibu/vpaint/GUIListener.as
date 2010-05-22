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
	
	import mx.core.Application;
	
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
		
		[Autowire]
		public var toolSelecter : ToolSelecter;
		

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
		public function setup () : void
		{
			
		}
		
		public function initialize() : void 
		{
			painterWindow.bottle.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			painterWindow.bottle.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			painterWindow.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOut);

			onBrushes(null);
		
			
			/*
			painterWindow.settings.frame1.addEventListener(MouseEvent.MOUSE_DOWN,onFrame1)
			painterWindow.settings.frame2.addEventListener(MouseEvent.MOUSE_DOWN,onFrame2)
			painterWindow.settings.frame3.addEventListener(MouseEvent.MOUSE_DOWN,onFrame3)
			painterWindow.settings.frame4.addEventListener(MouseEvent.MOUSE_DOWN,onFrame4)
			painterWindow.settings.frame5.addEventListener(MouseEvent.MOUSE_DOWN,onFrame5)
			painterWindow.settings.frame6.addEventListener(MouseEvent.MOUSE_DOWN,onFrame6)
			*/
			
			
			painterWindow.backActive.addEventListener(MouseEvent.MOUSE_DOWN,onGoBack);
			painterWindow.forwardActive.addEventListener(MouseEvent.MOUSE_DOWN,onGoForward);
			
			painterWindow.settings.fileLoad.addEventListener(MouseEvent.MOUSE_DOWN,onFileLoad);
			
			
			painterWindow.addEventListener("item0",onBrushes);
			painterWindow.addEventListener("item1",onFigureBrushes);
			painterWindow.addEventListener("item2",onReadyPictures);
			painterWindow.addEventListener("item3",onFillings);
			painterWindow.addEventListener("item4",onFonts);
			painterWindow.addEventListener("item5",onUploadPictures);
			
			
			
			for each( var num : int in [0,1,2,3,4,5] ) {
				function layoutPicker(v:*) : void {
					var virtualPainter : VirtualPainter = Application.application as VirtualPainter;
					virtualPainter.layoutPicker();
				}
				
				painterWindow.addEventListener("item" + num, layoutPicker);
			}
			
			
			
		} 
		
		private function onBrushes (e : *) : void
		{
			painterWindow.settings.fileLoad.visible = false;
			
			
			toolSelecter.reset();
			toolSelecter.addTool( toolSet.tools[0]);
			toolSelecter.addTool( toolSet.tools[1]);
			toolSelecter.addTool( toolSet.tools[2]);
			toolSelecter.addTool( toolSet.tools[3]);
			toolSelecter.addTool( toolSet.tools[4]);
			toolSelecter.layout();
			
		}
		private function onFigureBrushes (e : *) : void
		{
			painterWindow.settings.fileLoad.visible = false;
			toolSelecter.reset();
			toolSelecter.layout();
		}
		private function onReadyPictures(e : *) : void
		{
			painterWindow.settings.fileLoad.visible = false;
			toolSelecter.reset();
			toolSelecter.addTool( toolSet.tools[5]);
			toolSelecter.addTool( toolSet.tools[6]);
			toolSelecter.addTool( toolSet.tools[7]);
			toolSelecter.layout();
		}
		private function onFillings (e : *) : void
		{
			painterWindow.settings.fileLoad.visible = false;
			toolSelecter.reset();
			toolSelecter.layout();
		}
		private function onFonts(e : *) : void
		{
			painterWindow.settings.fileLoad.visible = false;
			toolSelecter.reset();
			toolSelecter.addTool( toolSet.tools[8]);
			toolSelecter.layout();
		}
		private function onUploadPictures (e : *) :void
		{
			painterWindow.settings.fileLoad.visible = true;
			
			toolSelecter.reset();
			toolSelecter.layout();
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
		
		
		

	}
}