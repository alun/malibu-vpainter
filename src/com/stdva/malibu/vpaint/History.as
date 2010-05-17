package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import org.swizframework.factory.IInitializingBean;

	public class History implements IInitializingBean
	{
		
		public var painterWindow : PainterWindow;
		
		public function initialize() : void {
			
			
			// обработать painterWindow
			
			// создать _mergedData

			
		} 
		
		private var _mergedData : BitmapData;
		private var _layers : Array = [];
		private var _composition : Sprite;
		
		public function get currentGraphics() : Graphics {
			var length : int = _layers.length
			if( length > 0 ) {
				return Shape(_layers[length - 1]).graphics;
			} else {
				return null;
			}
		}
		
		/**
		 * Начинает новый слой истории 
		 */
		public function checkout() : void {
			
		}
		
		public function undo() : void {
			
		}

		public function redo() : void {
			
		}
	}
}