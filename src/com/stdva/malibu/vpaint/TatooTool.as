package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.states.AddChild;
	
	import org.swizframework.factory.IInitializingBean;
	
	public class TatooTool implements ITool, IInitializingBean
	{
		
		public static const MAX_BRUSH_SIZE : int= 50;
		public static const MIN_BRUSH_SIZE : int = 0;
		
		[Autowire]
		public var history : History;
		
		[Autowire]
		public var drawingParams : DrawingParams;
		
		public var brushClass : Class;
		public var brushSampleSprite : DisplayObject;
		
		public function initialize() : void {
			/*
			if( brushClass == null ) {
				throw new Error("Класс кисти не указан");
			}
			*/
			/*
			cursor = new Sprite;
			cursor.addChild(new Bitmap(new brushClass(30,30)));
		*/
						
		}
		
		private var _lastPoint : Point = null; 
		private var stepper :  Number = 0;
		
		public var tempDrawTarget : BitmapData;
		
		public function mouseDown( point : Point ) : void 
		{
			beginDraw(point);
	   } 
		
		
		public var points : Array = [];
		public function beginDraw (point : Point) : void
		{
			_lastPoint = point;
			stepper = 0;
			drawInPoint(point);
			
			points = [];
			points.push(point);
			
		}
		
		public function stopDraw () : void
		{
			reDrawPoints();
		}
		
		

		public function mouseUp( point : Point ) : void 
		{
			_lastPoint = null;
			stopDraw();
		} 

		private static const SOLIDITY : int = 1;	
		//длина вектора на один битмап
		
		private function drawInPoint (point : Point) : void
		{
			points.push(point);
			/*
			var bmSprite : Sprite = new Sprite;
			bmSprite.graphics.beginFill(drawingParams.color,1);
			/*
			var w: int = MIN_BRUSH_SIZE + (MAX_BRUSH_SIZE - MIN_BRUSH_SIZE)*drawingParams.brushSize/100;
			bmSprite.graphics.drawCircle(w/4,w/4,w/2)
			
			
			var bmData : BitmapData = new BitmapData (bmSprite.width,bmSprite.height,true,0x00000000);
			var colorTransform : ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 1)
			bmData.draw(bmSprite);//,
			
			var bm : Bitmap = new Bitmap(bmData )
			bm.smoothing = true;	
			var rect:Rectangle = new Rectangle(0, 0, bmData.width, bmData.height);
			
			colorTransform.color =drawingParams.color;		
			bmData.colorTransform(rect,colorTransform);
			
			var sn : Sprite = new Sprite;
			sn.addChild(bm);
			
			//sn.width = MIN_BRUSH_SIZE + (MAX_BRUSH_SIZE - MIN_BRUSH_SIZE)*drawingParams.brushSize/100;
			
			//sn.scaleY = sn.scaleX;*/
			
			var sn : Sprite = new Sprite;
			sn.graphics.beginFill(drawingParams.color,1);
			var w: Number = MIN_BRUSH_SIZE + (MAX_BRUSH_SIZE - MIN_BRUSH_SIZE)*drawingParams.brushSize/100;
			sn.graphics.drawCircle(0,0,w/2)
			
			
			sn.x = point.x ;
			sn.y = point.y ;
			var width : int = history.currentLayer.width;
			var height : int = history.currentLayer.height
			
			//history.currentLayer.bitmapData.draw(sn,,new ColorTransform(),"normal", new Rectangle(0,0,width,height),true);
			history.currentLayer.bitmapData.draw(sn,sn.transform.matrix);
			history.changed = true;
			
		//	bmSprite.scaleY = bmSprite.scaleX = 1;
		}
		
		

		private function reDrawPoints() : void
		{
			if (points.length)
			{
				
				history.cleanCurrentLayer();
				
				for each (var p: Point in points )
				{
					
					var w : Number;
					var minW : Number = 1;
					var maxW : Number = MIN_BRUSH_SIZE + (MAX_BRUSH_SIZE - MIN_BRUSH_SIZE)*drawingParams.brushSize/100;
					maxW = maxW/2;
					if (points.length == 1)
					{
						w = maxW;
					}
					else
					if (points.indexOf(p) < points.length/2)
					{
						w = minW + (maxW-minW)*(1 - (points.length - 2 * points.indexOf(p))/points.length );
					}
					else
					{
						w = minW + (maxW - minW) *(1 - (2 * points.indexOf(p) - points.length) / points.length );
					}
					
					/*
					if (points.indexOf(p) != 0)
					{
						var lastPoint : Point = points[points.indexOf(p) -1];
						var langth : int = Math.sqrt((p.x-lastPoint.x)(p.x-lastPoint.x) + (p.y-lastPoint.y)(p.y-lastPoint.y)  )
					}
					*/
					drawInPointWithWidth(p,w);
					
				}
				
				history.checkout();
				points = [];
			}
		}
		private function drawInPointWithWidth (p : Point, w : Number) : void
		{
			
			var s : Sprite = new Sprite;
			s.graphics.beginFill(drawingParams.color,1);
			s.graphics.drawCircle(p.x,p.y,w);
			history.currentLayer.bitmapData.draw(s);
			history.changed = true;
			
		}
		
		public function mouseMove( point : Point, buttonDown : Boolean ) : void 
		{
			
			if (buttonDown)
			{
				if (_lastPoint)
				{	
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
		
		public function get icon () : DisplayObject
		{
			var bmSprite : DisplayObject = brushSampleSprite;
			
			var bmData : BitmapData = new BitmapData(bmSprite.width, bmSprite.height,true,0x000000);
			bmData.draw(bmSprite);
			var bm : Bitmap = new Bitmap(bmData )
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
		
		public function get needColorPicker () : Boolean
		{
			return true;
		}
			

		
		
	}
}