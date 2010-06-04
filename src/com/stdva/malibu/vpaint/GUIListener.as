package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
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
	import mx.core.FlexGlobals;
	
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
		private function onMouseUp(e : MouseEvent): void
		{
			drawingParams.currentTool.mouseUp(new Point (e.localX,e.localY));
		}
		public function setup () : void
		{
			
		}
		
		public function initialize() : void 
		{
			onBrushes(null);
			
			painterWindow.bottle.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			painterWindow.bottle.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			painterWindow.malibulogo.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			painterWindow.malibulogo.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			painterWindow.bottle.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			painterWindow.malibulogo.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			painterWindow.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			
			painterWindow.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOut);
			
			painterWindow.backButton.addEventListener(MouseEvent.MOUSE_DOWN,onGoBack);
			painterWindow.forwardButton.addEventListener(MouseEvent.MOUSE_DOWN,onGoForward);
			
			painterWindow.settings.fileLoad.addEventListener(MouseEvent.MOUSE_DOWN,onFileLoad);
			
			
			painterWindow.addEventListener("item0",onBrushes);
			painterWindow.addEventListener("item1",onFigureBrushes);
			painterWindow.addEventListener("item2",onReadyPictures);
			painterWindow.addEventListener("item3",onFillings);
			painterWindow.addEventListener("item4",onFonts);
			painterWindow.addEventListener("item5",onUploadPictures);
			painterWindow.addEventListener("Hide settings", onHideSettings);
			
			painterWindow.settings.pagerForward.addEventListener(MouseEvent.MOUSE_DOWN,onPagerForward);
			painterWindow.settings.pagerBack.addEventListener(MouseEvent.MOUSE_DOWN,onPagerBack);
			
			for each( var num : int in [0,1,2,3,4,5] ) {
				function layoutPicker(v:*) : void 
				{
//					var virtualPainter : VirtualPainter = Application.application as VirtualPainter;
//					virtualPainter.layoutPicker();
				}
				painterWindow.addEventListener("item" + num, layoutPicker);
			}
			
			painterWindow.resetButton.addEventListener(MouseEvent.MOUSE_DOWN,onReset);
			painterWindow.addToGalery.addEventListener(MouseEvent.MOUSE_DOWN, onSaveToGallery);
			
			backActive = false;
			forwardActive = false;
			
			painterWindow.malibulogo.mouseEnabled = false;
			painterWindow.malibulogo.mouseChildren = false;
		} 
		
		private function onSaveToGallery (e : *) : void
		{
			var virtualPainter : VirtualPainter = Application.application as VirtualPainter;
			virtualPainter.showAddToGallery = true;
		}
		
		private function onReset (e : *) : void
		{
			history.cleanAll();
		}
		
		private function onPagerBack (e : *) : void
		{
			toolSelecter.back();
		}
		
		private function onPagerForward (e : *) : void
		{
			toolSelecter.forward();
		}
		
		private function onHideSettings (e : *) : void
		{
//			var virtualPainter : VirtualPainter = Application.application as VirtualPainter;
//			virtualPainter.hidePicker();
		}
		
		public function onBrushes (e : *) : void
		{
			painterWindow.settings.fileLoad.visible = false;
			showColorPicker = true;
			
//			var virtualPainter : VirtualPainter = FlexGlobals.topLevelApplication as VirtualPainter;//Application.application as VirtualPainter;
//			virtualPainter.showPicker();
			
			toolSelecter.reset();

			for each (var tool2 : ITool in toolSet.getWithType(ToolTypes.TATOO ))
			{
				toolSelecter.addTool(tool2);
			}
			for each (var tool3 : ITool in toolSet.getWithType(ToolTypes.CALIGRAPH ))
			{
				toolSelecter.addTool(tool3);
			}
			for each (var tool : ITool in toolSet.getWithType(ToolTypes.BRUSH ))
			{
				toolSelecter.addTool(tool);
			}			

			toolSelecter.goToFirst();
			toolSelecter.layout();
			
		}
		private function onFigureBrushes (e : *) : void
		{
			painterWindow.settings.fileLoad.visible = false;
			showColorPicker = true;
//			var virtualPainter : VirtualPainter = Application.application as VirtualPainter;
//			virtualPainter.showPicker();
			
			painterWindow.settings.fileLoad.visible = false;
			
			toolSelecter.reset();
			for each (var tool : ITool in toolSet.getWithType(ToolTypes.FIGURE_BRUSH ))
			{
				toolSelecter.addTool(tool);
			}
			toolSelecter.goToFirst();
			toolSelecter.layout();
		}
		private function onReadyPictures(e : *) : void
		{
			
			painterWindow.settings.fileLoad.visible = false;
			showColorPicker = false;
			
			toolSelecter.reset();
			for each (var tool : ITool in toolSet.getWithType(ToolTypes.READY_BITMAP))
			{
				toolSelecter.addTool(tool);
			}
			toolSelecter.goToFirst();
			toolSelecter.layout();
		}
		private function onFillings (e : *) : void
		{	
			painterWindow.settings.fileLoad.visible = false;
			showColorPicker = true;
			toolSelecter.reset();
			
			for each (var tool : ITool in toolSet.getWithType(ToolTypes.COLOR_FILL))
			{
				toolSelecter.addTool(tool);
			}
			
			for each (var tool : ITool in toolSet.getWithType(ToolTypes.FILL))
			{
				toolSelecter.addTool(tool);
			}
			
			toolSelecter.goToFirst();
			toolSelecter.layout();
		}
		private function onFonts(e : *) : void
		{
//			var virtualPainter : VirtualPainter = FlexGlobals.topLevelApplication as VirtualPainter;//Application.application as VirtualPainter;
//			virtualPainter.showPicker();
			showColorPicker = true;
			toolSelecter.reset();
			for each (var tool : ITool in toolSet.getWithType(ToolTypes.FONT))
			{
				toolSelecter.addTool(tool);
			}
			toolSelecter.goToFirst();
			toolSelecter.layout();
		}
		public function onUploadPictures (e : *) :void
		{
			painterWindow.settings.fileLoad.visible = true;
			showColorPicker = false;
			
			toolSelecter.reset();
			for each (var tool : ITool in toolSet.getWithType(ToolTypes.LOADED_BITMAP))
			{
				toolSelecter.addTool(tool);
			}
			
			toolSelecter.goToLast();
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
			painterWindow.backButton.enabled = b;
		}
		public function set forwardActive (b : Boolean) : void
		{
			painterWindow.forwardButton.enabled = b;
		}
		
		public function set backPagerActive (b : Boolean) : void
		{
			painterWindow.settings.pagerBack.enabled = b;
		}
		public function set forwardPagerActive (b : Boolean) : void
		{
			painterWindow.settings.pagerForward.enabled = b;
		}
		
		public function set showColorPicker (b : Boolean) : void
		{
			painterWindow.settings.colorLabel.visible = b;
			var virtualPainter : VirtualPainter = FlexGlobals.topLevelApplication as VirtualPainter;//Application.application as VirtualPainter;
			if (virtualPainter.colorPicker)
				virtualPainter.colorPicker.visible = b;
		}
		
		
		

	}
}