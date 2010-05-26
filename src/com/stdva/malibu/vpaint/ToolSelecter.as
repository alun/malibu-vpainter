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
		
		[Autowire]
		public var toolSet : ToolSet;
		
		[Autowire]
		public var guiListener : GUIListener;
		
		
		public function reset () : void
		{
			cleanCells();
			
			tools = [];
			icons = [];
		}
		public function cleanCells () : void
		{
			for each (var icon : DisplayObject in layoutedIcons)
			{
				painterWindow.settings.removeChild(icon);
			}
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
			frameSize = painterWindow.settings.frame1.width-2;
			for (var i : int = layoutIndex ; i  < tools.length + 1  && i - layoutIndex < 6 ; i++)
			{
				var icon : DisplayObject = icons[i-1];
				var frameNumber : int =  i - layoutIndex+1;
				
				var idx : int = 	painterWindow.settings.getChildIndex(painterWindow.settings["frame"+frameNumber])
				//painterWindow.settings.addChildAt(icon,0);
				painterWindow.settings.addChild(icon);
				painterWindow.settings.addChild(painterWindow.settings["frame"+frameNumber]);
			
				if (icon.width > frameSize)
				{
					icon.width = frameSize;
					icon.scaleY = icon.scaleX;
				}
				if (icon.height > frameSize)
				{
					icon.height = frameSize;
					icon.scaleX = icon.scaleY;
				}
				
				/*
				if (icon.width > icon.height)
				{
					icon.width = frameSize;
					icon.scaleY = icon.scaleX;
				}	
				else
				{
					icon.height = frameSize;
					icon.scaleX = icon.scaleY;
				}
				*/
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
			
			
			painterWindow.settings.frame1.alpha = 0;
			painterWindow.settings.frame2.alpha = 0;
			painterWindow.settings.frame3.alpha = 0;
			painterWindow.settings.frame4.alpha = 0;
			painterWindow.settings.frame5.alpha = 0;
			painterWindow.settings.frame6.alpha = 0;
			if (layoutedTools.length)
			{
				painterWindow.settings.frame1.alpha = 1;
				drawingParams.currentTool = layoutedTools[0];
			}
			else
			{
				drawingParams.currentTool =toolSet.tools[0];
			}
			
			setArrows();
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
		
		
		
		public function back () : void
		{
			if (layoutIndex>=3)
			{	
				cleanCells();
				layoutIndex -=2;
				layout();
			}
		}
		
		public function forward () : void
		{
			if (tools.length - layoutIndex >5) 
			{
				cleanCells();
				layoutIndex +=2;
				layout();
			}
		}
		
		public function goToLast () : void
		{
			if (tools.length > 6)
			{
				if (tools.length == 2 * int(tools.length/2)) 
					layoutIndex = tools.length-6+1;
				else
					layoutIndex = tools.length-5+1;
			}
		}
		public function goToFirst():void
		{
			layoutIndex = 1;
		}
		
		private function setArrows() : void
		{
			
			if (tools.length - layoutIndex >5)
				guiListener.forwardPagerActive = true;
			else
				guiListener.forwardPagerActive = false;
			
			if (layoutIndex>=3)
				guiListener.backPagerActive = true;
			else
				guiListener.backPagerActive = false;
				
		}
		
		
	}
}