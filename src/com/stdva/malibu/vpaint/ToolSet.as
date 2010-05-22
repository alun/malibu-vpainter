package com.stdva.malibu.vpaint
{
	import org.swizframework.factory.IInitializingBean;

	[DefaultProperty("tools")]
	public class ToolSet implements IInitializingBean
	{
		
		[ArrayElementType("com.stdva.malibu.vpaint.ITool")]
		public var tools : Array;
		
		public function initialize() : void {
		}
		
		
		
		}
}