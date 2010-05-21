package com.stdva.malibu.vpaint
{
	import flash.geom.Point;

	public interface ITool
	{
		function mouseDown( point : Point ) : void;
		function mouseUp( point : Point ) : void;
		function mouseMove( point : Point,buttonDown : Boolean ) : void;
		function pushKey (k : int) : void;
	}
}