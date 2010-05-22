package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import org.swizframework.factory.IInitializingBean;

	public class ToolSelecter  implements IInitializingBean
	{
		private var tools : Array = [];
		private var icons : Array = [];
		
		private var frameSize : int;
		private var layoutIndex : int = 1;
		
		
		private var layoutedTools : Array = [];
		private var layoutedIcons : Array = [];
		private var listeners : Array = [];
		
		[Autowire]
		public var painterWindow : PainterWindow;
		
		[Autowire]
		public var drawingParams : DrawingParams;
		
		public function reset () : void
		{
			for each (var icon : DisplayObject in layoutedIcons)
			{
				painterWindow.settings.removeChild(icon);
			}
			tools = [];
			icons = [];
			layoutedIcons = [];
			layoutedTools = [];
			
			for each (var listener : Function in listeners)
			{
				painterWindow.settings.frame1.removeEventListener(MouseEvent.MOUSE_DOWN, listener);
				painterWindow.settings.frame2.removeEventListener(MouseEvent.MOUSE_DOWN, listener);
				painterWindow.settings.frame3.removeEventListener(MouseEvent.MOUSE_DOWN, listener);
				painterWindow.settings.frame4.removeEventListener(MouseEvent.MOUSE_DOWN, listener);
				painterWindow.settings.frame5.removeEventListener(MouseEvent.MOUSE_DOWN, listener);
				painterWindow.settings.frame6.removeEventListener(MouseEvent.MOUSE_DOWN, listener);

			}
			
		}		
		public function layout () : void
		{
			frameSize = painterWindow.settings.frame1.width;
			for (var i : int = layoutIndex ; i  < tools.length + 1  && i - layoutIndex < 6 ; i++)
			{
				var icon : DisplayObject = icons[i-1];
				var frameNumber : int =  i - layoutIndex+1;
				
				var idx : int = 	painterWindow.settings.getChildIndex(painterWindow.settings["frame"+frameNumber])
				//painterWindow.settings.addChildAt(icon,);
				painterWindow.settings.addChild(icon);
				
				if (icon.width > icon.height)
				{
					icon.width = frameSize;
					icon.scaleY = icon.scaleX;
				}	
				
				icon.x = painterWindow.settings["frame"+frameNumber].x + (frameSize - icon.width)/2
				icon.y = painterWindow.settings["frame" + frameNumber].y + (frameSize - icon.height)/2
			
				layoutedIcons.push(icon);
				layoutedTools.push(tools[i-1]);
				
				var listener : Function = function (e : MouseEvent) : void 
				{
					painterWindow.settings.frame1.alpha = 0;
					painterWindow.settings.frame2.alpha = 0;
					painterWindow.settings.frame3.alpha = 0;
					painterWindow.settings.frame4.alpha = 0;
					painterWindow.settings.frame5.alpha = 0;
					painterWindow.settings.frame6.alpha = 0;
					
					if (e)
					{
					e.target.alpha = 1;
					var selectedFrame : int = e.target.name.charAt(e.target.name.length - 1);
					drawingParams.currentTool = layoutedTools[selectedFrame - 1]
					}
					
				};
    			painterWindow.settings["frame" + frameNumber ].addEventListener(MouseEvent.MOUSE_DOWN, listener )
				listeners.push(listener);
					
			}
			
			listeners[0](null);
		}
		public function addTool (tool :ITool) : void
		{
			tools.push(tool);
			var icon : DisplayObject = tool.icon;
			icons.push(icon);
		}
		
		public function selectTool (i : int) : void
		{
			
		}
		public function initialize() : void {
			
		}
	}
}