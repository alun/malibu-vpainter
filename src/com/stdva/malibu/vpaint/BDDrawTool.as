package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import mx.states.AddChild;
	
	import org.swizframework.factory.IInitializingBean;

	public class BDDrawTool implements ITool, IInitializingBean
	{
		
		[Autowire]
		public var history : History;
		
		public var brushClass : Class;
		
		public function initialize() : void {
			if( brushClass == null ) {
				throw new Error("Класс кисти не указан");
			}
			
			_brush = new brushClass(30,30);
		}
		
		private var _brush : BitmapData;
		private var _mouseDown : Boolean = false;
		private var _lastPoint : Point = null; 
		private var stepper :  Number = 0;
		
		public var tempDrawTarget : DisplayObject;
		
		public function mouseDown( point : Point ) : void 
		{
			_mouseDown = true;
			_lastPoint = point;
			stepper = 0;
			drawInPoint(point);
	   } 

		public function mouseUp( point : Point ) : void 
		{
			_mouseDown = false;
			history.checkout();
			_lastPoint = null;
		} 

		private static const SOLIDITY : int = 3;	
		//лдина вектора на один битмап
		
		private function drawInPoint (point : Point) : void
		{
			var sn : Sprite = new Sprite;
			sn.addChild(new Bitmap(new brushClass(5,5) ));
			
			sn.width = 30;
			sn.height = 30;
			sn.x = point.x;
			sn.y = point.y;
			history.currentState.draw(sn, sn.transform.matrix);
		}
		
		public function mouseMove( point : Point, buttonDown : Boolean ) : void {
			
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
				}
				_lastPoint = point;
			}
			else
			{//мышка не нажата
				_lastPoint  = null;
				stepper = 0;
				
			}
			
		} 
	}
}