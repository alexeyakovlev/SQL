DROP DATABASE IF EXISTS lesson_6;
CREATE DATABASE lesson_6;
USE lesson_6;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);

INSERT INTO users (id, firstname, lastname, email) VALUES 
(1, 'Alexey', 'Yakovlev', 'alexio98@yandex.ru'),
(2, 'Julia', 'Kardivar', 'julia0707@yandex.ru'),
(3, 'Yana', 'Strorm', 'Strom@google.com'),
(4, 'Jason', 'Statham', 'Statham@google.com'),
(5, 'Victor', 'fonDoom', 'Doom@rambler.ru'),
(6, 'Victoria', 'Secret', 'Secret@mail.ru'),
(7, 'Donald', 'Trump', 'President@trump.com'),
(8, 'Bruce', 'Wayne', 'Bat.man@wayne.com'),
(9, 'Vera', 'Brejneva', 'Pevica@yandex.ru'),
(10, 'John', 'Wick', 'Kill@google.com');

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (from_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (to_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO messages  (from_user_id, to_user_id, body, created_at) VALUES
(1, 2, 'Hello, how are you?',  DATE_ADD(NOW(), INTERVAL 1 MINUTE)),
(2, 1, 'Hey, i,m fine. Thanks',  DATE_ADD(NOW(), INTERVAL 3 MINUTE)),
(3, 1, 'Hey, I miss you',  DATE_ADD(NOW(), INTERVAL 5 MINUTE)),
(4, 1, 'Hello! I was invited to a cool movie. Go with me.',  DATE_ADD(NOW(), INTERVAL 11 MINUTE)),
(1, 5, 'When will you free Latveria?',  DATE_ADD(NOW(), INTERVAL 12 MINUTE)),
(1, 6, 'Hello! when will the new collection be released?',  DATE_ADD(NOW(), INTERVAL 14 MINUTE)),
(1, 7, 'I will support you in the elections!!!',  DATE_ADD(NOW(), INTERVAL 15 MINUTE)),
(8, 1, 'This city needs a new hero!',  DATE_ADD(NOW(), INTERVAL 21 MINUTE)),
(9, 3, 'Lets chat today,',  DATE_ADD(NOW(), INTERVAL 22 MINUTE)),
(10, 2, 'Hey, how are you?',  DATE_ADD(NOW(), INTERVAL 25 MINUTE));

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'unfriended', 'declined'),
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME,
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE, 
    FOREIGN KEY (target_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO friend_requests (initiator_user_id, target_user_id, `status`, requested_at, updated_at) 
VALUES 
(1, 8, 'approved', '2024-08-05 12:30:00', NULL),
(1, 2, 'requested', '2024-08-05 20:40:00', NULL),
(1, 3, 'approved', '2024-08-09 12:00:00', '2024-08-12 02:30:00'),
(8, 2, 'requested', '2024-08-11 12:00:00', '2024-08-12 12:00:00'),
(5, 8, 'approved', '2024-06-25 16:43:00', '2024-08-01 12:52:00'),
(7, 3, 'unfriended', '2024-02-10 12:45:00', '2024-05-07 08:01:01'),
(4, 6, 'unfriended', '2024-04-27 23:15:00', '2024-06-11 17:48:00'),
(9, 2, 'approved', '2024-08-13 08:30:00', NULL);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150),
    INDEX communities_name_idx(name)
);

INSERT INTO `communities` (name) 
VALUES ('atque'), ('beatae'), ('est'), ('eum'), ('hic'), ('nemo'), ('quis'), ('rerum'), ('tempora'), ('voluptas');

-- пользователи сообщества
DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (user_id, community_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (community_id) REFERENCES communities(id) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO users_communities (user_id, community_id) 
VALUES 
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 2), 
(3, 1), (3, 2),
(4, 1), (4, 2), (4, 3),
(5, 1), (5, 2),
(6, 1), (6, 2), (6, 3),
(7, 1), (7, 2), (7, 3), (7, 4),
(8, 1), (8, 8),
(9, 1), (9, 2),  
(10, 1), (10, 2);

SELECT 
	id,
	CONCAT(firstname, ' ', lastname) AS 'Пользователь', 
	(SELECT hometown FROM profiles WHERE user_id = users.id) AS 'Город'
FROM users;

SELECT initiator_user_id AS id FROM friend_requests 
WHERE target_user_id = 1 AND status='approved' 
UNION
SELECT target_user_id FROM friend_requests 
WHERE initiator_user_id = 1 AND status='approved';

SELECT * FROM users, messages;
SELECT * FROM users
JOIN messages;

SELECT * FROM users u
JOIN messages m 
WHERE u.id=m.from_user_id;

SELECT * FROM users u
JOIN messages m ON u.id=m.from_user_id;

SELECT u.*, m.*  FROM users u
LEFT JOIN messages m ON u.id=m.from_user_id;

SELECT u.*, m.*  FROM users u
RIGHT JOIN messages m ON u.id=m.from_user_id;

SELECT u.*, m.*  FROM users u
LEFT JOIN messages m ON u.id=m.from_user_id
UNION 
SELECT u.*, m.*  FROM users u
RIGHT JOIN messages m ON u.id=m.from_user_id;