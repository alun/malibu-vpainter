package com.stdva.malibu.vpaint
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	import mx.controls.ColorPicker;
	import mx.events.ColorPickerEvent;
	
	import spark.primitives.Rect;
	
	public class MaskColorPicker extends ColorPicker
	{
		private var viewMask : Bitmap;
		private var myColorPicker : MyColorPicker;
		private var rect : Rectangle;
		public function MaskColorPicker()
		{
			super();
			
			myColorPicker = new MyColorPicker;
			myColorPicker.y = - myColorPicker.height;
			addChild(myColorPicker);
			
			rect = new Rectangle(0, 0, myColorPicker.width, myColorPicker.height);	
			
			var bmd : BitmapData = new Spot(myColorPicker.width, myColorPicker.height);
			viewMask = new Bitmap(bmd);
			viewMask.height = myColorPicker.height;
			viewMask.scaleX = viewMask.scaleY;
			viewMask.y  = - myColorPicker.height;
			addChild(viewMask);
				
			addEventListener(MouseEvent.MOUSE_DOWN,function (e:*):void 
			{
				open();
			});
			
			addEventListener(ColorPickerEvent.CHANGE,function (e:*) : void 
			{
					fill ();
			});
			fill ();
	}
		
		public function fill () : void
		{
			
			
			var colorTransform : ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 1)
			colorTransform.color = selectedColor;		
			viewMask.bitmapData.colorTransform(rect,colorTransform);
		}
		
		override public function drawFocus(isFocused:Boolean):void {
		}

		
	}
}