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
		public const HISTORY_SIZE : Number = 100;
		
		[Autowire]
		public var painterWindow : PainterWindow;
		
		[Autowire][Bindable]
		public var drawingParams : DrawingParams;
		
		[Autowire]
		public var guiListener : GUIListener;
		
		/*
		 * Картинка на которой сейчас рисуем
		 */
		public var currentLayer : Bitmap;
		
		/*
		* Последняя картинка
		*/
		public var recentLayer : Bitmap;
		
		public var currentSprite : Sprite;
		
		/*
		 * Массив последних картинок
		 */
		private var _historyLayers : Array = [];
		private var currentSpriteMask : DisplayObject;
		
		
		public function initialize() : void {
			
			currentLayer = createLayer();
			currentLayer.alpha = drawingParams.opacity;
			recentLayer = createLayer();
			currentSprite= new Sprite;
			currentSprite.alpha = drawingParams.opacity;
			
			var bottle : DisplayObject = painterWindow.bottle;
			
			var idx : int = painterWindow.getChildIndex( bottle );
			
			currentLayer.mask = painterWindow.maskArea;
			currentSpriteMask = new bottleMask;
			currentSpriteMask.x =  painterWindow.maskArea.x;
			currentSpriteMask.y =  painterWindow.maskArea.y;
			currentSprite.mask = currentSpriteMask;
			
			var bottleOverlay : Bitmap = new Bitmap( new Bottle(0,0) );
			bottleOverlay.blendMode = BlendMode.MULTIPLY;
			bottleOverlay.transform = bottle.transform;
			
			bottle.blendMode = BlendMode.HARDLIGHT;
			
			painterWindow.addChildAt( recentLayer, idx + 1 );
			painterWindow.addChildAt( currentLayer, idx + 2 );
			painterWindow.addChildAt( currentSprite, idx + 2 );
			painterWindow.addChildAt( bottleOverlay, idx + 4 );
			
			drawingParams.addEventListener(DrawingParams.CHANGED,function (e : *) : void 
			{
				currentLayer.alpha = drawingParams.opacity;
				currentSprite.alpha = drawingParams.opacity;
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
		private var redoArray : Array = [];
		public function checkout() : void {
		
			if (changed)
			{
				painterWindow.removeChild(  recentLayer );
				painterWindow.removeChild( currentLayer );
				painterWindow.removeChild(currentSprite);
				
				var s : Sprite = new Sprite;
				s.addChild(recentLayer);
				s.addChild(currentLayer);
				s.addChild(currentSprite);
				
				var b : Bitmap = createLayer();
				b.bitmapData.draw(s);
				
				_historyLayers.push(recentLayer.bitmapData);
				historyLimit () ;
				
				recentLayer = new Bitmap(b.bitmapData);
				currentLayer = createLayer();
				currentLayer.alpha = drawingParams.opacity;
				currentLayer.mask = painterWindow.maskArea;
				
				currentSprite = new Sprite;
				currentSprite.alpha = drawingParams.opacity;
				currentSprite.mask = currentSpriteMask;
				//currentSprite.mask = painterWindow.maskArea;
				
				var idx : int = painterWindow.getChildIndex( painterWindow.bottle );
				painterWindow.addChildAt( recentLayer, idx + 1 );
				painterWindow.addChildAt( currentLayer, idx + 2 );
				painterWindow.addChildAt(currentSprite,idx + 3);
				
				
				redoArray=[];
				checkButtons ();
			
			}
			
			changed = false;
			
			
		}
		
		private function checkButtons () : void
		{
			if (_historyLayers.length)
			{
				guiListener.backActive = true;
			}
			else
			{
				guiListener.backActive = false;
			}
			
			if (redoArray.length)
			{
				guiListener.forwardActive = true;
			}
			else
			{
				guiListener.forwardActive = false;
			}
		}
		
		public function undo() : void {
			
			if  (_historyLayers.length)
			{
				painterWindow.removeChild(  recentLayer );
				redoArray.push(recentLayer.bitmapData);
				historyLimit () ;
					
				recentLayer = new Bitmap (_historyLayers.pop());
				var idx : int = painterWindow.getChildIndex( painterWindow.bottle );
				painterWindow.addChildAt( recentLayer, idx + 1 );
			}
			checkButtons () ;
		}

		public function redo() : void {
			if (redoArray.length)
			{
				painterWindow.removeChild(  recentLayer );
				_historyLayers.push(recentLayer.bitmapData);
				historyLimit () ;
					
				recentLayer = new Bitmap (redoArray.pop());
				var idx : int = painterWindow.getChildIndex( painterWindow.bottle );
				painterWindow.addChildAt( recentLayer, idx + 1 );
			}
			checkButtons () ;
		}
		
		private function historyLimit () : void
		{
			if (_historyLayers.length > HISTORY_SIZE)
			{
				_historyLayers.splice(0,_historyLayers.length - HISTORY_SIZE);
			}
			
			if (redoArray.length > HISTORY_SIZE)
			{
				redoArray.splice(0,redoArray.length - HISTORY_SIZE);
			}			
			
		}
		
		
	}
}