DROP PROCEDURE IF EXISTS add_migration;
DELIMITER ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20260901202210');
IF v = 0 THEN
INSERT INTO `migrations` VALUES ('20260901202210');
-- Add your query below.

-- AzerothLife: Hunger & Thirst needs system (Phase 1).
-- Persists two per-character 0-100 meters. Owned by the fork core, loaded on
-- login and written on the player save path. Never edited by hand.
CREATE TABLE IF NOT EXISTS `character_needs` (
  `guid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier, Low part',
  `hunger` tinyint(3) unsigned NOT NULL DEFAULT '100' COMMENT '0-100, 100 = full',
  `thirst` tinyint(3) unsigned NOT NULL DEFAULT '100' COMMENT '0-100, 100 = full',
  `last_update` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Unix time of last save',
  PRIMARY KEY (`guid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='AzerothLife Hunger & Thirst needs';

-- End of migration.
END IF;
END??
DELIMITER ;
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
