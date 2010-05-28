package com.stdva.malibu.vpaint
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;

	public class MyCheckBox extends EventDispatcher
	{
		
		private var check : DisplayObject;
		private var frame : DisplayObject;
		
		public static const CKICKED : String = "MyCheckBoxClicked";
		
		public function MyCheckBox( frame : DisplayObject, check : DisplayObject)
		{
			this.frame = frame;
			this.check = check;
			
			frame.addEventListener(MouseEvent.MOUSE_DOWN,onCheckBox)	
			check.addEventListener(MouseEvent.MOUSE_DOWN,onCheckBox)	
		}
		
		private function onCheckBox (e : *) : void
		{
			checked = !checked;
			dispatchEvent(new Event(CKICKED));
		}
		
		public function set checked (b : Boolean) : void
		{
			check.visible = b;
		}
		
		public function get checked () : Boolean
		{
			return check.visible;
		}
		
		
		
	}
}