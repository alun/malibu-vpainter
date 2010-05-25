package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.AddToGalleryWindow;
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import mx.controls.CheckBox;
	import mx.controls.TextInput;
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
		private var checkBox : MyCheckBox;
		
		private var name : TextField;
		private var secondName : TextField;
		private var age : TextField;
		private var email : TextField;
		private var phone : TextField;
		private var address : TextField;
		private var comment : TextField;
		
	
		[Autowire]
		public function set addToGalleryWindow( window : AddToGalleryWindow) : void 
		{
			_addToGalleryWindow = window;
			addEventListeners();	
			checkBox = new MyCheckBox(_addToGalleryWindow.checkFrame, _addToGalleryWindow.check);
		
			addTextField(name,_addToGalleryWindow.nameRect);
			addTextField(secondName,_addToGalleryWindow.secondNameRect);
			addTextField(age,_addToGalleryWindow.ageRect);
			addTextField(email,_addToGalleryWindow.emailRect);
			addTextField(phone,_addToGalleryWindow.phoneRect);
			addTextField(address,_addToGalleryWindow.addressRect);
			addTextField(comment,_addToGalleryWindow.commentRect);
			
		}
		public function addTextField (t : TextField, r : DisplayObject) : void
		{
			t = new TextField;
			t.type = "input";
			t.text = "";
			t.wordWrap = true;
			fit (t, r);
			_addToGalleryWindow.addChild(t);
		}
		
		public function fit (t : TextField, r : DisplayObject) : void
		{
			t.x = r.x;
			t.y = r.y;
			t.width = r.width;
			t.height = r.height;
		}
		
		public function addEventListeners () : void
		{
			_addToGalleryWindow.closeButton.addEventListener(MouseEvent.MOUSE_DOWN,onClose)
		}
		
		private function onClose (e : *) : void
		{
			var virtualPainter : VirtualPainter = FlexGlobals.topLevelApplication as VirtualPainter;
			virtualPainter.showAddToGallery = false;
		}
		
	}
}