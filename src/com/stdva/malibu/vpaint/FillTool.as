package com.stdva.malibu.vpaint
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.swizframework.factory.IInitializingBean;
	
	public class FillTool implements ITool, IInitializingBean
	{
		
		public static const MAX_BRUSH_SIZE : int= 150;
		public static const MIN_BRUSH_SIZE : int = 0;
		
		public var _type : String = "";
		public var brushSampleSprite : DisplayObject;
		public var brushSample : BitmapData;
		
		[Autowire]
		public var history : History;
		
		[Autowire]
		public var drawingParams : DrawingParams;
		
		public function FillTool()
		{
		}
		
		public function mouseDown(point:Point):void
		{
			fill (point);
    	}
		
		public function mouseUp(point:Point):void
		{
		}
		
		public function mouseMove(point:Point, buttonDown:Boolean):void
		{
		}
		
		public function get icon():DisplayObject
		{
			var bmSprite : DisplayObject = brushSampleSprite;
			
			var bmData : BitmapData = new BitmapData(bmSprite.width, bmSprite.height,true,0x000000);
			bmData.draw(bmSprite);
			var bm : Bitmap = new Bitmap(bmData )
			return bm;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(v:String):void
		{
			_type = v;
		}
		
		public function initialize():void
		{
			if (brushSampleSprite)
			{
				brushSampleSprite.scaleX = brushSampleSprite.scaleY = 1;
				brushSample = new BitmapData(brushSampleSprite.width, brushSampleSprite.height,true,0x000000)
				brushSample.draw(brushSampleSprite);					
			}	
			
		}
		
	//	private var hasPixelsToFill : Boolean;
	//	private var filledPixels : Array = [];
	//	private var visitedPixels : Array = [];
		//private var targetColor : int;
		//private var epsilon : int = 1000;
	//	private var iterationNumber : int = 0;
		private var width : int;
		private var height : int;
		
		
		
		
		private function fill (p : Point) : void
		{
			
			var colorTransform : ColorTransform = new ColorTransform();
			colorTransform.redOffset = -1;
			
			width = history.recentLayer.width;
			height = history.recentLayer.height;

			var rect : Rectangle = new Rectangle(0,0,width,height);
			
			
			
			p.x = int(p.x);
			p.y = int (p.y);
			
			var bmd : BitmapData = new BitmapData(width, height,false,0xFF0000);
			history.recentLayer.bitmapData.colorTransform(rect,colorTransform);
			bmd.draw(history.recentLayer);
    		bmd.colorTransform(rect,colorTransform);
			
			bmd.floodFill(p.x, p.y, 0x00FF0000);
			
			var pt:Point = new Point(0, 0);
			var threshold:uint =  0xFFFF0000; 
			var color:uint = 0x0000FF00;
			var maskColor:uint = 0xFFFFFFFF;
			var bmd2 : BitmapData = new BitmapData(width,height,true,0x000000);
			bmd2.threshold(bmd, rect, pt, "!=", threshold, color, maskColor, true);

    		//bmd.threshold(bmd,rect,new Point(0,0), "==",0x00FF0000,
			
			//function threshold(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, operation:String, threshold:uint, color:uint = 0, mask:uint = 0xFFFFFFFF, copySource:Boolean = false):uint
			
			/*
			var colorTransform2 : ColorTransform = new ColorTransform();
			colorTransform2.color = drawingParams.color;
			bmd2.colorTransform(rect,colorTransform2);
			*/
			
		
				
			
			
			//делаем сэмплы для раскрашивания
			
			brushSampleSprite.width = drawingParams.brushSize;
			brushSampleSprite.scaleY = brushSampleSprite.scaleX;
			brushSampleSprite.x = brushSampleSprite.y = 0;
			/*var sample : Sprite = new Sprite;
			sample.addChild(brushSampleSprite);
			sample.width = drawingParams.brushSize;
			sample.scaleY = sample.scaleX;
			*/
			var lilBitmapSample : BitmapData = new BitmapData(brushSampleSprite.width,brushSampleSprite.height,true,0x000000);
			lilBitmapSample.draw(brushSampleSprite, brushSampleSprite.transform.matrix);
		
			var s : Sprite = new Sprite;
			s.graphics.beginBitmapFill(lilBitmapSample,new Matrix(), true, true);
			s.graphics.drawRect(0,0,width,height);
			s.cacheAsBitmap = true;
			
			
			
			var s2 : Sprite = new Sprite;
			s2.addChild(s);
			var bm : Bitmap = new Bitmap(bmd2)
			bm.cacheAsBitmap = true;
			s2.addChild(bm);		
			s.mask = bm;
				
			history.currentLayer.bitmapData.draw(s2);
			history.changed = true;
			history.checkout();
		}
		
		public function get needColorPicker () : Boolean
		{
			return false;
		}
	
				
	}
}