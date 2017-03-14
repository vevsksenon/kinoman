<?php

//принимаем переменные от нашего клиентского приложени¤ через метод передачи данных POST

$ID_VK = $_POST['id'];
$LVLMAX = $_POST['lvlmax'];


//Соединяемся , выбираем базу данных

$db = 'u558902446_kino';


$Host = 'mysql.hostinger.ru';
$Login = 'u558902446_user';
$Password = 'inAvRG70z3R9';

$link = mysqli_connect($Host, $Login, $Password, $db);



//Проверяем успешность соединения

if (!$link){
    printf("Невозможно соединиться с базой данных. Код ошибки: %s\n", mysqli_connect_error());
    exit;
}
if (!$ID_VK && !$LVLMAX){
    printf("Не переданы все значения");
    exit;
}
$q="SELECT lvl, sum(count) FROM rounds GROUP BY lvl ORDER BY lvl";

   
		$result = mysqli_query($link,$q);
		if ($result){
			while ($rows = mysqli_fetch_array($result)) {
                  //echo ($rows['lvl']."--");
				  echo ($rows[1]."_");
				  				  
            }
    
		}
    
    
	
mysqli_close($link);
?>