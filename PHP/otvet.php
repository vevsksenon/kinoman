<?php

//принимаем переменные от нашего клиентского приложени¤ через метод передачи данных POST

$ID_VK = $_POST['id'];
$LVL = $_POST['lvl'];
$NOMER = $_POST['nomer'];
$OTVET = $_POST['otvet'];

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
if (!$ID_VK && !$LVL && !$NOMER && !$OTVET){
    printf("Не переданы все значения");
    exit;
}

//Проверяем ответ на правильность
    $q="SELECT * FROM otvet where lvl,pravilno in ('$LVL'.'$NOMER','$OTVET')";
	$z="insert into rounds(id,lvl,nomer,count) values ('$ID_VK', '$LVL', '$NOMER', '5')";
	$z2="insert into rounds(id,lvl,nomer,count) values ('$ID_VK', '$LVL', '$NOMER', '1')";
	$zz="UPDATE rounds SET count = 5 WHERE id=$ID_VK, lvl=$LVL, nomer=$NOMER"; 
	$zz2="UPDATE rounds SET count = 1 WHERE id=$ID_VK, lvl=$LVL, nomer=$NOMER"; 
	
    $result = mysqli_query($link,$q);
	if ($result){
		$result1 = mysqli_query($link,$z); //Пробуем записать +5
		echo 5;
		exit;
		if (!$result1){
			$result2 = mysqli_query($link,$zz);//Пробуем обновить +5
			echo 5;
	     	exit;
		}
	}
	if (!$result){
		$result3 = mysqli_query($link,$z2); //Пробуем записать 0
		if ($result3){
			echo 0;
	     	exit;
		}
		if (!$result3){
			$result4 = mysqli_query($link,$zz2); //Пробуем обновить 0
			echo 0;
	     	exit;
		}
	}
	
	
	
	


mysqli_close($link);
?>