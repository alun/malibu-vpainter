package com.stdva.malibu.vpaint
{
	import flash.display.DisplayObject;
	
	import org.swizframework.factory.IInitializingBean;

	[DefaultProperty("tools")]
	public class ToolSet implements IInitializingBean
	{
		
		[ArrayElementType("com.stdva.malibu.vpaint.ITool")]
		public var tools : Array;
		
		public function initialize() : void {
		}
		
		public function getWithType (type : String) : Array
		{
			var arr : Array = [];
			for each (var tool : ITool in tools)
			{
				if (tool.type == type)
					arr.push(tool);
			}
			return arr;
		}
	
		
		
	}
}