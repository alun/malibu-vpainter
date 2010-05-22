package com.stdva.malibu.vpaint.gui
{
	import com.stdva.malibu.Bottle;
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.Bitmap;
	
	import org.swizframework.factory.IInitializingBean;

	public class Configurator implements IInitializingBean
	{
		
		[Autowire]
		public var window : PainterWindow;
		
		
		public function initialize() : void {
			//trace( window.bottle.x );
			//trace( window.bottle.y );
		}
		
	}
}