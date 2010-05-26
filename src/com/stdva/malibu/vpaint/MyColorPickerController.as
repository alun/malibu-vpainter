package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.MyColorPicker;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	import mx.events.ColorPickerEvent;

	public class MyColorPickerController extends Sprite
	{
		private var picker : com.stdva.malibu.MyColorPicker;
		
		
		public function MyColorPickerController()
		{
			picker = new com.stdva.malibu.MyColorPicker;
			addChild(picker);
			
			picker.clickArea.addEventListener(MouseEvent.MOUSE_DOWN,onClickArea);
			picker.pickerPopUp.visible = false;
			
			picker.pickerPopUp.pickerMap.addEventListener(MouseEvent.MOUSE_DOWN, onPickerMap)
				
			colorSpot();
		}
		
		private function onClickArea (e : *) : void
		{
			picker.pickerPopUp.visible = !picker.pickerPopUp.visible;
		}
		
		private function onPickerMap (e :MouseEvent) : void
		{
			var map : DisplayObject = picker.pickerPopUp.pickerMap;
			var bitmapData : BitmapData = new BitmapData(map.width, map.height);
			bitmapData.draw(map);
			_selectedColor = bitmapData.getPixel(e.localX,e.localY)
			dispatchEvent(new Event(ColorPickerEvent.CHANGE));
			colorSpot ();
				
			picker.pickerPopUp.visible = false;
			
		
		}
		
		private var _selectedColor : uint = 0x000000;
		public function get selectedColor () : uint
		{
			
			return _selectedColor;
		}

		private function colorSpot () : void
		{
			
			var bitmapData : BitmapData = new BitmapData(picker.spot.width, picker.spot.height,true,0x000000);
			bitmapData.draw(picker.spot);
			
			var rect:Rectangle = new Rectangle(0, 0, picker.spot.width, picker.spot.height);
			var colorTransform: ColorTransform = new ColorTransform();
			colorTransform.color = selectedColor;	
			bitmapData.colorTransform(rect,colorTransform);
			
			var i : int = picker.spot.numChildren;
			for (var j : int; j < i; j++)
			{
				picker.spot.removeChildAt(0);
			}
			picker.spot.addChild(new Bitmap(bitmapData))
			
		}
		
	}
}