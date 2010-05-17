package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
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
			
			_brush = new brushClass;
		}
		
		private var _brush : BitmapData;
		private var _mouseDown : Boolean = false;
		private var _lastPoint : Point = null; 
		
		public function mouseDown( point : Point ) : void {
			_mouseDown = true;
			_lastPoint = point;
		} 

		public function mouseUp( point : Point ) : void {
			_mouseDown = false;
			history.checkout();
		} 

		public function mouseMove( point : Point ) : void {
			
			var g : Graphics = history.currentGraphics;
			
			_lastPoint = point;
		} 
	}
}