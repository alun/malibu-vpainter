package com.stdva.malibu.vpaint
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class MyCheckBox
	{
		
		private var check : DisplayObject;
		private var frame : DisplayObject;
		
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
		}
		
		private function set checked (b : Boolean) : void
		{
			check.visible = b;
		}
		
		private function get checked () : Boolean
		{
			return check.visible;
		}
		
		
		
	}
}