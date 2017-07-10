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
    $LVLN = $LVL.$NOMER;
    $q="SELECT * FROM otvet where lvl = $LVLN AND pravilno = '$OTVET'";
	$q2="SELECT * FROM rounds where id = $ID_VK AND lvl = $LVL AND nomer = $NOMER";
	$z="insert into rounds(id,lvl,nomer,count) values ('$ID_VK', '$LVL', '$NOMER', '5')";
	$z2="insert into rounds(id,lvl,nomer,count) values ('$ID_VK', '$LVL', '$NOMER', '0')";
	$zz="DELETE FROM rounds  WHERE id = $ID_VK AND lvl = $LVL AND nomer = $NOMER";  
	
	$zap = "SELECT * FROM rounds where id = $ID_VK AND lvl = $LVL AND nomer = $NOMER AND count";
	
    $result = mysqli_query($link,$q);
	if ($result){
		$numb1 = mysqli_fetch_row($result);
		if ($numb1){
			$result1 = mysqli_query($link,$q2); //Проверяем есть ли запись про этот уровень в БД
			$numb2 = mysqli_fetch_row($result1);
			if ($numb2){
				$result2 = mysqli_query($link,$zz);
				if ($result2){
					$result3 = mysqli_query($link,$z);
				    echo 5;
				    exit;
				}
				
			}
            if (!$numb2){
				$result3 = mysqli_query($link,$z);
				echo 5;
				exit;
			}				
	    }
		else if (!$numb1){
			$result1 = mysqli_query($link,$q2); //Проверяем есть ли запись про этот уровень в БД
			$numb2 = mysqli_fetch_row($result1);
			if ($numb2){
				$result2 = mysqli_query($link,$zz);
				if ($result2){
					$result3 = mysqli_query($link,$z2);
				    echo 0;
				    exit;
				}
				
			}
            if (!$numb2){
				$result2 = mysqli_query($link,$z2);
				echo 0;
				exit;
			}		
		}
			
		
		
	}
	
	
	
	
	


mysqli_close($link);
?>