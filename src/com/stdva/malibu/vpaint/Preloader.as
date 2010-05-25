package com.stdva.malibu.vpaint
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import mx.events.FlexEvent;
	import mx.events.RSLEvent;
	import mx.preloaders.IPreloaderDisplay;
	
	public class Preloader extends Sprite implements IPreloaderDisplay
	{
		private static const PROGRESS_WHEN_LOADED:Number = 0.8;
		private static var instance:Preloader;
		private var _preloader:Sprite;
		private var timer:Timer;
		// Реальный прогресс, [0, 1]
		private var realProgress:Number;
		private var _progress:Number;
		private var _stageWidth:Number;
		private var _stageHeight:Number;
		
		private var _loader : MalibuLoader;
		
		public function Preloader()
		{
			super();
			
			instance = this;
			realProgress = 0;
			timer = new Timer(40);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
			
			show();
		}
		
		public static function getInstance():Preloader
		{
			return instance;
		}
		
		public function get backgroundAlpha():Number { return 0; }
		public function set backgroundAlpha(value:Number):void {}
		public function get backgroundColor():uint { return 0; }
		public function set backgroundColor(value:uint):void {}
		public function get backgroundImage():Object { return null; }
		public function set backgroundImage(value:Object):void {}
		public function get backgroundSize():String  { return null; }
		public function set backgroundSize(value:String):void { }
		public function set preloader(obj:Sprite):void
		{
			_preloader = obj;
			
			// TODO: По хорошему надо слушать еще и Error-события, см. родной метод в DownloadProgressBar
			obj.addEventListener(RSLEvent.RSL_ERROR, rslErrorHandler);
			obj.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			obj.addEventListener(FlexEvent.INIT_COMPLETE, initCompleteHandler);
			obj.addEventListener(FlexEvent.INIT_PROGRESS, initProgressHandler);
		}
		public function get stageHeight():Number { return _stageHeight; }
		public function set stageHeight(value:Number):void { _stageHeight = value; align(); }
		public function get stageWidth():Number { return _stageWidth; }
		public function set stageWidth(value:Number):void { _stageWidth = value; align(); }
		public function initialize():void {}
		
		protected function show():void
		{
			_loader = new MalibuLoader();
			addChild(_loader);
			
			progress = 0;
			
			align();
			
			visible = true;
		}
		
		protected function hide():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
			
			visible = false;
		}
		
		protected function showError():void
		{
		}
		
		protected function align():void
		{
			var x:Number = 0;
			var y:Number = 0;
			if (stageHeight && stageWidth)
			{
				x = stageWidth/2 - width/2;
				y = stageHeight/2 - height/2; 
			}
			this.x = x;
			this.y = y;
		}
		
		// Это свойство будет устанавливаться из Flex-приложения
		public function set applicationInitProgress(value:Number):void
		{
			realProgress = PROGRESS_WHEN_LOADED + value * (1 - PROGRESS_WHEN_LOADED);
			trace("aIP realProgress: " + realProgress);
		}
		
		protected function get progress():Number
		{
			return _progress;
		}
		
		// Установка визуального оформления
		protected function set progress(value:Number):void
		{
			_progress = value;
			
			var percent:Number = Math.round(_progress * 100);
			_loader.gotoAndStop( percent );
			trace("progress: " + percent.toString()); 
		}
		
		// event handlers
		
		protected function initProgressHandler(event:FlexEvent):void {
		}
		
		protected function progressHandler(event:ProgressEvent):void
		{
			realProgress = event.bytesLoaded/event.bytesTotal * (PROGRESS_WHEN_LOADED);
			trace("ph  realProgress: " + realProgress);
			// TODO: логика нашего прелоадера
		}
		
		protected function initCompleteHandler(event:Event):void
		{
			applicationInitProgress = 1;
		}
		
		protected function rslErrorHandler(event:RSLEvent):void
		{
			showError();
		}
		
		protected function timerHandler(event:Event):void
		{
			if (realProgress > progress)
			{
				progress += 0.015;
			}
			
			if (progress >= 1)
			{
				hide();
			}
		}
	}
}