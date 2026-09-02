DROP PROCEDURE IF EXISTS add_migration;
DELIMITER ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20260902142143');
IF v = 0 THEN
INSERT INTO `migrations` VALUES ('20260902142143');
-- AzerothLife 2.0b Wounds & Diseases: Workstream E (PvE disease sourcing data).
-- Two auxiliary world tables the core loads at startup (cached) and consults on
-- the disease-exposure vectors:
--   * al_disease_creature: which creatures carry which disease, keyed by
--     creature TYPE / FAMILY (few rows cover thousands of mobs) with optional
--     per-ENTRY override. Rolled per hit RECEIVED from the carrier.
--   * al_disease_zone: which zone/area sickens the player. Rolled per env tick
--     (~30s) while standing in the zone.
-- disease_id = the BASE disease spell (6003x). Sepsis (60031) is NOT a source:
-- it is stage 2 of Festering (60030), reached by progression, not by exposure.
-- chance_permille = per-roll chance in per-mille; 0 => core default constant.
-- Wound infliction by creatures is ALGORITHMIC (Humanoid-by-weapon / Beast->
-- Bleed / rest->none) and needs NO data. See docs/design/wounds-diseases-pve-data.md.

CREATE TABLE IF NOT EXISTS `al_disease_creature` (
  `match_kind` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '0=creature type, 1=creature family, 2=creature entry',
  `match_value` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'id of the type/family/entry',
  `disease_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'base disease spell 6003x',
  `chance_permille` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'per-hit chance in per-mille; 0 = core default',
  PRIMARY KEY (`match_kind`,`match_value`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `al_disease_zone` (
  `zone_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'GetZoneId',
  `area_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'GetAreaId; 0 = whole zone wildcard',
  `disease_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'base disease spell 6003x',
  `chance_permille` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'per env-tick chance in per-mille; 0 = core default',
  PRIMARY KEY (`zone_id`,`area_id`,`disease_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DELETE FROM `al_disease_creature`;
-- match_kind: 0=type, 1=family, 2=entry (precedence entry>family>type in core)
INSERT INTO `al_disease_creature` (`match_kind`,`match_value`,`disease_id`,`chance_permille`) VALUES
  (0,  6, 60036, 10),  -- type UNDEAD        -> The Plague
  (1,  3, 60032, 20),  -- family SPIDER      -> Spider Venom
  (1, 20, 60032, 20),  -- family SCORPID     -> Spider Venom
  (1,  7, 60034, 15),  -- family CARRION_BIRD-> Filth Fever
  (1, 25, 60034, 15),  -- family HYENA       -> Filth Fever
  (1, 24, 60034, 10),  -- family BAT         -> Filth Fever
  (1,  1, 60033,  8),  -- family WOLF        -> Rabies
  (1,  4, 60033,  8),  -- family BEAR        -> Rabies
  (1,  2, 60033,  8);  -- family CAT         -> Rabies

DELETE FROM `al_disease_zone`;
-- zone_id (area_id 0 = whole zone). Standard 1.12 vanilla zone ids.
INSERT INTO `al_disease_zone` (`zone_id`,`area_id`,`disease_id`,`chance_permille`) VALUES
  ( 11, 0, 60035, 20),  -- Wetlands            -> Marsh Fever
  (  8, 0, 60035, 20),  -- Swamp of Sorrows    -> Marsh Fever
  ( 15, 0, 60035, 20),  -- Dustwallow Marsh    -> Marsh Fever
  ( 28, 0, 60036, 20),  -- Western Plaguelands -> The Plague
  (139, 0, 60036, 25);  -- Eastern Plaguelands -> The Plague

-- End of migration.
END IF;
END??
DELIMITER ;
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
