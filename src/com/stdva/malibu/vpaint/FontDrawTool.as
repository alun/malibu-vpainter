package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
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
		
		public function mouseDown(point:Point):void
		{
			
			if (currentTextField)
			{
				currentTextField.border=false;
			}
			
			
			var s : Sprite = new Sprite();
			var textField : TextField = new TextField();
			var textFormat : TextFormat = new TextFormat ();
			
			textField.embedFonts=true;
			textField.selectable = false;
			textField.border=true;
			textField.autoSize=TextFieldAutoSize.LEFT;
			
			currentTextField = textField;
			//textField.wordWrap=true;
			
			textFormat.size = 30;
			textFormat.color = drawingParams.color;
			textFormat.font=fontFamily;
			
			currentTextFormat = textFormat;
			
			//textField.y = 250;
			textField.text=" ";//adsfasdhfjuhyrfvjhnksdfjklgsdhfjklghsdlfhgfjf";
			textField.setTextFormat(textFormat);
			
			s.addChild(textField);
			
			
			
			s.x = point.x;
			s.y=point.y - textField.height/2;
			
			
			
			history.currentSprite.addChild(s);	
			s.stage.focus = textField;
			
			
			textField.type = "input"
			
				
			textField.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			textField.addEventListener(FocusEvent.FOCUS_OUT,onFinishDraw);
		
		}
		
		public function onFinishDraw (e : * = null) : void
		{
			currentTextField.border=false;
			history.checkout();
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
		}
		
		public function pushKey (k : int) : void
		{
			//currentTextField.appendText("adsf");
    	}
		
		
		
	}
}