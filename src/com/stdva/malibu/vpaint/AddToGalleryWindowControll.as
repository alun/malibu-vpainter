package com.stdva.malibu.vpaint
{
	import com.adobe.serialization.json.JSON;
	import com.stdva.malibu.AddToGalleryWindow;
	import com.stdva.malibu.AddedToGaleryWindow;
	import com.stdva.malibu.Fonts;
	import com.stdva.malibu.PainterWindow;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.ui.MouseCursor;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.graphics.codec.JPEGEncoder;
	import mx.utils.Base64Encoder;
	
	import org.swizframework.factory.IInitializingBean;

	public class AddToGalleryWindowControll implements IInitializingBean
	{
		
		
		public function AddToGalleryWindowControll()
		{
			
			
		}
		public function initialize () : void
		{
			
		}
		private var _addToGalleryWindow : AddToGalleryWindow;
		private var checkBox : MyCheckBox;
		
		private var agreeCheckBox : MyCheckBox;
		
		private var name : TextField;
		private var secondName : TextField;
		private var age : TextField;
		private var email : TextField;
		private var phone : TextField;
		private var address : TextField;
		private var comment : TextField;
		
		private var alert : TextField;
		
		private var bottleID : int;
		
		[Autowire]
		public var history : History;
	
		[Autowire]
		public function set addToGalleryWindow( window : AddToGalleryWindow) : void 
		{
			_addToGalleryWindow = window;
			
			checkBox = new MyCheckBox(_addToGalleryWindow.checkFrame, _addToGalleryWindow.check);
			
			agreeCheckBox = new MyCheckBox(_addToGalleryWindow.agreeCheckFrame,_addToGalleryWindow.agreeCheck);
		
			name = addTextField(_addToGalleryWindow.nameRect);
			secondName = addTextField(_addToGalleryWindow.secondNameRect);
			age = addTextField(_addToGalleryWindow.ageRect);
			email = addTextField(_addToGalleryWindow.emailRect);
			phone = addTextField(_addToGalleryWindow.phoneRect);
			address = addTextField(_addToGalleryWindow.addressRect);
			comment = addTextField(_addToGalleryWindow.commentRect);
			
			alert = new TextField();
			alert.selectable = false;
			alert.wordWrap = true;
			Fonts.apply( alert, "Arial" );
			_addToGalleryWindow.addChild(alert);
			var r : DisplayObject = _addToGalleryWindow.alertRect
			alert.x = r.x;
			alert.y = r.y;
			alert.width = r.width;
			alert.height = r.height;
			alert.text = ""
			alert.multiline = true;
			
			addEventListeners();	
			
			
			added = false;
			agreeCheckBox.checked = false;
			onAgreeCheckBox(null);
			
			
		}
		public function addTextField (r : DisplayObject) : TextField
		{
			var t : TextField = new TextField();
			t.type = "input";
			t.text = "";
			t.wordWrap = true;
			Fonts.apply( t, "Arial" );
			fit (t, r);
			t.multiline = true;
			_addToGalleryWindow.addChild(t);
			
			return t;
		}
		
		public function fit (t : TextField, r : DisplayObject) : void
		{
			t.x = r.x;
			t.y = r.y;
			t.width = r.width;
			t.height = r.height;
		}
		
		public function addEventListeners () : void
		{
			_addToGalleryWindow.closeButton.addEventListener(MouseEvent.MOUSE_DOWN, onClose);
			_addToGalleryWindow.saveButton.addEventListener(MouseEvent.CLICK, onSave);
			
			agreeCheckBox.addEventListener(MyCheckBox.CKICKED,onAgreeCheckBox)
				
				
			_addToGalleryWindow.faceBookLink.addEventListener(MouseEvent.MOUSE_DOWN,onFaceBookLink);	
			_addToGalleryWindow.twitterLink.addEventListener(MouseEvent.MOUSE_DOWN,onTwitterLink);
			_addToGalleryWindow.blogLink.addEventListener(MouseEvent.MOUSE_DOWN, onBlogLink);
			
		}
		
		private function onFaceBookLink (e : *) : void
		{
			var bottleLink : String = "http://www.glamour.ru/promo/malibu-by-u/gallery.php?bottle=" +bottleID;
			var request2 : URLRequest = new URLRequest( "http://www.facebook.com/share.php?u="+bottleLink+"&t=My Malibu bottle");
			navigateToURL(request2); 
		}
		private function onTwitterLink (e : *) : void
		{
			var bottleLink : String = "http://www.glamour.ru/promo/malibu-by-u/gallery.php?bottle=" +bottleID;
			var request2 : URLRequest = new URLRequest( "http://twitter.com/home?status=My Malibu bottle @Glamourrussia " + bottleLink);
			navigateToURL(request2); 
		}
		private function onBlogLink (e : * ) : void
		{
			
			var bottleLink : String = "http://www.glamour.ru/promo/malibu-by-u/gallery.php?bottle=" +bottleID;
			//<a href="та_самая_ссылка">Моя бутылка Малибу</a>
			Alert.show("Текст для вставки в блог: <a href=\"" + bottleLink + "\">Моя бутылка Малибу</a>");	 
			
		}
		
		
		private function set added( value : Boolean ) : void {
			
			var w : AddToGalleryWindow = _addToGalleryWindow;
			
			var group1 : Array = [
				w.shareText,
				w.faceBookLink,
				w.twitterLink,
				w.blogLink,
				w.thankText,
				w.simpleBack
			]
			
			var group2 : Array = [
				w.saveButton,
				w.nameRect,
				w.secondNameRect,
				w.ageRect,
				w.emailRect,
				w.phoneRect,
				w.addressRect,
				w.commentRect,
				w.checkBoxLabel,
				name,
				secondName,
				age,
				email,
				phone,
				address,
				comment,
				alert,
				w.check,
				w.checkFrame,
				w.agreeCheck,
				w.agreeCheckFrame,
				w.agreeLabel
			]
			
			var obj : DisplayObject;
			
			for each( obj in group1 ) {
				obj.visible = value;
			}
				
			for each( obj in group2 ) {
				obj.visible = ! value;
			}
		}
		
		private function checkFields () : Boolean
		{
			 if (name.text.length &&  secondName.text.length &&  age.text.length && email.text.length &&  phone.text.length && address.text.length &&  comment.text.length) 
			 {
			 	alert.text = "";
			 	return true;
			 }
			 else
			 {
				 var s : String = "";
				if (!name.text.length )	s += "\n Имя";
				if (!secondName.text.length) s += "\n Фамилия";
				if (!age.text.length) s += "\n Возраст";
				if (!email.text.length) s += "\n Е-мэйл";
				if (!phone.text.length)	s += "\n Телефон";
				if (!comment.text.length) s += "\n Комментарий";
				if (!address.text.length) s += "\n Адрес";
					
				 Alert.show('Пожалуйста, заполните все обязательные поля!' + s + '\n ');
			 	//alert.text = 'Пожалуйста, заполните все обязательные поля!';
			 	return false;
			 }
		}
		
		private function onSave(e : *) : void {
			
			if (!agreeCheckBox.checked || !checkFields())
				return;
			
			var encoder : JPEGEncoder = new JPEGEncoder(75);
			var bytes : ByteArray = encoder.encode( history.currentBitmap );
			var b64encoder : Base64Encoder = new Base64Encoder();
			b64encoder.encodeBytes( bytes );
			
			var data : URLVariables = new URLVariables();
			
			data.content = b64encoder.toString();
			data.raw = true;
			
			var request : URLRequest = new URLRequest("bottle/loadImage.php");
			request.method = URLRequestMethod.POST;
			request.data = data;
			
			var loader : URLLoader = new URLLoader();
			loader.load( request );
			
			loader.addEventListener( Event.COMPLETE, function ( e : Event ) : void {
				
				data = new URLVariables();
				
				data.name = name.text;
				data.surname = secondName.text;
				data.age = age.text;
				data.email = email.text;
				data.phone = phone.text;
				data.address = address.text;
				data.comment = comment.text;
				data.isvirtual = true;
				data.wantnews = checkBox.checked;
				
				request = new URLRequest("bottle/post.php" );
				request.method = URLRequestMethod.POST;
				request.data = data;
				
				loader = new URLLoader();
				loader.load( request );
				
				loader.addEventListener( Event.COMPLETE, function( e : Event ) : void {
					var response : Object = JSON.decode( loader.data );
					if( response.error != null ) {
						Alert.show( response.error.text );
					} else
					{
						added = true;
						
						bottleID =  response.id;
					
					}
						
				} );
					
				loader.addEventListener( IOErrorEvent.IO_ERROR, function ( e : IOErrorEvent ) : void {
					Alert.show('Ошибка загрузки изображения');
				} );
			} );
			
			loader.addEventListener( IOErrorEvent.IO_ERROR, function ( e : IOErrorEvent ) : void {
				Alert.show('Ошибка загрузки');
			} );
		}
		
		
			
		private function onClose (e : *) : void
		{
			var virtualPainter : VirtualPainter = FlexGlobals.topLevelApplication as VirtualPainter;
			virtualPainter.showAddToGallery = false;
			added = false;
		}
		private function onAgreeCheckBox (e : *) : void
		{
			_addToGalleryWindow.saveButton.visible = agreeCheckBox.checked;
		}
		
	}
}