package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	
	import mx.events.ModuleEvent;
	
	import org.swizframework.factory.IInitializingBean;
	


	public class MySlider extends EventDispatcher implements IInitializingBean 
	{
		public var scale : DisplayObject;
		public var todder : DisplayObject;
		public static const CHANGED : String = "changed";
		
		[Bindable(event=CHANGED)]
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
			toGoX = scale.x + e.localX;
			
			/*
			var stagePoint : Point  = new Point (e.stageX,e.stageY)
			var settingsPoint : Point = painterWindow.globalToLocal(stagePoint);
			toGoX = settingsPoint.x;
			*/
			//todder.x = e.stageX;
		}
		private function onMouseMove (e : MouseEvent) : void
		{
			if (e.buttonDown)
			{
				toGoX = scale.x + e.localX;
				
				/*
				var stagePoint : Point  = new Point (e.stageX,e.stageY)
				var settingsPoint : Point = painterWindow.globalToLocal(stagePoint);
				toGoX = settingsPoint.x;
				*/
				//toGoX = e.stageX;
				//todder.x = e.stageX;
			}
		}
		
		private var toGoX : int;
		private static const k : Number = 0.7;
		
		private var epsilon : Number = 2;
		private function doFrame (e : *) : void
		{
			if (Math.abs(todder.x - toGoX)>epsilon)
			{
				todder.x = todder.x+ (toGoX - todder.x)*k;
				dispatchEvent(new Event(CHANGED));
			}
		}
		
		
		
		
	
	}
}