package com.stdva.malibu
{
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Fonts extends Sprite
	{
		public static function apply( textField : TextField, fontName : String ) : void {

			var format : TextFormat = textField.defaultTextFormat;
			format.font = fontName;
			
			textField.defaultTextFormat = format;
			textField.embedFonts = true;

		}
		
		public static function showEmbeddedFonts ( ):void {
		  trace("========Embedded Fonts========");
		  var fonts:Array = Font.enumerateFonts( );
		  
		  fonts.sortOn("fontName", Array.CASEINSENSITIVE);
		  
		  for each (var font : Font in fonts)
		    trace(font.fontName + ", " + font.fontStyle + ", " + font.fontType );
		}				
	}
}