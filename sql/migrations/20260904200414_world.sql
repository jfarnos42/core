DROP PROCEDURE IF EXISTS add_migration;
DELIMITER ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20260904200414');
IF v = 0 THEN
INSERT INTO `migrations` VALUES ('20260904200414');
-- AzerothLife Survival S0: empty content tables for the Survival skill (142).
-- These ship EMPTY in S0 -- the fork core loads them once at startup (cached in
-- ObjectMgr, see LoadSurvivalTables) and on `.survival reload`. No recipes and
-- no foraging exist yet; later phases populate these rows without a schema or
-- loader rewrite. See docs/design/survival-s0.md.

-- Recipes (crafting). requires_campfire flags recipes that need a nearby fire.
-- Reagent columns are intentionally deferred to v0.1; this is a base schema.
CREATE TABLE IF NOT EXISTS `al_survival_recipe` (
  `recipe_id` int(10) unsigned NOT NULL COMMENT 'unique recipe id',
  `product_item` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'item_template entry produced',
  `product_qty` int(10) unsigned NOT NULL DEFAULT 1 COMMENT 'amount produced',
  `skill_req` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'min Survival skill to craft',
  `skill_gain` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'skill points gained on craft',
  `requires_campfire` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT '1 = needs a nearby campfire',
  PRIMARY KEY (`recipe_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='AzerothLife Survival S0 recipes (empty in S0)';

-- Foraging (gathering). Item drops per zone/area with a per-mille chance and a
-- quantity range, gated and rewarded by Survival skill.
CREATE TABLE IF NOT EXISTS `al_survival_forage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'row id',
  `zone_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'zone id',
  `area_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'area id (0 = whole zone)',
  `item_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'item_template entry foraged',
  `chance_permille` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'drop chance in per-mille (0-1000)',
  `min_qty` int(10) unsigned NOT NULL DEFAULT 1 COMMENT 'minimum quantity',
  `max_qty` int(10) unsigned NOT NULL DEFAULT 1 COMMENT 'maximum quantity',
  `skill_req` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'min Survival skill to forage',
  `skill_gain` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'skill points gained on forage',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='AzerothLife Survival S0 forage (empty in S0)';

-- End of migration.
END IF;
END??
DELIMITER ;
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
