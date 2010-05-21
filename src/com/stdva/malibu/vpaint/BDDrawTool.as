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
	
	public class BDDrawTool implements ITool, IInitializingBean
	{
		
		[Autowire]
		public var history : History;
		
		[Autowire]
		public var drawingParams : DrawingParams;
		
		public var brushClass : Class;
		
		public var cursor : Sprite;
		public var icon : Sprite;
		
		public function initialize() : void {
			if( brushClass == null ) {
				throw new Error("Класс кисти не указан");
			}
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
		

		public function mouseUp( point : Point ) : void 
		{
			_lastPoint = null;
			stopDraw();
		} 

		private static const SOLIDITY : int = 3;	
		//длина вектора на один битмап
		
		private function drawInPoint (point : Point) : void
		{
			var sn : Sprite = new Sprite;
			var bmData : BitmapData = new brushClass(100,100)
			var bm : Bitmap = new Bitmap(bmData )
			var rect:Rectangle = new Rectangle(0, 0, bmData.width, bmData.height);
			var colorTransform : ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 1)
			colorTransform.color =drawingParams.color;		
			bmData.colorTransform(rect,colorTransform);
			sn.addChild(bm);
			sn.width = drawingParams.brushSize;
			sn.scaleY = sn.scaleX;
			sn.x = point.x - sn.width/2;
			sn.y = point.y - sn.height/2;
			
			history.currentLayer.bitmapData.draw(sn, sn.transform.matrix);
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
		public function pushKey (k : int) : void
		{}
		
		
			
		
	}
}