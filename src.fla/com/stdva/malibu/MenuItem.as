package com.stdva.malibu {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class MenuItem extends MovieClip {
		
		public function MenuItem() {
			
			mouseChildren = false;
			
			addEventListener( MouseEvent.MOUSE_OVER, function( e : MouseEvent ) : void {
				normal_label.textColor = 0xAEAEAE;
			} );

			addEventListener( MouseEvent.MOUSE_OUT, function( e : MouseEvent ) : void {
				normal_label.textColor = 0x484848;
			} );
			
			selected = false;
			
		}
		
		public function set label( text : String ) : void {
			normal_label.text = 
				selected_label.text =
				text;
		}
		
		public function set selected( selected : Boolean ) : void {
			normal_label.visible = ! selected;
			selected_label.visible = selected;
			
			useHandCursor = buttonMode = ! selected;
		}
		
		public function get selected( ) : Boolean {
			return selected_label.visible;
		}
	}
	
}