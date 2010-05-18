package com.stdva.malibu.vpaint
{
	import org.swizframework.Swiz;
	import org.swizframework.factory.IInitializingBean;

	public class DrawingParams implements IInitializingBean
	{
		
		
		
		public var color : uint;
		public var opacity : Number;
		public var brushSize : Number;
		
		
	
		public var currentTool : ITool;
		
		public function initialize() : void 
		{
			currentTool = Swiz.getBean("brush1") as ITool;	
			
			color = 0xFF0000;
			
		} 
		
	}
	
}