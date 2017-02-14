<?php

//принимаем переменные от нашего клиентского приложени¤ через метод передачи данных POST


$ID_VK = $_POST['id'];
$NAME = $_POST['name'];
$FAMILY = $_POST['family'];


//Соединяемся , выбираем базу данных

$db = 'u558902446_kino';
$describe = 'player';

$Host = 'mysql.hostinger.ru';
$Login = 'u558902446_user';
$Password = 'inAvRG70z3R9';

$link = mysqli_connect($Host, $Login, $Password, $db);



//Проверяем успешность соединения

if (!$link){
    printf("Невозможно соединиться с базой данных. Код ошибки: %s\n", mysqli_connect_error());
    exit;
}
if (!$ID_VK && !$NAME && !$FAMILY){
    printf("Не переданы все значения");
    exit;
}

//Пробуем записать данные


	
	$q="SELECT vk_id FROM player where vk_id in ('$ID_VK')";
	$z="insert into player(vk_id,name,Family) values ('$ID_VK', '$NAME', '$FAMILY')"; //Создание нового пользователя
	$zz="insert into item(id,gold,ticket,lvl) values ('$ID_VK', 200, 5, 1)"; //Создание нового начального капитала
	$zzz="insert into reiting(id,lvl,reit) values ('$ID_VK', 0, 0)"; //Создание нулевого рейтинга
	$qq="SELECT gold,ticket,lvl FROM item where id in ('$ID_VK')";
	$rei = "SELECT SUM(reit) FROM `reiting` WHERE id = ('$ID_VK')";
    $result = mysqli_query($link,$q);
	    $numb1 = mysqli_fetch_row($result);
		
	
        if (!$numb1){	
            mysqli_query($link,$z);
			mysqli_query($link,$zz);
			mysqli_query($link,$zzz);
          
			$result1 = mysqli_query($link,$qq);
			$result2 = mysqli_query($link,$rei);
	             while($row = mysqli_fetch_array($result1)){
	        echo ($row['gold']."-");
	        echo ($row['ticket']."-");
	        echo ($row['lvl']."-");
			
                 }
				 while ($rows = mysqli_fetch_row($result2)) {
                  echo ($rows[0]."-");
                  }
		     echo("Этот игрок нуждается в обучении");
	     	}
	    else if($numb1[0] == $ID_VK){
			
			$result1 = mysqli_query($link,$qq);
			$result2 = mysqli_query($link,$rei);
	              while($row = mysqli_fetch_array($result1)){
	        echo ($row['gold']."-");
	        echo ($row['ticket']."-");
	        echo ($row['lvl']."-");
				
			      }
				  while ($rows = mysqli_fetch_row($result2)) {
                  echo ($rows[0]."-");
                  }
				  echo("Этот игрок не нуждается в обучении");
}
mysqli_close($link);
?>