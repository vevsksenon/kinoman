package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Sprite;
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
		var flashVars:Object;
		public static var VK:APIConnection;//Объекты ВК 
		var _Name:String;//переменная с именем пользователя
		var _Family:String;//переменная с фамилией пользователя
		var _foto:String;//переменная с адресом к фото пользователя
		var _id = 0;//переменная с ВК id пользователя
		var drugArr:Array = new Array();//массив с айдишниками друзей
		var drugObjectArr:Array = new Array();//массив со ссылками на объекты друзей
		var ResultArr:Array = new Array();//Массив с накоплениями

		var _step = 120;// ширина на которую будет двигаться лента друзей
		var kol_drug = 0;//количество друзей для ограничения передвижения ленты друзей
		var tek_pol = 0;//текущее положение полосы прокрутки друзей
		
		var _strelka_vpravo;
		var _strelka_vlevo;
		var inf = new info_bro();
		var inf_window = new information();
		
		var _txt = new tete();
		//игровые переменные
		static var lvl_Array:Array = new Array("0","100","250","450","700","1350","1850","2300");
		var lvl_player:uint;
		var tek_target;
		var kartinka:MovieClip;
		var voprisik:MovieClip;
		var otvetik1;
		var otvetik2;
		var otvetik3;
		var otvetik4;
		var uroven;
		var vopros = 1;
		
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

			createMainMenu();
			vk_ids();
			vk_friends();
			

			this.removeEventListener(Event.ADDED_TO_STAGE, mainInit);
		}
		function start_lvl(e:MouseEvent){
			if (e.target as levv && e.target.currentFrame == 2 && vopros == 1){
				hideMainMenu();
				kartinka = new kadr();
				kartinka.gotoAndStop(1);
				kartinka.x = 500;
				kartinka.y = 210;
				gameLayer.addChild(kartinka);
				uroven = e.target.TF.text;
				
				voprosik = new vopros1();
				voprosik.x = 500;
				voprosik.y = 470;
				gameLayer.addChild(voprosik);
				voprosik.tft.text = (mainArr[uroven+"_"+vopros][0]);
				
				otvetik1 = new otvet();
				otvetik1.x = 250;
				otvetik1.y = 595;
				gameLayer.addChild(otvetik1);
				otvetik1.TF1.mouseEnabled = false;
				otvetik1.TF1.text = (mainArr[uroven+"_"+vopros][1]);
				
				otvetik2 = new otvet();
				otvetik2.x = 750;
				otvetik2.y = 595;
				gameLayer.addChild(otvetik2);
				otvetik2.TF1.mouseEnabled = false;
				otvetik2.TF1.text = (mainArr[uroven+"_"+vopros][2]);
				
				otvetik3 = new otvet();
				otvetik3.x = 250;
				otvetik3.y = 730;
				gameLayer.addChild(otvetik3);
				otvetik3.TF1.mouseEnabled = false;
				otvetik3.TF1.text = (mainArr[uroven+"_"+vopros][3]);
				
				otvetik4 = new otvet();
				otvetik4.x = 750;
				otvetik4.y = 730;
				gameLayer.addChild(otvetik4);
				otvetik4.TF1.mouseEnabled = false;
				otvetik4.TF1.text = (mainArr[uroven+"_"+vopros][4]);
			}
			if (e.target as levv && e.target.currentFrame == 2 && vopros !== 1){
				vopros = 1;
				hideMainMenu();
				gameLayer.visible = true;
				voprosik.tft.text = (mainArr[uroven+"_"+vopros][0]);
				otvetik1.TF1.text = (mainArr[uroven+"_"+vopros][1]);
				otvetik2.TF1.text = (mainArr[uroven+"_"+vopros][2]);
				otvetik3.TF1.text = (mainArr[uroven+"_"+vopros][3]);
				otvetik4.TF1.text = (mainArr[uroven+"_"+vopros][4]);
				
			}
			if (e.target as otvet){
				 
				 otvetArr[vopros] = e.target.TF1.text;
				 vopros++;
				 
				 if (vopros > 5){
					 //отправка результатов ответов на сервер для подсчёта рейтинга и получения результатов
					 showMainMenu();					 
					 gameLayer.visible = false;
				 }
				 if (vopros <= 5){
				 voprosik.tft.text = (mainArr[uroven+"_"+vopros][0]);
				 otvetik1.TF1.text = (mainArr[uroven+"_"+vopros][1]);
				 otvetik2.TF1.text = (mainArr[uroven+"_"+vopros][2]);
				 otvetik3.TF1.text = (mainArr[uroven+"_"+vopros][3]);
				 otvetik4.TF1.text = (mainArr[uroven+"_"+vopros][4]);
				 }
				 
			}
			if (e.target as drug_new){
				VK.callMethod("showInviteBox");
			}
		}
		function initialize(){
			zapros(_id, _Name, _Family, initialize_fc, initialize_fc_e);
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
			inf_window.y = 400;
			inf_window.TF.text = ("Ошибка соединения с БД перезапустите приложение");
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
			if (e.target as drug && e.target.fc_id() !== null)
			{
					inf.TF.text = e.target.fc_in();
				    inf.visible = true;
				    inf.x = e.target.x + (e.target.width/2-10) - (e.target.width*tek_pol);
				    inf.y = e.target.y - (e.target.width/2-1);
				    inf.alpha = 0.9;
				
			}
			if (e.target as drug_new){
				inf.TF.text = "Пригласить друзей" + "\n"+ "\n" + "Чем больше тем лучше =)";
				inf.visible = true;
				inf.x = e.target.x + (e.target.width/2-10) - (e.target.width*tek_pol);
				inf.y = e.target.y - (e.target.width/2-1);
				inf.alpha = 0.9;
			}
			if (e.target as levv){
				e.target.scaleX = 1.5;
				e.target.scaleY = 1.5;
			}
			if (e.target as bar){
				inf.TF.text = "-> Кинобилеты <-" + "\n"+ "За них можно навсегда разблокировать любой уровень";
				inf.visible = true;
				inf.x = e.target.x;
				inf.y = e.target.y + 83;
				inf.alpha = 0.9;
			}
			if (e.target as bar2){
				inf.TF.text = "-> Золото <-" + "\n"+ "Снимается каждый раз когда вы отвечаете на вопросы";
				inf.visible = true;
				inf.x = e.target.x;
				inf.y = e.target.y + 83;
				inf.alpha = 0.9;
			}
			if (e.target as bar3){
				inf.TF.text = "-> Открытые уровни <-" + "\n"+ "Количество разблокированых уровней";
				inf.visible = true;
				inf.x = e.target.x;
				inf.y = e.target.y + 83;
				inf.alpha = 0.9;
			}
			if (e.target as bar4){
				inf.TF.text = "-> Рейтинг <-" + "\n"+ "Чем больше правильных ответов тем больше рейтинг";
				inf.visible = true;
				inf.x = e.target.x;
				inf.y = e.target.y + 77;
				inf.alpha = 0.9;
			}

		}
		function info_out(e:MouseEvent)
		{
			if (e.target as levv){
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
			_txt.x = 400;
			_txt.y = 400;
			_txt.visible = false;


			back.x = stage.stageHeight / 2;
			back.y = stage.stageWidth / 2 - 50;
			back.alpha = 0.6;
			back.scaleX = 0.6;
			back.scaleY = 0.6;


			bar_gold.x = 130;
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
				level.TF.mouseEnabled = false;
				if (lvl_player >= i){
					level.gotoAndStop(2);
					level.TF.mouseEnabled = false;
				}
				if (lvl_player < i){
					level.gotoAndStop(1);
					
				}
				
				mainMenuLayer.addChild(level);
				level.x = 100 + (150*q);
				level.y = 150 + (150*j);
				level.TF.text = i;
				q++;
				if (i%5 == 0 && i !==0){
					j++;
					q=0;
				}
			}
		}
		function sozdanie_okon_druzey()
		{

			for (var i = 0; i < drugObjectArr.length; i++)
			{
				friendsLayer.addChild(drugObjectArr[i]);
				drugObjectArr[i].x = ((drugObjectArr[i].width/2)-30) + (drugObjectArr[i].width * i);
				drugObjectArr[i].y = 690;
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
				dobav.y = 690;
				u++;
            } while (u < 8);
			sozdanie_strelki();
		}
		function sozdanie_strelki()
		{
			_strelka_vpravo = new strelka();
			strelkiLayer.addChild(_strelka_vpravo);
			_strelka_vpravo.x = 990;
			_strelka_vpravo.y = 740;

			_strelka_vlevo = new strelka();
			strelkiLayer.addChild(_strelka_vlevo);
			_strelka_vlevo.x = 10;
			_strelka_vlevo.y = 740;
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
			    mainMenuLayer.visible = false;
				friendsLayer.visible = false;
				strelkiLayer.visible = false;
				inf.visible = false;
		}
		function showMainMenu()
		{
			    mainMenuLayer.visible = true;
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
			inf_window.y = 400;
			inf_window.TF.text = ('Ошибка ВК - перезапустите приложение');
			
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
			inf_window.y = 400;
			inf_window.TF.text = ('Ошибка ВК - перезапустите приложение');
		}
		function soz_arr(){
			mainArr["1_1"] = ["Первый вопрос ?", "Первый ответ на первый вопрос", "Второй ответ на первый вопрос", "Третий ответ на первый вопрос", "Четвёртый ответ на первый вопрос", "Ссылка на фото 1"];
			mainArr["1_2"] = ["Второй вопрос ?", "Первый ответ на второй вопрос", "Второй ответ на второй вопрос", "Третий ответ на второй вопрос", "Четвёртый ответ на второй вопрос", "Ссылка на фото 2"];
			mainArr["1_3"] = ["Тверий вопрос ?", "Первый ответ на третий вопрос", "Второй ответ на третий вопрос", "Третий ответ на третий вопрос", "Четвёртый ответ на третий вопрос", "Ссылка на фото 3"];
			mainArr["1_4"] = ["Четвёртый вопрос ?", "Первый ответ на четвёртый вопрос", "Второй ответ на четвёртый вопрос", "Третий ответ на четвёртый вопрос", "Четвёртый ответ на четвёртый вопрос", "Ссылка на фото 4"];
			mainArr["1_5"] = ["Пятый вопрос ?", "Первый ответ на пятый вопрос", "Второй ответ на пятый вопрос", "Третий ответ на пятый вопрос", "Четвёртый ответ на пятый вопрос", "Ссылка на фото 5"];
		}
		
	}

}