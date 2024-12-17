use test;
CREATE TABLE IF NOT EXISTS `test` (
    `id` int(11) NOT NULL auto_increment,
    `title` varchar(50) NOT NULL,
    `time_add` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY  (`id`)
    ) ENGINE="MyISAM" DEFAULT CHARSET=utf8;