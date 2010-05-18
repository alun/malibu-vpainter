package com.stdva.malibu.vpaint
{
	import org.swizframework.Swiz;
	import org.swizframework.factory.IInitializingBean;

	public class DrawingParams implements IInitializingBean
	{
		
		public static const MAX_BRUSH_SIZE = 50;
		public static const MIN_BRUSH_SIZE = 5;
		
		
		
		public var color : uint;
		//public var opacity : Number;
		//public var brushSize : Number;
		
		
	
		public var currentTool : ITool;
		
		[Autowire]
		public var toolSet : ToolSet;
		
		[Autowire(bean="widthSlider")]
		public var widthSlider : MySlider;
		
		[Autowire(bean="alphaSlider")]
		public var alphaSlider : MySlider;
		
		public function initialize() : void 
		{
			currentTool = toolSet.tools[0];	
			
			color = 0xFF0000;
			//brushSize = 40;
			//opacity = 0.2;
		} 
		
		public function get brushSize () : int
		{
			return MIN_BRUSH_SIZE + (MAX_BRUSH_SIZE-MIN_BRUSH_SIZE)*widthSlider.value/100;
		}
		public function get opacity () : Number
		{
			return alphaSlider.value/100;
		}
		
		
		
		
		
		
	}
	
}