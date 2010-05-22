package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.formatters.CurrencyFormatter;
	
	import org.swizframework.factory.IInitializingBean;

	public class FontDrawTool implements ITool, IInitializingBean
	{
		//public var fontFileName : String;
		public var fontFamily : String;
		
		[Autowire]
		public var history : History;
		
		[Autowire]
		public var drawingParams : DrawingParams;
		
		public function FontDrawTool()
		{
			/*
			[Embed( source=fontFileName , fontName='foo', mimeType='application/x-font' )] 
		    var myfont : Class; 
		*/
			}
		
		private var currentTextField : TextField;
		private var currentTextFormat : TextFormat;
		
		private function beginDraw (point:Point) : void
		{
			if (currentTextField)
				stopDraw();
			
			var textField : TextField = new TextField();
			var textFormat : TextFormat = new TextFormat ();
			textField.embedFonts=true;
			textField.selectable = false;
			textField.border=true;
			textField.autoSize=TextFieldAutoSize.LEFT;
			currentTextField = textField;
			
			textFormat.size = int(drawingParams.brushSize);
			textFormat.color = drawingParams.color;
			textFormat.font=fontFamily;
			
			currentTextFormat = textFormat;
			
			textField.text=" ";//adsfasdhfjuhyrfvjhnksdfjklgsdhfjklghsdlfhgfjf";
			textField.setTextFormat(textFormat);
			
			textField.x = point.x;
			textField.y=point.y - textField.height/2;
			
			history.currentSprite.addChild(textField);	
			
			textField.stage.focus = textField;
			
			textField.type = "input"
			textField.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			textField.addEventListener(FocusEvent.FOCUS_OUT,onFinishDraw);
			textField.stage.addEventListener(MouseEvent.CLICK,onFinishDraw)
			
			currentTextFormat = textFormat;
			currentTextField = textField;
			
		}
		
		private function stopDraw () : void
		{
			if (currentTextField)
			{
				//currentTextField.appendText("q");
				currentTextField.border=false;
				history.checkout();
				currentTextField.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
				currentTextField.removeEventListener(FocusEvent.FOCUS_OUT,onFinishDraw);
				//currentTextField.stage.removeEventListener(MouseEvent.CLICK,onFinishDraw)
				
				currentTextField=null;
				currentTextFormat=null;
			}
		}
		
		public function mouseDown(point:Point):void
		{
			beginDraw(point);
		}
		
		public function onFinishDraw (e : * = null) : void
		{
			stopDraw();
		}
		
		public function mouseUp(point:Point):void
		{
			
		}
		
		public function mouseMove(point:Point, buttonDown:Boolean):void
		{
			
		}
		
		public function initialize():void
		{

		}
		
		public function onKeyDown (e : KeyboardEvent) : void
		{
			currentTextField.appendText("");
			history.changed=Boolean(currentTextField.text.length);
		}
		
		public function get icon () : DisplayObject
		{
			var textField : TextField = new TextField();
			var textFormat : TextFormat = new TextFormat ();
			textField.embedFonts=true;
			textField.selectable = false;
			//textField.border=true;
			textField.autoSize=TextFieldAutoSize.LEFT;
			//currentTextField = textField;
			
			textFormat.size =35;// int(drawingParams.brushSize);
			textFormat.color = 0x000000;
			textFormat.font=fontFamily;
			
			//currentTextFormat = textFormat;
			
			textField.text="Aa";//adsfasdhfjuhyrfvjhnksdfjklgsdhfjklghsdlfhgfjf";
			textField.setTextFormat(textFormat);
			
			var s : Sprite = new Sprite;
			s.addChild(textField);
			//s.width = 100;
			//s.height = 100;
			
			var bmd : BitmapData = new BitmapData(s.width,s.height);
			bmd.draw(s);
			var bm : Bitmap = new Bitmap(bmd);
			
			return bm;
		}
	}
}