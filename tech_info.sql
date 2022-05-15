DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_project_files`(IN `p_project_id` INT)
    READS SQL DATA
    COMMENT 'Возвращает список файлов заданного проекта'
SELECT l.`file_id`
FROM `project_files_links` l
WHERE l.`project_id`=`p_project_id`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_unlinked_files`()
    READS SQL DATA
    COMMENT 'Возвращает список файлов, не привязанных ни к одному проекту'
SELECT f.id as file_id
FROM files_upload f
WHERE NOT EXISTS(
	SELECT 1 
	FROM project_files_links l
        WHERE l.file_id=f.id
        )$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `files_upload`
--

CREATE TABLE IF NOT EXISTS `files_upload` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `file_url` varchar(1000) NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `user_id_2` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Загруженные файлы' AUTO_INCREMENT=3 ;

--
-- Структура таблицы `projects`
--

CREATE TABLE IF NOT EXISTS `projects` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `project_name` varchar(50) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Список проектов' AUTO_INCREMENT=2 ;


--
-- Структура таблицы `project_changes`
--

CREATE TABLE IF NOT EXISTS `project_changes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `link_id` int(11) unsigned NOT NULL,
  `project_id` int(11) unsigned NOT NULL,
  `file_id` int(11) unsigned NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(11) unsigned NOT NULL,
  `action` varchar(15) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `file_id` (`file_id`),
  KEY `project_id` (`project_id`),
  KEY `link_id` (`link_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Изменения привязки файлов к проектам' AUTO_INCREMENT=2 ;


--
-- Структура таблицы `project_files_links`
--

CREATE TABLE IF NOT EXISTS `project_files_links` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `project_id` int(11) unsigned NOT NULL,
  `file_id` int(11) unsigned NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `file_id` (`file_id`),
  KEY `project_id` (`project_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Связи проектов с файлами' AUTO_INCREMENT=2 ;

--
-- Триггеры `project_files_links`
--
DROP TRIGGER IF EXISTS `delete_project_file`;
DELIMITER //
CREATE TRIGGER `delete_project_file` BEFORE DELETE ON `project_files_links`
 FOR EACH ROW INSERT INTO `project_changes`( `link_id`, `project_id`, `file_id`, `last_update`, `user_id`, `action`) 
VALUES (old.`id`, old.`project_id`, old.`file_id`, old.`last_update`, old.`user_id`,'del')
//
DELIMITER ;
DROP TRIGGER IF EXISTS `edit_project_file`;
DELIMITER //
CREATE TRIGGER `edit_project_file` BEFORE UPDATE ON `project_files_links`
 FOR EACH ROW INSERT INTO `project_changes`( `link_id`, `project_id`, `file_id`, `last_update`, `user_id`, `action`) 
VALUES (old.`id`, old.`project_id`, old.`file_id`, old.`last_update`, old.`user_id`,'upd')
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `login` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_users_login` (`login`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Список пользователей' AUTO_INCREMENT=3 ;


--
-- Структура таблицы `user_project_link`
--

CREATE TABLE IF NOT EXISTS `user_project_link` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Сопоставление пользователей с проектами' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `v_project_files`
--
CREATE TABLE IF NOT EXISTS `v_project_files` (
`project_id` int(11) unsigned
,`project_date` timestamp
,`file_url` varchar(1000)
,`file_id` int(11) unsigned
,`last_update` timestamp
,`user_id` int(11) unsigned
,`login` varchar(50)
);
-- --------------------------------------------------------

--
-- Структура для представления `v_project_files`
--
DROP TABLE IF EXISTS `v_project_files`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_project_files` AS select `p`.`id` AS `project_id`,`p`.`create_date` AS `project_date`,`f`.`file_url` AS `file_url`,`l`.`file_id` AS `file_id`,`l`.`last_update` AS `last_update`,`p`.`user_id` AS `user_id`,`u`.`login` AS `login` from (((`projects` `p` left join `project_files_links` `l` on((`p`.`id` = `l`.`project_id`))) left join `files_upload` `f` on((`f`.`id` = `l`.`file_id`))) left join `users` `u` on((`u`.`id` = `p`.`user_id`)));

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `files_upload`
--
ALTER TABLE `files_upload`
  ADD CONSTRAINT `files_upload_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE NO ACTION;

--
-- Ограничения внешнего ключа таблицы `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION;

--
-- Ограничения внешнего ключа таблицы `project_changes`
--
ALTER TABLE `project_changes`
  ADD CONSTRAINT `project_changes_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `project_changes_ibfk_2` FOREIGN KEY (`file_id`) REFERENCES `files_upload` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `project_changes_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `project_changes_ibfk_4` FOREIGN KEY (`link_id`) REFERENCES `project_files_links` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ограничения внешнего ключа таблицы `project_files_links`
--
ALTER TABLE `project_files_links`
  ADD CONSTRAINT `project_files_links_ibfk_1` FOREIGN KEY (`file_id`) REFERENCES `files_upload` (`id`) ON UPDATE NO ACTION,
  ADD CONSTRAINT `project_files_links_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE NO ACTION,
  ADD CONSTRAINT `project_files_links_ibfk_3` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON UPDATE NO ACTION;

--
-- Ограничения внешнего ключа таблицы `user_project_link`
--
ALTER TABLE `user_project_link`
  ADD CONSTRAINT `user_project_link_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `user_project_link_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
