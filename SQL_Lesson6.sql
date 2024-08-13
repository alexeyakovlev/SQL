USE lesson_6;

/*
1.Создайте таблицу users_old, аналогичную таблице users.
 Создайте процедуру,  с помощью которой можно переместить любого (одного) 
 пользователя из таблицы users в таблицу users_old. 
(использование транзакции с выбором commit или rollback – обязательно).
*/

DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id INT PRIMARY KEY auto_increment,
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);

DROP PROCEDURE IF EXISTS user_transfer;
DELIMITER //
CREATE PROCEDURE user_transfer(IN num1 INT)
    DETERMINISTIC
BEGIN

INSERT INTO users_old (firstname,lastname,email) 
SELECT firstname, lastname, email 
	FROM users 
	WHERE users.id = num1;
DELETE FROM users 
	WHERE id = num1;
COMMIT;
END$$

DELIMITER ;

CALL user_transfer(3);

/*
Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
 С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
 с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
*/

DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello()
RETURNS VARCHAR(25)
BEGIN
	DECLARE time_now INT;
	SET time_now = HOUR(now());
	CASE
		WHEN time_now BETWEEN 0 AND 5 THEN 
			RETURN 'Доброй ночи!';
		WHEN time_now BETWEEN 6 AND 11 THEN 
			RETURN 'Доброе утро!';
		WHEN time_now BETWEEN 12 AND 17 THEN 
			RETURN 'Добрый день!';
		WHEN time_now BETWEEN 18 AND 23 THEN 
			RETURN 'Добрый вечер!';
	END CASE;
END//
DELIMITER ;
SELECT hello();