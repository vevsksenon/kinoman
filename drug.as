package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import vk.APIConnection;
	import vk.events.CustomEvent;
	import flash.display.Stage;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.net.URLRequest;
	import flash.utils.*;


	public class drug extends MovieClip
	{

		var id:uint = 0;
		var _Name:String;
		var _Family:String;
		var _foto:String;
		var pictLdr:Loader;
		
		var nomer:uint;

		public function drug()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, add_fc);

		}
		function add_fc(e:Event)
		{
			
			var time = this.nomer * 500;
			var intervalId:uint = setTimeout(vk_ids, time);
			
			
			
			this.removeEventListener(Event.ADDED_TO_STAGE, add_fc);
			

		}
		
		function vk_ids()
		{
			
			
				Main.VK.api('users.get', {
			   user_ids:this.id,
			   fields: 'photo_100'
			   }, compFC, errFC);
			
			
		}
		function compFC(data:Object)
		{
				this._Name = data[0]["first_name"];
				this._Family = data[0]["last_name"];
				this._foto = data[0]["photo_100"];
				this.id = data[0]["uid"];
				foto();
		}
		function errFC(data:Object)
		{
			//vk_ids();
		}
		function fc_in()
		{
			var str:String = this._Name + "\n" + this._Family;
			return str;
		}
		function fc_id()
		{
			return this._foto;
		}
		function foto(){
			pictLdr = new Loader();
			var pictURLReq:URLRequest = new URLRequest(this._foto);
			pictLdr.load(pictURLReq);
			pictLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
			pictLdr.contentLoaderInfo.addEventListener(Event.ERROR, imgLoaded_e);
		}
		function imgLoaded(e:Event):void
		{
			var LDR = (e.currentTarget);
			this.addChild(LDR.content);
			pictLdr.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
			pictLdr.contentLoaderInfo.removeEventListener(Event.ERROR, imgLoaded_e);

		}
		function imgLoaded_e(e:Event){
			//foto(this._foto);
			pictLdr.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
			pictLdr.contentLoaderInfo.removeEventListener(Event.ERROR, imgLoaded_e);
		}

	}

}