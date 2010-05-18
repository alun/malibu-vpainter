package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.Bottle;
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import org.swizframework.factory.IInitializingBean;

	public class History implements IInitializingBean
	{
		
		[Autowire]
		public var painterWindow : PainterWindow;
		
		private var addedBitmap : Bitmap;
		private var _states : Array = [];
		
		public function initialize() : void {
			
		
			// обработать painterWindow
			
			// создать _mergedData
			
			var source : DisplayObject = painterWindow.bottle;
			var bitmapData : BitmapData = new BitmapData(source.width, source.height);
			//var mask : DisplayObject = new Bitmap( new Bottle(source.width, source.height) );
			
			addedBitmap = new Bitmap(bitmapData);
				
			painterWindow.addChild(addedBitmap);
			
			//painterWindow.addChild(mask);
			/*
			var sp : Sprite = new Sprite();
			sp.graphics.beginFill( 0 );
			sp.graphics.drawCircle( 100, 100, 50 );
			sp.graphics.endFill();
			
			painterWindow.addChild(sp);
			*/
			
			//addedBitmap.mask = sp;
			bitmapData.draw(painterWindow.bottle);
			_states.push(bitmapData);
			
			
		} 
		
		/*
		public function get currentGraphics() : Graphics {
			var length : int = _states.length
			if( length > 0 ) {
				return Shape(_states[length - 1]).graphics;
			} else {
				return null;
			}
		}*/
		
		public function get currentState () : BitmapData 
		{
			if (_states.length > 0)
					return _states[length-1]
			else
					return null;
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