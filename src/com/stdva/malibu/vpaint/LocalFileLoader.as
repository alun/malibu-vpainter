package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import org.swizframework.Swiz;

	public class LocalFileLoader
	{
		[Autowire]
		public var painterWindow : PainterWindow;
		
		[Autowire]
		public var toolSet : ToolSet;
		
		[Autowire]
		public var drawingParams : DrawingParams;
		
		private var file : FileReference;
		
		public function LocalFileLoader()
		{
		
		}
		private static const FILE_TYPES:Array = [new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png") ];

		public function load (): void
		{
			file = new FileReference();
			file.addEventListener(Event.SELECT, onFileSelect);
			file.addEventListener(Event.CANCEL,onCancel);
			file.browse(FILE_TYPES);
		}
		
		private function onFileSelect(e:Event):void
		{
			file.addEventListener(Event.COMPLETE, onFileLoadComplete);
			file.load();
		}
		private function onFileLoadComplete (e : *) : void
		{
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDataLoadComplete);
			loader.loadBytes(file.data);
			
			file = null;

			
			
		}
//		private function onDataLoadComplete (e : *) : void
//		{
//			/*	
//			var data:ByteArray = file['data'];
//			var loader:Loader = new Loader();
//			loader.loadBytes(data);
//			painterWindow.addChild(loader);
//			*/
//		}
		
		private function onDataLoadComplete(e:Event):void 
		{
			var bitmapData:BitmapData = Bitmap(e.target.content).bitmapData;
			
			//var matrix:Matrix = new Matrix();
			//matrix.scale(THUMB_WIDTH/bitmapData.width, THUMB_HEIGHT/bitmapData.height);
			
			var tool : BMPDrawTool = new BMPDrawTool();
			tool.brushSample = bitmapData;
			tool.initialize();
			Swiz.autowire(tool);
			toolSet.tools.push(tool);
			drawingParams.currentTool = tool;
		
		}

		
		//called when the user cancels out of the browser dialog
		private function onCancel(e:Event):void
		{
			file = null;
		}

		
		
			
	}
}