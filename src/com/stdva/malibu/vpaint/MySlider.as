package com.stdva.malibu.vpaint
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.DisplacementMapFilter;
	
	import mx.events.ModuleEvent;
	
	import org.swizframework.factory.IInitializingBean;

	public class MySlider implements IInitializingBean 
	{
		public var scale : DisplayObject;
		public var todder : DisplayObject;
		public function get value () : int
		{
			return (todder.x - scale.x) * 100 / scale.width;
		}
		public function set value (v : int) : void
		{
			todder.x = scale.x + scale.width*v / 100;
		}
		public function initialize() : void 
		{
			scale.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			scale.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);	
			scale.addEventListener(Event.ENTER_FRAME, doFrame);
			toGoX = todder.x;
		}
		private function onMouseDown (e : MouseEvent) : void
		{
			toGoX =  e.stageX;
			//todder.x = e.stageX;
		}
		private function onMouseMove (e : MouseEvent) : void
		{
			if (e.buttonDown)
			{
				toGoX = e.stageX;
				//todder.x = e.stageX;
			}
		}
		
		private var toGoX : int;
		private static const k : Number = 0.7;
		
		private function doFrame (e : *) : void
		{
			todder.x = todder.x+ (toGoX - todder.x)*k;
		}
		
		
		
		
	
	}
}