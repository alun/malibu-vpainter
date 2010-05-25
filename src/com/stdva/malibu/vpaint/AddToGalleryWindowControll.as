package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.AddToGalleryWindow;
	import com.stdva.malibu.PainterWindow;
	
	import flash.events.MouseEvent;
	
	import mx.controls.CheckBox;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	
	import org.swizframework.factory.IInitializingBean;

	public class AddToGalleryWindowControll implements IInitializingBean
	{
		
		
		public function AddToGalleryWindowControll()
		{
			
			
		}
		public function initialize () : void
		{
			
		}
		private var _addToGalleryWindow : AddToGalleryWindow;
		private var checkBox : CheckBox;
	
		[Autowire]
		public function set addToGalleryWindow( window : AddToGalleryWindow) : void 
		{
			_addToGalleryWindow = window;
			addEventListeners();	
			
			addCheckBox();
			
			
		}
		
		public function addEventListeners () : void
		{
			_addToGalleryWindow.closeButton.addEventListener(MouseEvent.MOUSE_DOWN,onClose)
		}
		
		
		private function addCheckBox() : void
		{
			checkBox = new CheckBox(); 
			_addToGalleryWindow.addChild(checkBox);
			checkBox.label = "asdfasdf";
			checkBox.height = 30;
			checkBox.width = 50;
			
			

		}
		
		private function onClose (e : *) : void
		{
			var virtualPainter : VirtualPainter = FlexGlobals.topLevelApplication as VirtualPainter;
			virtualPainter.showAddToGallery = false;
		}
		
	}
}