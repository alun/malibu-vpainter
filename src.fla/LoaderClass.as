// Document class for loading Flex into Flash example
//
// Jim Armstrong, algorithmist.wordpress.com
//
// This is a hack, but have fun with it :)

package
{
  import flash.display.*;
  import flash.events.*;
  import flash.net.URLRequest;

  import flash.system.ApplicationDomain;
  import flash.system.LoaderContext;
  
  import flash.utils.Dictionary;

  public class LoaderClass extends MovieClip
  {
    private var _loadedClip:MovieClip;     // loaded content cast as MovieClip
	private var _loader:Loader;            // reference to external asset loader
    private var _application:*;            // reference to loaded application (<mx:Application>)
	
	private var _totalBytes : Number = 1;
	private var _loadedBytes : Number = 0;
	
	private var _brushesLoader : Loader;

    public function LoaderClass()
    {
      _loadedClip = null;
	  
	  _loader            = new Loader();
//	  _brushesLoader	 = new Loader();
      var info:LoaderInfo = _loader.contentLoaderInfo;

      info.addEventListener(ProgressEvent.PROGRESS, onProgress);
//	  _brushesLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
	  
      info.addEventListener(Event.COMPLETE        , __onComplete);
      //info.addEventListener(Event.INIT            , __onInit    ); - uncomment if you want init event handling
      info.addEventListener(IOErrorEvent.IO_ERROR , __onIOError );

      var loaderContext:LoaderContext = new LoaderContext();
      loaderContext.applicationDomain = ApplicationDomain.currentDomain;
			
      _loader.load( new URLRequest("VirtualPainter.swf"), loaderContext );
	  
//	  _brushesLoader.load( new URLRequest("brushes.swf"), loaderContext );

		progressMc.gotoAndStop( 1 );
	}

	private var _progress : Dictionary = new Dictionary();

	private function onProgress( e : ProgressEvent ) : void {
//		var tgt : LoaderInfo = e.target as LoaderInfo;
//
//		if( _progress[ tgt ] == null ) {
//			_progress[ tgt ] = {
//				loaded : 0,
//				total : 1
//			}		
//		}
//		
//		var progressInfo = _progress[tgt];
//		
//		progressInfo.total = e.bytesTotal;
//		progressInfo.loaded = e.bytesLoaded;
		
		progressMc.gotoAndStop( int(e.bytesLoaded / e.bytesTotal) );
	}
	
	private function updateProgress( ) : void {
		
		var total : Number = 0.1;
		var loaded : Number = 0;
		
		for each( var progressInfo in _progress ) {
			total += progressInfo.total;
			loaded += progressInfo.loaded;
		}
		
		progressMc.gotoAndStop( int(loaded / total) );
	}

	private function __onComplete(_evt:Event):void
    { 
      addChild(_loader);

      _loadedClip = _loader.content as MovieClip;
      _loadedClip.addEventListener(Event.ENTER_FRAME, __onFlexAppLoaded);
    }

    // poll loaded Flex clip until application property is set (Flex completes its own internal initialization)
    private function __onFlexAppLoaded(_evt:Event):void
    {
      if( _loadedClip.application != null )
      {
        _loadedClip.removeEventListener(Event.ENTER_FRAME, __onFlexAppLoaded);
 
        _application = _loadedClip.application;

	    // handler for Flex button click event
        _application.addEventListener("FlexButtonClick", __onClick);
	  }
	}


    private function __cleanup():void
    {
      var info:LoaderInfo = _loader.contentLoaderInfo;

	  // info.removeEventListener(ProgressEvent.PROGRESS, __onProgress);
	  // info.removeEventListener(Event.INIT    , __onInit    );
      info.removeEventListener(Event.COMPLETE, __onComplete);
      info.removeEventListener(IOErrorEvent.IO_ERROR , __onIOError );
    }

    private function __onIOError(_evt:IOErrorEvent):void
    {
      trace( "io error - check file names and location" );
	}

    private function __onInitialize(_e:Event):void
    {
      __cleanup();
    }

    private function __onClick(_evt:Event):void
    {
      // disable Flex button and call the myFunction() method - notice that you have to know something about what's being loaded
      _application.__myButton__.enabled = false;
      _application.myFunction();
 	}
  }
}