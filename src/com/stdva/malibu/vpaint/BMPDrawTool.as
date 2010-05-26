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
	
	public class BMPDrawTool implements ITool, IInitializingBean
	{
		public static const MAX_BRUSH_SIZE : int= 150;
		public static const MIN_BRUSH_SIZE : int = 0;
		
		public var brushClass : Class;
		public var brushSample : BitmapData;
		public var brushSampleSprite : DisplayObject;
		
		private var _lastPoint : Point = null; 
		private var stepper :  Number = 0;
		private var radius : int;
		
		[Autowire]
		public var history : History;
		
		[Autowire]
		public var drawingParams : DrawingParams;
		
		public function BMPDrawTool()
		{
		}
		
		public function mouseDown(point:Point):void
		{
			beginDraw(point);
		}
		
		public function mouseUp(point:Point):void
		{
		}
		
		//private static const SOLIDITY : int = 3;	
		public function mouseMove(point:Point, buttonDown:Boolean):void
		{
			if (buttonDown)
			{
				if (_lastPoint)
				{	
					var size : int = MIN_BRUSH_SIZE + (MAX_BRUSH_SIZE - MIN_BRUSH_SIZE)*drawingParams.brushSize/100;
					var SOLIDITY : int = radius * size / 100;
					
					var length : Number  =  Math.sqrt((_lastPoint.x - point.x) * (_lastPoint.x - point.x)	 + (_lastPoint.y - point.y) * (_lastPoint.y - point.y)	)
					stepper += length;	
					var e : Point = new Point ((point.x - _lastPoint.x)/length, (point.y - _lastPoint.y)/length);//единичный вектор
					var d : Number = stepper - int(stepper/SOLIDITY) * SOLIDITY // stepper который останется после цикла
					var num : int = int(stepper/SOLIDITY);//количество точек которое сейчас нарисуем
					for(var i : int = num-1;stepper > SOLIDITY;i--,stepper -= SOLIDITY)
					{
						var currentPoint : Point = new Point(point.x - e.x * d - SOLIDITY*e.x*i, point.y - e.y*d - SOLIDITY*e.y*i);
						drawInPoint(new Point(currentPoint.x, currentPoint.y));
					}
					_lastPoint = point;
				}
				else
				{
					beginDraw(point);
				}
				
			}
			else
			{//мышка не нажата
				stopDraw();
				_lastPoint  = null;
				stepper = 0;
			}
			
		}
		
		
		
		public function initialize():void
		{
			
			if (brushSampleSprite)
			{
				brushSampleSprite.scaleX = brushSampleSprite.scaleY = 1;
				brushSample = new BitmapData(brushSampleSprite.width, brushSampleSprite.height,true,0x000000)
				brushSample.draw(brushSampleSprite,new Matrix(),new ColorTransform(),"normal",new Rectangle(0,0,brushSampleSprite.width, brushSampleSprite.height),true);					
			
			}	
		
			if (!brushSample)
				brushSample =  new brushClass(100,100)
			radius = get100Radius ();
		
		}
		public function beginDraw (point : Point) : void
		{
			_lastPoint = point;
			stepper = 0;
			drawInPoint(point);
		}
		
		public function stopDraw () : void
		{
			history.checkout();
			
		}
		
		private function drawInPoint (point : Point) : void
		{
			var sn : Sprite = new Sprite;
			var bm : Bitmap = new Bitmap(brushSample )
			bm.smoothing = true;
			sn.addChild(bm);
			sn.addChild(bm);
			sn.width = MIN_BRUSH_SIZE + (MAX_BRUSH_SIZE - MIN_BRUSH_SIZE) * drawingParams.brushSize / 100;
			sn.scaleY = sn.scaleX;
			sn.x = point.x - sn.width/2;
			sn.y = point.y - sn.height/2;
			history.currentLayer.bitmapData.draw(sn, sn.transform.matrix);
			history.changed = true;
		}
		
		private function get100Radius () : int
		{
			var sn : Sprite = new Sprite;
			
			//var bmData : BitmapData = new brushClass(100,100)
			
			var bm : Bitmap = new Bitmap(brushSample )
			sn.addChild(bm);
			sn.width = 100;
			sn.scaleY = sn.scaleX;
			
			var max : int = sn.height;  
			if (sn.width>sn.height)
				max = sn.width;
		
			return max;
		}
		
		public function get icon () : DisplayObject
		{
			/*brushSampleSprite.width = 100;
			brushSampleSprite.scaleY = brushSampleSprite.scaleX;
			*/
			//brushSample = new BitmapData(brushSampleSprite.width, brushSampleSprite.height,true,0x000000)
			//brushSample.draw(brushSampleSprite);
			var bm : Bitmap = new Bitmap(brushSample )
			return bm;
		}
		
		private var _type : String;
		
		
		
		
		public function get type () : String
		{
			return _type;
		}
		public function set type (value : String) : void
		{
			_type = value;
		}
		

	
	}
}