package com.stdva.malibu.vpaint
{
	import com.stdva.malibu.Bottle;
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import org.swizframework.factory.IInitializingBean;

	public class History implements IInitializingBean
	{
		public const HISTORY_SIZE : Number = 20;
		
		[Autowire]
		public var painterWindow : PainterWindow;
		
		[Autowire][Bindable]
		public var drawingParams : DrawingParams;
		
		/*
		 * Картинка на которой сейчас рисуем
		 */
		public var currentLayer : Bitmap;
		
		/*
		* Последняя картинка
		*/
		private var recentLayer : Bitmap;
		
		/*
		 * Массив последних картинок
		 */
		private var _historyLayers : Array = [];
		
		
		public function initialize() : void {
			
			currentLayer = createLayer();
			currentLayer.alpha = drawingParams.opacity;
			recentLayer = createLayer();
			
			var bottle : DisplayObject = painterWindow.bottle;
			
			var idx : int = painterWindow.getChildIndex( bottle );
			
			currentLayer.mask = painterWindow.maskArea;
			
			var bottleOverlay : Bitmap = new Bitmap( new Bottle(0,0) );
			bottleOverlay.blendMode = BlendMode.MULTIPLY;
			bottleOverlay.transform = bottle.transform;
			
			bottle.blendMode = BlendMode.HARDLIGHT;
			
			painterWindow.addChildAt( recentLayer, idx + 1 );
			painterWindow.addChildAt( currentLayer, idx + 2 );
			painterWindow.addChildAt( bottleOverlay, idx + 3 );
			
			drawingParams.addEventListener(DrawingParams.CHANGED,function (e : *) : void 
			{
				currentLayer.alpha = drawingParams.opacity;
			});
		}
		
		private function removeLayer( layer : Bitmap ) : void {
			try {
				painterWindow.removeChild( layer );
			} catch( e : Error ) {
			}
		}
		
		private function prepareLayers() : void {
			
			if( currentLayer != null ) {
				removeLayer( currentLayer );
			}
			currentLayer = createLayer();
			
			if( recentLayer != null ) {
				removeLayer( recentLayer );
			} 
			recentLayer = createLayer();
			
		}
		
		private function createLayer() : Bitmap {
			var source : DisplayObject = painterWindow.bottle;
			var bitmapData : BitmapData = new BitmapData(source.width, source.height, true, 0);
			
			return new Bitmap(bitmapData);
		} 
		
		/**
		 * Начинает новый слой истории 
		 */
		public var changed : Boolean = false;
		public function checkout() : void {
		
			if (changed)
			{
				painterWindow.removeChild(  recentLayer );
				painterWindow.removeChild( currentLayer );
				
				var s : Sprite = new Sprite;
				s.addChild(recentLayer);
				s.addChild(currentLayer);
				
				var b : Bitmap = createLayer();
				b.bitmapData.draw(s);
				
				_historyLayers.push(recentLayer.bitmapData);
				
				recentLayer = new Bitmap(b.bitmapData);
				currentLayer = createLayer();
				currentLayer.alpha = drawingParams.opacity;
				currentLayer.mask = painterWindow.maskArea;
				
				var idx : int = painterWindow.getChildIndex( painterWindow.bottle );
				painterWindow.addChildAt( recentLayer, idx + 1 );
				painterWindow.addChildAt( currentLayer, idx + 2 );
			}
			changed = false;
			
		}
		
		public function undo() : void {
			
			
		}

		public function redo() : void {
			
		}
	}
}