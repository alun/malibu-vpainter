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
	
	public class CaligraphTool implements ITool, IInitializingBean
	{
		
		public static const MAX_BRUSH_SIZE : int= 15;
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
			var sn : Sprite = new Sprite;
			sn.graphics.beginFill(drawingParams.color,1);
			var w: Number = MIN_BRUSH_SIZE + (MAX_BRUSH_SIZE - MIN_BRUSH_SIZE)*drawingParams.brushSize/100;
			sn.graphics.drawCircle(0,0,w/2)
			sn.x = point.x ;
			sn.y = point.y ;
			var width : int = history.currentLayer.width;
			var height : int = history.currentLayer.height
			history.currentLayer.bitmapData.draw(sn,sn.transform.matrix);
			history.changed = true;
		}

		private function reDrawPoints() : void
		{
			if (points.length)
			{
				
				history.cleanCurrentLayer();
				
				var maxW : Number = MIN_BRUSH_SIZE + (MAX_BRUSH_SIZE - MIN_BRUSH_SIZE)*drawingParams.brushSize/100;
				maxW = 1.5 * maxW/2;
				var minW : Number = maxW/6;
				
				var lastWidth : Number= minW + (maxW - minW) * (Math.random() +1)/2; 
				var direction : Boolean = Math.random() > 0.6 ? true : false; 
				var probChDirection : Number = 0.025;
				
				
				
				var frequency : int = 50;
				var dispersion : int = 10;
			
				var idx : int = 0;
				
				var fWidth : Number = minW + (maxW - minW) * Math.random();
				var lWidth : Number = minW + (maxW - minW) * Math.random();
				
				var nextKeyIndex : int;
				var curLen : int;
				
				for each (var p : Point in points)
				{
					
					if (points.indexOf(p) >= nextKeyIndex )
					{
						curLen = frequency + Math.random()*dispersion;
						nextKeyIndex = nextKeyIndex + curLen;
						lWidth = fWidth;
						fWidth = minW + (maxW - minW) * Math.random();
					}
					
					var w : Number  = lWidth + (fWidth-lWidth) * (nextKeyIndex - idx)/curLen
					
					
					drawInPointWithWidth(p,w);
					idx++
				}
				
				/*
				for each (var p: Point in points )
				{
					var w : Number;
					if (Math.random() < probChDirection)
					{//меняем направление (maxW-lastWidth)*(lastWidth-minW)/(maxW-minW)*(maxW-minW) 
						direction = !direction
					}

					if (direction)
					{
						w = lastWidth + Math.random() * (maxW-lastWidth) * 0.6;
					}
					else
					{
						w = lastWidth - Math.random() * (lastWidth - minW) * 0.7;
					}
					drawInPointWithWidth(p,w);
				}*/
	
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