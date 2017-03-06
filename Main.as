package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import vk.APIConnection;
	import vk.events.CustomEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.utils.*;


	public class Main extends MovieClip
	{
		public static var _stage:Stage;
		var bar_gold:MovieClip = new bar2();//Иконка рублей
		var bar_ticket:MovieClip = new bar();//Иконка Кинобилетов
		var bar_lvl:MovieClip = new bar3();//Иконка открытых уровней
		var bar_reit:MovieClip = new bar4();//Иконка ейтинга

		var back:MovieClip = new back_ground();//фон
		

		var mainMenuLayer:Sprite = new Sprite();//основной слой главного меню
		var friendsLayer:Sprite = new Sprite();//слой с иконками друзей
		var strelkiLayer:Sprite = new Sprite();//слой для стрелок перемотки друзей
		var gameLayer:Sprite = new Sprite();//слой для игры
		var lvl_layer:Sprite = new Sprite();//Слой для уровней
		var flashVars:Object;
		public static var VK:APIConnection;//Объекты ВК 
		var _Name:String;//переменная с именем пользователя
		var _Family:String;//переменная с фамилией пользователя
		var _foto:String;//переменная с адресом к фото пользователя
		var _id = 0;//переменная с ВК id пользователя
		var drugArr:Array = new Array();//массив с айдишниками друзей
		var drugObjectArr:Array = new Array();//массив со ссылками на объекты друзей
		var ResultArr:Array = new Array();//Массив с накоплениями
		var lvl_Arr:Array = new Array();//Массив иконок уровней

		var _step = 120;// ширина на которую будет двигаться лента друзей
		var kol_drug = 0;//количество друзей для ограничения передвижения ленты друзей
		var tek_pol = 0;//текущее положение полосы прокрутки друзей
		
		var _strelka_vpravo;
		var _strelka_vlevo;
		var inf = new info_bro();
		var inf_window = new information();
		var game_work:Boolean = true;
		
		var _txt = new tete();
		//игровые переменные
		//static var lvl_Array1:Array = new Array("0","100","250","450","700","1350","1850","2300");
		var lvl_player:uint;
		var tek_target;
		var kartinka:MovieClip;
		var voprisik:MovieClip;
		var otvetik1;
		var otvetik2;
		var otvetik3;
		var otvetik4;
		var foto_btn:SimpleButton;
		var uroven;
		var vopros = 1;
		var _time:MovieClip;
		var _tmax = 20; //Время на вопрос
		var _t = _tmax;
		var _i = 30;
		var intervalId:uint;
		
		var mainArr:Array = new Array(); //Массив с вопросами и ответами
		var otvetArr:Array = new Array(); //Массив с выбранными ответами
		
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, mainInit);
		}
		private function mainInit(e:Event)
		{
			_stage = this.stage;
			flashVars = stage.loaderInfo.parameters as Object;

			VK = new APIConnection(flashVars);
			
			soz_arr();
			





			addChild(back);// добавление фона
			addChild(gameLayer); //слой уровней
			addChild(mainMenuLayer);// добавление главного меню
			addChild(friendsLayer);// добавление слоя с друзьями
			addChild(strelkiLayer);//добавление слоя для стрелок перемотки друзей
			addChild(inf);// добавление слоя с окошком информации о друге
			
			
			inf.visible = false;
			friendsLayer.visible = true;
			stage.addEventListener(MouseEvent.MOUSE_OVER, info_over);
			stage.addEventListener(MouseEvent.MOUSE_OUT, info_out);
			stage.addEventListener(MouseEvent.CLICK, start_lvl);
			stage.addEventListener(Event.ENTER_FRAME, Enter_frame_fc);

			createMainMenu();
			vk_ids();
			vk_friends();
			

			this.removeEventListener(Event.ADDED_TO_STAGE, mainInit);
		}
		function Enter_frame_fc(e:Event){
			if (kartinka.currentFrame == 17 || kartinka.currentFrame == 33){
				kartinka.gotoAndStop(1);
			}
		}
		function timer_fc(){
			if (game_work == true){
				_t--;
			_time.TF.text = (_t);
			if(_t == 0){
				vibor();
			    _t = _tmax;
			}
			}
			
			
		}
		function start_lvl(e:MouseEvent){
			if (e.target as levv && e.target.currentFrame == 2 && vopros == 1 && game_work == true){
				hideMainMenu();
				
				_t = _tmax;
				intervalId = setInterval(timer_fc, 1000);
					_time = new Time();
					_time.x = 900;
				    _time.y = 100;
				    _time.scaleX = 3;
				    _time.scaleY = 3;
				    gameLayer.addChild(_time);
				
				
				
				_time.TF.text = (_t);
				
				
				
				foto_btn = new fot();
				foto_btn.x = 100;
				foto_btn.y = 130;
				gameLayer.addChild(foto_btn);
				
				kartinka = new kadr();
				kartinka.gotoAndStop(1);
				kartinka.x = 500;
				kartinka.y = kartinka.height/2;
				gameLayer.addChild(kartinka);
				uroven = e.target.TF.text;
				
				voprosik = new vopros1();
				voprosik.x = 500;
				voprosik.y = kartinka.height + voprosik.height/2 +2;
				gameLayer.addChild(voprosik);
				voprosik.tft.text = (mainArr[uroven+"_"+vopros][0]);
				
				otvetik1 = new otvet();
				otvetik1.x = 250;
				otvetik1.y = kartinka.height + voprosik.height + otvetik1.height/2+4;
				gameLayer.addChild(otvetik1);
				otvetik1.TF1.mouseEnabled = false;
				otvetik1.TF1.text = (mainArr[uroven+"_"+vopros][1]);
				
				otvetik2 = new otvet();
				otvetik2.x = 750;
				otvetik2.y = kartinka.height + voprosik.height + otvetik2.height/2+4;
				gameLayer.addChild(otvetik2);
				otvetik2.TF1.mouseEnabled = false;
				otvetik2.TF1.text = (mainArr[uroven+"_"+vopros][2]);
				
				otvetik3 = new otvet();
				otvetik3.x = 250;
				otvetik3.y = kartinka.height + voprosik.height + otvetik3.height + otvetik3.height/2+7;
				gameLayer.addChild(otvetik3);
				otvetik3.TF1.mouseEnabled = false;
				otvetik3.TF1.text = (mainArr[uroven+"_"+vopros][3]);
				
				otvetik4 = new otvet();
				otvetik4.x = 750;
				otvetik4.y = kartinka.height + voprosik.height + otvetik4.height + otvetik4.height/2+7;
				gameLayer.addChild(otvetik4);
				otvetik4.TF1.mouseEnabled = false;
				otvetik4.TF1.text = (mainArr[uroven+"_"+vopros][4]);
			}
			if (e.target as levv && e.target.currentFrame == 2 && vopros !== 1 && game_work == true){
				vopros = 1;
				uroven = e.target.TF.text;
				hideMainMenu();
				gameLayer.visible = true;
				voprosik.tft.text = (mainArr[uroven+"_"+vopros][0]);
				otvetik1.TF1.text = (mainArr[uroven+"_"+vopros][1]);
				otvetik2.TF1.text = (mainArr[uroven+"_"+vopros][2]);
				otvetik3.TF1.text = (mainArr[uroven+"_"+vopros][3]);
				otvetik4.TF1.text = (mainArr[uroven+"_"+vopros][4]);
				_t = _tmax;
				intervalId = setInterval(timer_fc, 1000);
				_time.TF.text = (_t);
			}
			if (e.target as otvet && game_work == true){
				 
				 _t = _tmax;
				 _time.TF.text = (_t);
				 zapros_otvet(_id, uroven, vopros, e.target.TF1.text, zapros_otvet_fc , zapros_otvet_fc_e);
				 vopros++;
				 
				 if (vopros > 5 && game_work == true){
					 proverka_lvl();
					 //отправка результатов ответов на сервер для подсчёта рейтинга и получения результатов
					     if (foto_btn.visible == false){
						 foto_btn.visible = true;
						 }
					     gameLayer.removeChild(kartinka);
						 kartinka = new kadr();
				         kartinka.gotoAndStop(1);
				         kartinka.x = 500;
				         kartinka.y = kartinka.height/2;
				         gameLayer.addChild(kartinka);
						 
					 showMainMenu();					 
					 gameLayer.visible = false;
					 clearInterval(intervalId);
				 }
				 if (vopros <= 5 && game_work == true){
				     if (foto_btn.visible == false){
						 foto_btn.visible = true;
						 
						 gameLayer.removeChild(kartinka);
						 kartinka = new kadr();
				         kartinka.gotoAndStop(1);
				         kartinka.x = 500;
				         kartinka.y = kartinka.height/2;
				         gameLayer.addChild(kartinka);
					 }
				 voprosik.tft.text = (mainArr[uroven+"_"+vopros][0]);
				 otvetik1.TF1.text = (mainArr[uroven+"_"+vopros][1]);
				 otvetik2.TF1.text = (mainArr[uroven+"_"+vopros][2]);
				 otvetik3.TF1.text = (mainArr[uroven+"_"+vopros][3]);
				 otvetik4.TF1.text = (mainArr[uroven+"_"+vopros][4]);
				 }
				 
			}
			if (e.target as drug_new && game_work == true){
				VK.callMethod("showInviteBox");
			}
			if (e.target as fot && bar_gold.TF.text >= 10 && game_work == true){
				foto_btn.visible = false;
				foto_zapros(_id, foto_fc, foto_fc_e);
			}
		}
		function vibor(){
			
				 _time.TF.text = (_t);
				 //неправильный ответ отправить на сервер
				 zapros_otvet(_id, uroven, vopros, "Нет ответа", zapros_otvet_fc , zapros_otvet_fc_e);
				 vopros++;
				 
				 if (vopros > 5){
					 //отправка результатов ответов на сервер для подсчёта рейтинга и получения результатов
					     if (foto_btn.visible == false && game_work == true){
						 foto_btn.visible = true;
						 }
					     gameLayer.removeChild(kartinka);
						 kartinka = new kadr();
				         kartinka.gotoAndStop(1);
				         kartinka.x = 500;
				         kartinka.y = kartinka.height/2;
				         gameLayer.addChild(kartinka);
						 
					 showMainMenu();					 
					 gameLayer.visible = false;
					 clearInterval(intervalId);
				 }
				 if (vopros <= 5 && game_work == true){
				     if (foto_btn.visible == false){
						 foto_btn.visible = true;
						 
						 gameLayer.removeChild(kartinka);
						 kartinka = new kadr();
				         kartinka.gotoAndStop(1);
				         kartinka.x = 500;
				         kartinka.y = kartinka.height/2;
				         gameLayer.addChild(kartinka);
					 }
				 voprosik.tft.text = (mainArr[uroven+"_"+vopros][0]);
				 otvetik1.TF1.text = (mainArr[uroven+"_"+vopros][1]);
				 otvetik2.TF1.text = (mainArr[uroven+"_"+vopros][2]);
				 otvetik3.TF1.text = (mainArr[uroven+"_"+vopros][3]);
				 otvetik4.TF1.text = (mainArr[uroven+"_"+vopros][4]);
				 }
				 
		
		}
		function initialize(){
			zapros(_id, _Name, _Family, initialize_fc, initialize_fc_e);
		}
		function foto_zagruz(foto){
			pictLdr = new Loader();
			var pictURLReq:URLRequest = new URLRequest(foto);
			pictLdr.load(pictURLReq);
			pictLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
			pictLdr.contentLoaderInfo.addEventListener(Event.ERROR, imgLoaded_e);
		}
		function imgLoaded(e:Event):void
		{
			var LDR = (e.currentTarget);
			LDR.content.x = (-kartinka.width/2) + 30;
			LDR.content.y = (-kartinka.height/2) + 50;
			kartinka.addChild(LDR.content);
			pictLdr.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
			pictLdr.contentLoaderInfo.removeEventListener(Event.ERROR, imgLoaded_e);

		}
		function imgLoaded_e(e:Event){
			//foto(this._foto);
			pictLdr.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
			pictLdr.contentLoaderInfo.removeEventListener(Event.ERROR, imgLoaded_e);
		}
		function zapros_otvet(id_vk:int, lvl:int, nomer:int, otvet:String, COMPLETE:Function , ERROR:Function){ //функция проверки наличия игрока в БД
			vars = new URLVariables;                                                                                                    
			vars['id'] = id_vk;
			vars['lvl'] = lvl;
			vars['nomer'] = nomer;
			vars['otvet'] = otvet;
			
			request = new URLRequest("http://vevsksenon.xyz/kinoman/PHP/otvet.php"); //путь к скрипту проверки правильности ответа и записи рейтинга
			request.method = URLRequestMethod.POST;
			request.data = vars;
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, COMPLETE);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ERROR);
			loader.load(request);
		}
		function zapros_otvet_fc(event:Event){
			if (event.target.data == 0){
				kartinka.gotoAndPlay(18);
			}
			else if (event.target.data == 5){
				kartinka.gotoAndPlay(2);
			}
			  //результат от скрипта проверки игрока
			 //ResultArr = event.target.data.split("-", 4);
			 //update_bar();
			 loader.removeEventListener(Event.COMPLETE, COMPLETE);
			 loader.removeEventListener(IOErrorEvent.IO_ERROR, ERROR);
		}
		function zapros_otvet_fc_e(event:Event){
			mainMenuLayer.addChild(inf_window);
			inf_window.x = 500;
			inf_window.y = 300;
			inf_window.TF.text = ("Ошибка соединения с БД , перезапустите приложение и проверьте наличие Интернета");
			game_work = false;
			loader.removeEventListener(Event.COMPLETE, COMPLETE);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ERROR);
		}
		function zapros(id_vk:int, p_name:String, p_family:String, COMPLETE:Function , ERROR:Function){ //функция проверки наличия игрока в БД
			vars = new URLVariables;                                                                                                    
			vars['id'] = id_vk;
			vars['name'] = p_name;
			vars['family'] = p_family;
			
			request = new URLRequest("http://vevsksenon.xyz/kinoman/PHP/player.php"); //путь к скрипту проверки наличия игрока в БД
			request.method = URLRequestMethod.POST;
			request.data = vars;
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, COMPLETE);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ERROR);
			loader.load(request);
		}
		function initialize_fc(event:Event){
			  //результат от скрипта проверки игрока
			 ResultArr = event.target.data.split("-", 4);
			 update_bar();
			 loader.removeEventListener(Event.COMPLETE, COMPLETE);
			 loader.removeEventListener(IOErrorEvent.IO_ERROR, ERROR);
		}
		function initialize_fc_e(event:Event){
			mainMenuLayer.addChild(inf_window);
			inf_window.x = 500;
			inf_window.y = 300;
			inf_window.TF.text = ("Ошибка соединения с БД , перезапустите приложение и проверьте наличие Интернета");
			game_work = false;
			loader.removeEventListener(Event.COMPLETE, COMPLETE);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ERROR);
		}
		function foto_zapros(id_vk:int, COMPLETE:Function , ERROR:Function){ //функция списания денег с пользователя за открытие фото
			vars = new URLVariables;                                                                                                    
			vars['id'] = id_vk;
			
			request = new URLRequest("http://vevsksenon.xyz/kinoman/PHP/foto.php"); //путь к скрипту списания денег с пользователя за открытие фото
			request.method = URLRequestMethod.POST;
			request.data = vars;
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, COMPLETE);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ERROR);
			loader.load(request);
		}
		function foto_fc(event:Event){
			 if (event.target.data == "Списание не удалось"){
				mainMenuLayer.addChild(inf_window);
			    inf_window.x = 500;
			    inf_window.y = 300;
			    inf_window.TF.text = ("Ошибка при работе с БД, перезапустите приложение и проверьте наличие Интернета");
				game_work = false;
			 }
			 else {
				 bar_gold.TF.text = event.target.data;
				 foto_zagruz(mainArr[uroven+"_"+vopros][5]);
			 }
			 loader.removeEventListener(Event.COMPLETE, COMPLETE);
			 loader.removeEventListener(IOErrorEvent.IO_ERROR, ERROR);
		}
		function foto_fc_e(event:Event){
			mainMenuLayer.addChild(inf_window);
			inf_window.x = 500;
			inf_window.y = 300;
			inf_window.TF.text = ("Ошибка соединения с БД , перезапустите приложение и проверьте наличие Интернета");
			game_work = false;
			loader.removeEventListener(Event.COMPLETE, COMPLETE);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ERROR);
		}
		function update_bar(){
			bar_gold.TF.text = ResultArr[0];
		    bar_ticket.TF.text = ResultArr[1];
			bar_lvl.TFL.text = ResultArr[2];
			lvl_player = ResultArr[2];
			bar_reit.TF.text = ResultArr[3];
			sozdanie_lvl();
		}
		function info_over(e:MouseEvent)
		{
			if (e.target as drug && e.target.fc_id() !== null && game_work == true)
			{
					inf.TF.text = e.target.fc_in();
				    inf.visible = true;
				    inf.x = e.target.x + (e.target.width/2-10) - (e.target.width*tek_pol);
				    inf.y = e.target.y - (e.target.width/2-1);
				    inf.alpha = 0.9;
				
			}
			if (e.target as drug_new && game_work == true){
				inf.TF.text = "Пригласить друзей" + "\n"+ "\n" + "Чем больше тем лучше =)";
				inf.visible = true;
				inf.x = e.target.x + (e.target.width/2-10) - (e.target.width*tek_pol);
				inf.y = e.target.y - (e.target.width/2-1);
				inf.alpha = 0.9;
			}
			if (e.target as levv && game_work == true){
				e.target.scaleX = 1.5;
				e.target.scaleY = 1.5;
			}
			if (e.target as fot && game_work == true){
				inf.TF.text = "Показать фото" + "\n"+ "за 10 монет"  + "\n" + "На некоторые вопросы не ответить без фотографии";
				inf.visible = true;
				inf.x = e.target.x;
				inf.y = e.target.y + 100;
				inf.alpha = 0.9;
			}
			if (e.target as bar && game_work == true){
				inf.TF.text = "-> Кинобилеты <-" + "\n"+ "За них можно навсегда разблокировать любой уровень";
				inf.visible = true;
				inf.x = e.target.x;
				inf.y = e.target.y + 83;
				inf.alpha = 0.9;
			}
			if (e.target as bar2 && game_work == true){
				inf.TF.text = "-> Золото <-" + "\n"+ "Снимается каждый раз когда вы отвечаете на вопросы";
				inf.visible = true;
				inf.x = e.target.x;
				inf.y = e.target.y + 83;
				inf.alpha = 0.9;
			}
			if (e.target as bar3 && game_work == true){
				inf.TF.text = "-> Открытые уровни <-" + "\n"+ "Количество разблокированых уровней";
				inf.visible = true;
				inf.x = e.target.x;
				inf.y = e.target.y + 83;
				inf.alpha = 0.9;
			}
			if (e.target as bar4 && game_work == true){
				inf.TF.text = "-> Рейтинг <-" + "\n"+ "Чем больше правильных ответов тем больше рейтинг";
				inf.visible = true;
				inf.x = e.target.x;
				inf.y = e.target.y + 77;
				inf.alpha = 0.9;
			}

		}
		function info_out(e:MouseEvent)
		{
			if (e.target as levv && game_work == true){
				e.target.scaleX = 1;
				e.target.scaleY = 1;
				
			}
			inf.visible = false;
		}
		
		function createMainMenu()
		{


			mainMenuLayer.addChild(bar_gold);
			mainMenuLayer.addChild(bar_ticket);
			mainMenuLayer.addChild(bar_reit);
			mainMenuLayer.addChild(bar_lvl);
			mainMenuLayer.addChild(_txt);
			mainMenuLayer.addChild(lvl_layer);
			
			_txt.x = 400;
			_txt.y = 400;
			_txt.visible = false;


			back.x = stage.stageWidth / 2;
			back.y = stage.stageHeight / 2;
			back.alpha = 0.7;
			back.scaleX = 0.45;
			back.scaleY = 0.45;


			bar_gold.x = 110;
			bar_gold.y = 50;
			bar_gold.TF.mouseEnabled = false;
			bar_ticket.x = 350;
			bar_ticket.y = 50;
			bar_ticket.TF.mouseEnabled = false;
			bar_lvl.x = 660;
			bar_lvl.y = 50;
			bar_lvl.TFL.mouseEnabled = false;
			bar_reit.x = 800;
            bar_reit.y = 50;
			bar_reit.TF.mouseEnabled = false;
		}
		function sozdanie_lvl(){
			    var j = 0;
				var q = 0;
			for (var i = 1; i <= 20 ; i++){
				
				var level = new levv();
				lvl_Arr.push(level);
				lvl_Arr[i-1].id = i;
				if (lvl_player >= i){
					lvl_Arr[i-1].gotoAndStop(2);
					lvl_Arr[i-1].TF.mouseEnabled = false;
				}
				if (lvl_player < i){
					lvl_Arr[i-1].gotoAndStop(1);
					lvl_Arr[i-1].TF.mouseEnabled = false;
				}
				
				lvl_layer.addChild(lvl_Arr[i-1]);
				lvl_Arr[i-1].x = 100 + (150*q);
				lvl_Arr[i-1].y = 160 + (87*j);
				lvl_Arr[i-1].TF.text = i;
				q++;
				if (i%5 == 0 && i !==0){
					j++;
					q=0;
				}
			}
		}
		function proverka_lvl(){
			for (var i = 1; i <= lvl_player; i++){
				lvl_Arr[i-1].gotoAndStop(2);
				lvl_Arr[i-1].TF.mouseEnabled = false;
				lvl_Arr[i-1].TF.text = lvl_Arr[i-1].id;
			}
		}
		function sozdanie_okon_druzey()
		{

			for (var i = 0; i < drugObjectArr.length; i++)
			{
				friendsLayer.addChild(drugObjectArr[i]);
				drugObjectArr[i].x = ((drugObjectArr[i].width/2)-30) + (drugObjectArr[i].width * i);
				drugObjectArr[i].y = 490;
				_step = drugObjectArr[i].width;
				if (i == drugObjectArr.length){
					friendsLayer.visible = true;
				}
			}
			do {
				if (u == undefined){
					var u = drugObjectArr.length;
				}
                var dobav = new drug_new();
				friendsLayer.addChild(dobav);
				kol_drug++;
				dobav.x = ((dobav.width/2)-30) + (dobav.width * u);
				dobav.y = 490;
				u++;
            } while (u < 8);
			sozdanie_strelki();
		}
		function sozdanie_strelki()
		{
			_strelka_vpravo = new strelka();
			strelkiLayer.addChild(_strelka_vpravo);
			_strelka_vpravo.x = 990;
			_strelka_vpravo.y = 540;

			_strelka_vlevo = new strelka();
			strelkiLayer.addChild(_strelka_vlevo);
			_strelka_vlevo.x = 10;
			_strelka_vlevo.y = 540;
			_strelka_vlevo.scaleX = -1;
			_strelka_vlevo.addEventListener(MouseEvent.CLICK, peremotka_druzey_levo);
			_strelka_vpravo.addEventListener(MouseEvent.CLICK, peremotka_druzey_pravo);
		}
		function peremotka_druzey_levo(e:MouseEvent)
		{
			if (tek_pol > 0)
			{
				friendsLayer.x +=  _step;
				tek_pol -=  1;
			}
		}
		function peremotka_druzey_pravo(e:MouseEvent)
		{
			var X = kol_drug - tek_pol;
			if (X > 8)
			{
				friendsLayer.x -= _step;
				tek_pol +=  1;
			}
		}

		
		function updateMainMenu()
		{

		}
		function hideMainMenu()
		{
			    
				
			   
			    bar_ticket.visible = false;
			    bar_reit.visible = false;
			    bar_lvl.visible = false;
			    lvl_layer.visible = false;
				friendsLayer.visible = false;
				strelkiLayer.visible = false;
				inf.visible = false;
				bar_gold.visible = true;
		}
		function showMainMenu()
		{
			    bar_ticket.visible = true;
			    bar_reit.visible = true;
			    bar_lvl.visible = true;
			    lvl_layer.visible = true;
				friendsLayer.visible = true;
				strelkiLayer.visible = true;
				inf.visible = true;
		}
		function vk_ids()
		{
			VK.api('users.get', {
			   user_ids:flashVars['viewer_id'],
			   fields: 'photo_100,sex'
			   }, compFC, errFC);
		}
		function vk_friends()
		{
			VK.api('friends.getAppUsers', {},  compFC_fr, errFC_fr);
		}
		function compFC(data:Object)
		{
			    _Name = data[0]["first_name"];
				_Family = data[0]["last_name"];
				_foto = data[0]["photo_100"];
				_id = data[0]["uid"];
				initialize();
		}
		function errFC(data:Object)
		{
			mainMenuLayer.addChild(inf_window);
			inf_window.x = 500;
			inf_window.y = 300;
			inf_window.TF.text = ('Ошибка ВК - перезапустите приложение и проверьте наличие Интернета');
			game_work = false;
			
		}
		function compFC_fr(data:Object)
		{
			var index = 0;
			kol_drug = data.length;
			while (index < data.length)
			{
				var _drug = new drug();
				_drug.id = data[index];
				drugObjectArr.push(_drug);
				index++;
				drugObjectArr[index-1].nomer = index;
				if (index == data.length){
					sozdanie_okon_druzey();
				}
			}

		}
		function errFC_fr(data:Object)
		{
			mainMenuLayer.addChild(inf_window);
			inf_window.x = 500;
			inf_window.y = 300;
			inf_window.TF.text = ('Ошибка ВК - перезапустите приложение и проверьте наличие Интернета');
			game_work = false;
		}
		function soz_arr(){
mainArr["1_1"] = ["Герои какого фильма на фото?", "Друзья", "Форсаж", "Большая разборка", "Теория большого взрыва", "http://vevsksenon.xyz/kinoman/foto_kinoman/1_1.jpg"]; //Форсаж
mainArr["1_2"] = ["Кадр со съемок какого фильма?", "Клоун", "Монстр", "Оно", "Атракцион", "http://vevsksenon.xyz/kinoman/foto_kinoman/1_2.jpg"]; //Оно
mainArr["1_3"] = ["Кто ходил под гримом в фильме \"Маска\"?", "Марлон Брандо", "Джим Керри", "Вэл Килмер", "Джаред Батлер", "http://vevsksenon.xyz/kinoman/foto_kinoman/1_3.jpg"]; //Джим Керри
mainArr["1_4"] = ["Актерский состав какого фильма?", "Пятый элемент", "Убить Билла", "Криминальное Чтиво", "Без Лица", "http://vevsksenon.xyz/kinoman/foto_kinoman/1_4.jpg"]; //Криминальное Чтиво
mainArr["1_5"] = ["Этого актера в фильме \"Мстители Эра Альтрона\" мы не увидели но слышали его голос. Кто это?", "Крис Хемсворт", "Элизабет Олсен", "Аарон Тейлор-Джонсон", "Джеймс Спейдер", "http://vevsksenon.xyz/kinoman/foto_kinoman/1_5.jpg"]; //Джеймс Спейдер
mainArr["2_1"] = ["На какой планете были наедены яйца с лицехватами из фильма \"Чужой\"?", "RBD-204", "Юпитер", "LV-426", "Пандора", "http://vevsksenon.xyz/kinoman/foto_kinoman/2_1.jpg"]; //LV-426
mainArr["2_2"] = ["Кем являлся Ле Шиффр в фильме \"казино рояль\"?", "Ученым в области физики", "человек с паранормальными способностями", "тайный банкир", "маньяк террорист", "http://vevsksenon.xyz/kinoman/foto_kinoman/2_2.jpg"]; //тайный банкир
mainArr["2_3"] = ["В каком году вышел фильм \"Люди икс\"?", "1998", "2001", "1999", "2000", "http://vevsksenon.xyz/kinoman/foto_kinoman/2_3.jpg"]; //2000
mainArr["2_4"] = ["какой фильм на кадре?", "Бессоница", "В пути", "Жизнь Дэвида Гейла", "Священный дым", "http://vevsksenon.xyz/kinoman/foto_kinoman/2_4.jpg"]; //Жизнь Дэвида Гейла
mainArr["2_5"] = ["Назовите режиссера фильма \"Семь\"?", "Дэвид Кроненберг", "Рон Ховард", "Дэвид Финчер", "Пол Хоган", "http://vevsksenon.xyz/kinoman/foto_kinoman/2_5.jpg"]; //Дэвид Финчер
mainArr["3_1"] = ["В каком году прибыл \"терминатор\" убить Сару Коннор?", "1978", "1988", "1981", "1984", "http://vevsksenon.xyz/kinoman/foto_kinoman/3_1.jpg"]; //1984
mainArr["3_2"] = ["В каком городе вырос \"Брюс Уэйн\"?", "Метрополис", "Сан-Франциско", "Чикаго", "Готэм", "http://vevsksenon.xyz/kinoman/foto_kinoman/3_2.jpg"]; //Готэм
mainArr["3_3"] = ["Кому принадлежит фраза-\"Ладно, беру тебя. Тебя не возьму — ты страшный\"?", "Джокер", "Грю", "Капитан Джек-Воробей", "Лейтенант Харрис", "http://vevsksenon.xyz/kinoman/foto_kinoman/3_3.jpg"]; //Капитан Джек-Воробей
mainArr["3_4"] = ["Кого первоначально приглашали на роль \"хищника\"?", "Вэл Килмер", "Игги Поп", "Жан-Клод Ван Дамм", "Халк Хоган", "http://vevsksenon.xyz/kinoman/foto_kinoman/3_4.jpg"]; //Жан-Клод Ван Дамм
mainArr["3_5"] = ["Первое появление \"Киану Ривза\" на большом экране?", "Отпуская", "Молодая кровь", "На берегу реки", "Дракула", "http://vevsksenon.xyz/kinoman/foto_kinoman/3_5.jpg"]; //Молодая кровь
mainArr["4_1"] = ["Как звали главного антагониста в фильме \"Кобра\"?", "Филип Моррис", "Стив Фишер", "Майкл Майерс", "Найт Слэшер", "http://vevsksenon.xyz/kinoman/foto_kinoman/4_1.jpg"]; //Найт Слэшер
mainArr["4_2"] = ["Какой \"киноманьяк\" убивал людей во снах?", "Леприкон", "Леший", "Реаниматор", "Фрэди Крюгер", "http://vevsksenon.xyz/kinoman/foto_kinoman/4_2.jpg"]; //Фрэди Крюгер
mainArr["4_3"] = ["Какой фильм \"Роберта Земекиса\" вышел в 1997 году?", "Форест Гамп", "Контакт", "Изгой", "Что скрывает ложь", "http://vevsksenon.xyz/kinoman/foto_kinoman/4_3.jpg"]; //Контакт
mainArr["4_4"] = ["Как называлось вирусное оружие в фильме \"Скала\"?", "СОСl2", "13FF", "Ebolavirus", "VX", "http://vevsksenon.xyz/kinoman/foto_kinoman/4_4.jpg"]; //VX
mainArr["4_5"] = ["В каком году был создан \"Оскар\" для поощрения деятелей кино?", "1929", "1920", "1910", "1940", "http://vevsksenon.xyz/kinoman/foto_kinoman/4_5.jpg"]; //1929
mainArr["5_1"] = ["Как назывался остров на котором жил \"Кинг-Конг\"?", "Остров Немезиды", "Остров Пиратов", "Остров Ацтеков", "Остров Черепа", "http://vevsksenon.xyz/kinoman/foto_kinoman/5_1.jpg"]; //Остров Черепа
mainArr["5_2"] = ["Сколько Фильм \"Форрест Гамп\" получил наград Оскар?", "2", "4", "8", "6", "http://vevsksenon.xyz/kinoman/foto_kinoman/5_2.jpg"]; //6
mainArr["5_3"] = ["Фильм \"обитель зла\" является киноадаптацией?", "Игры", "Комикса", "Серии рассказов", "Мифов", "http://vevsksenon.xyz/kinoman/foto_kinoman/5_3.jpg"]; //Игры
mainArr["5_4"] = ["В каком фильме \"Дрю Бэрримор\" снялась только в начале фильме?", "Инопланетянин", "Кошачий глаз", "Доппельгангер", "Крик", "http://vevsksenon.xyz/kinoman/foto_kinoman/5_4.jpg"]; //Крик
mainArr["5_5"] = ["Как звали дружелюбного мышонка в фильме \"Зеленая миля\"?", "Мистер Мышь", "Мистер Пениворт", "Месье Дюк", "Мистер Джинглс", "http://vevsksenon.xyz/kinoman/foto_kinoman/5_5.jpg"]; //Мистер Джинглс
mainArr["6_1"] = ["Какое имя было у искусственного интеллекта созданный \"Тони Старком\"?", "Винсент-10", "Робо-манус", "Освальд", "Джарвис", "http://vevsksenon.xyz/kinoman/foto_kinoman/6_1.jpg"]; //Джарвис
mainArr["6_2"] = ["Кого \"Локи\" отправляет на землю помешать Тору заново получить силу над Мьёльнером?", "Киборга-убйицу", "Брата Таноса", "Генерала Асгарда", "Разрушителя", "http://vevsksenon.xyz/kinoman/foto_kinoman/6_2.jpg"]; //Разрушителя
mainArr["6_3"] = ["Кто в фильме людей икс мог забрать жизненную силу и способности через прикосновение?", "Шторм", "Магнето", "Мистик", "Роуг", "http://vevsksenon.xyz/kinoman/foto_kinoman/6_3.jpg"]; //Роуг
mainArr["6_4"] = ["Как звали героя в фильме \"Ворон\"?", "Адам Драйвер", "Фрост Драйк", "Эрик Дрейвен", "Кори Декирс", "http://vevsksenon.xyz/kinoman/foto_kinoman/6_4.jpg"]; //Эрик Дрейвен
mainArr["6_5"] = ["Какой слоган использовался для фильма \"Матрица\"?", "Ты увидишь мир наизнанку", "Изменишь одно, изменится всё", "Ты готов сыграть?", "Добро пожаловать в реальный мир", "http://vevsksenon.xyz/kinoman/foto_kinoman/6_5.jpg"]; //Добро пожаловать в реальный мир
mainArr["7_1"] = ["Актерский состав какого фильма на фото?", "Секреты Лос-Анджелеса", "Неприкосаемые", "Славные парни", "Детективы", "http://vevsksenon.xyz/kinoman/foto_kinoman/7_1.jpg"]; //Секреты Лос-Анджелеса
mainArr["7_2"] = ["Какой псевдоним был у актера Стива Бушеми в фильме \"Бешеные псы\"?", "Мистер белый", "Мистер розовый", "Мистер голубой", "Мистер черный", "http://vevsksenon.xyz/kinoman/foto_kinoman/7_2.jpg"]; //Мистер розовый
mainArr["7_3"] = ["Съемки какого фильма на фотографии?", "Схватка", "Крестный отец", "Путь Карлито", "Казино", "http://vevsksenon.xyz/kinoman/foto_kinoman/7_3.jpg"]; //Схватка
mainArr["7_4"] = ["Кто является режиссером фильма \"Престиж\"?", "Роберт Земекис", "Стивен Спилберг", "Кэтрин Бигелоу", "Кристофер Нолан", "http://vevsksenon.xyz/kinoman/foto_kinoman/7_4.jpg"]; //Кристофер Нолан
mainArr["7_5"] = ["В каком городе происходит действие фильма \"Робокоп\"?", "Беверли хиллз", "Нью-Джерси", "Лас Вегас", "Детройт", "http://vevsksenon.xyz/kinoman/foto_kinoman/7_5.jpg"]; //Детройт
mainArr["8_1"] = ["Дай мне лук, я выпущу стрелу, и ты меня похоронишь в том месте, куда упадет стрела!из какого фильма эта фраза?", "Робин Гуд: Принц воров", "Львиное сердце", "Во имя короля", "Робин и Мэриан", "http://vevsksenon.xyz/kinoman/foto_kinoman/8_1.jpg"]; //Робин и Мэриан
mainArr["8_2"] = ["Рядом с Ридли Скоттом стоит создатель \"Чужого\",как его зовут?", "Стэн Уинстон", "Рик Картер", "Ханс Гигер", "Патрис Верметт", "http://vevsksenon.xyz/kinoman/foto_kinoman/8_2.jpg"]; //Ханс Гигер
mainArr["8_3"] = ["По  мотивам романа какого автора был снят фильм \"Война миров\" 2005 года?", "Дэн Симмонс", "Герберт Уэллс", "Фрэнк Герберт", "Терри Пратчетт", "http://vevsksenon.xyz/kinoman/foto_kinoman/8_3.jpg"]; //Герберт Уэллс
mainArr["8_4"] = ["Какой фильм получил оскар, как лучший фильм 2004 года?", "Авиатор", "На обочине", "Рэй", "Малышка на миллион", "http://vevsksenon.xyz/kinoman/foto_kinoman/8_4.jpg"]; //Малышка на миллион
mainArr["8_5"] = ["Актерский состав какого фильма на фото?", "Отчаянный", "Мексиканец", "Гангстеры", "Интервью с вампиром", "http://vevsksenon.xyz/kinoman/foto_kinoman/8_5.jpg"]; //Интервью с вампиром
mainArr["9_1"] = ["Как называлось здание корпорации,где \"Джон МакКлейн\" спасал заложников?", "Башня Хёрста", "Башня Жемчужной реки", "Накатоми Плаза", "Небоскрёб Бурдж-Халифа", "http://vevsksenon.xyz/kinoman/foto_kinoman/9_1.jpg"]; //Накатоми Плаза
mainArr["9_2"] = ["Кем является Дрисс аристократу Филлипу в фильме \"1+1\"?", "Помощник-сиделка", "Брат", "Сват", "Сын", "http://vevsksenon.xyz/kinoman/foto_kinoman/9_2.jpg"]; //Помощник-сиделка
mainArr["9_3"] = ["\"Очень страшное кино часть 1\" является основной пародией какого фильма?", "Крик", "Хэллоуин", "Дом восковых фигур", "Факультет", "http://vevsksenon.xyz/kinoman/foto_kinoman/9_3.jpg"]; //Крик
mainArr["9_4"] = ["В каком году вышел первый фильм про \"Годзиллу\"?", "1951", "1960", "1972", "1954", "http://vevsksenon.xyz/kinoman/foto_kinoman/9_4.jpg"]; //1954
mainArr["9_5"] = ["Как назывался последний уровень сна в фильме \"Начало\"?", "Пятый", "Кратер", "Гробница", "Лимб", "http://vevsksenon.xyz/kinoman/foto_kinoman/9_5.jpg"]; //Лимб
		}
		
	}

}