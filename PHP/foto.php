<?php

//принимаем переменные от нашего клиентского приложени¤ через метод передачи данных POST

$ID_VK = $_POST['id'];


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
if (!$ID_VK){
    printf("Не переданы все значения");
    exit;
}

//Пробуем записать данные


	
	
	$z="UPDATE item SET gold = gold-10 WHERE id=$ID_VK"; //Замена текущего золота на такое же значение - 10
	
	$q="SELECT gold FROM item where id in ('$ID_VK')";
	$result1 = mysqli_query($link,$z);
	if ($result1){
		$result = mysqli_query($link,$q);
		$row = mysqli_fetch_row($result);
		echo $row[0];
	}
	else {
		echo "Списание не удалось";
	}
    /*$result = mysqli_query($link,$q);
	    while ($row = mysqli_fetch_row($result)) {
                  echo $row[0];
                
		    }
        		
         */  

mysqli_close($link);
?>