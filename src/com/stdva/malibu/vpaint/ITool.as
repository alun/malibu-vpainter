package com.stdva.malibu.vpaint
{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public interface ITool
	{
		function mouseDown( point : Point ) : void;
		function mouseUp( point : Point ) : void;
		function mouseMove( point : Point,buttonDown : Boolean ) : void;
		
		function get icon () : DisplayObject;
	}
}