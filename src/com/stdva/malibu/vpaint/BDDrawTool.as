package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
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
		
		public var tempDrawTarget : DisplayObject;
		
		public function mouseDown( point : Point ) : void {
			_mouseDown = true;
			_lastPoint = point;
			
			
			
		} 

		public function mouseUp( point : Point ) : void {
			_mouseDown = false;
			history.checkout();
		} 

	
		public function mouseMove( point : Point ) : void {
			
					
			
			var s : Sprite = tempDrawTarget as Sprite
			var sn : Sprite = new Sprite;
			sn.addChild(new Bitmap(new brushClass(30,30) ));
			sn.width = 30;
			sn.height = 30;
			sn.x = point.x;
			sn.y = point.y;
			s.addChild(sn);
			
		//	var g : Graphics = history.currentGraphics;
			
			
			
			_lastPoint = point;
		} 
	}
}