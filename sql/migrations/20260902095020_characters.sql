DROP PROCEDURE IF EXISTS add_migration;
DELIMITER ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20260902095020');
IF v = 0 THEN
INSERT INTO `migrations` VALUES ('20260902095020');
-- AzerothLife 2.0b Wounds & Diseases: disease persistence (Workstream B).
-- Diseases are long-lived and persist across logout (unlike Wounds, which are
-- transient and not stored). One row per (character, disease type). Owned by the
-- fork core: loaded on login, written on the player save path. Never edited by
-- hand. `stage` tracks progression (e.g. Festering=1 -> Sepsis=2; Plague levels).
CREATE TABLE IF NOT EXISTS `character_diseases` (
  `guid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Character GUID, low part',
  `disease_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Disease type id (core enum / base spell entry)',
  `stage` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT 'Severity stage, 1 = first',
  `contracted_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Unix time contracted',
  `incubation_end` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Unix time symptoms begin (0 = already active)',
  `next_progress_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Unix time it next worsens (0 = static / at max / halted)',
  `last_update` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Unix time of last core update/save',
  PRIMARY KEY (`guid`,`disease_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='AzerothLife Diseases (2.0b) — one row per character per disease';

-- End of migration.
END IF;
END??
DELIMITER ;
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
