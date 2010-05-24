package com.stdva.malibu.vpaint
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import org.swizframework.factory.IInitializingBean;
	
	public class EmptyTool implements ITool, IInitializingBean
	{
		public function EmptyTool()
		{
		}
		
		public function mouseDown(point:Point):void
		{
		}
		
		public function mouseUp(point:Point):void
		{
		}
		
		public function mouseMove(point:Point, buttonDown:Boolean):void
		{
		}
		
		public function get icon():DisplayObject
		{
			return null;
		}
		
		public function get type():String
		{
			return ToolTypes.EMPTY;
		}
		
		public function set type(v:String):void
		{
		}
		
		public function initialize():void
		{
		}
	}
}