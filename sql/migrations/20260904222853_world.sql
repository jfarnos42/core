DROP PROCEDURE IF EXISTS add_migration;
DELIMITER ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20260904222853');
IF v = 0 THEN
INSERT INTO `migrations` VALUES ('20260904222853');
-- AzerothLife Survival v0.1: gathering-node registry for the Survival skill (142).
-- Ships EMPTY -- the fork core loads it once at startup (cached in ObjectMgr, see
-- LoadSurvivalTables/GetSurvivalNode) and on `.survival reload`. The PM inserts the
-- node rows in a separate migration alongside the GOs/items/loot. A row marks a
-- vanilla CHEST gameobject (lockId=0) as a Survival gathering node: it gates the
-- gather by Survival skill and grants Survival skill-ups on success. GOs absent
-- from this table behave as ordinary chests. See docs/design/survival-v0.1.md.
CREATE TABLE IF NOT EXISTS `al_survival_node` (
  `go_entry` int(10) unsigned NOT NULL COMMENT 'gameobject_template entry of the node (CHEST, lockId=0)',
  `required_skill` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'min Survival skill to gather',
  `red_level` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'skill level past which the node grants no skill (grey)',
  `skill_gain` int(10) unsigned NOT NULL DEFAULT 1 COMMENT 'skill points per successful gather',
  PRIMARY KEY (`go_entry`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='AzerothLife Survival v0.1 gathering nodes (empty; rows added separately)';

-- End of migration.
END IF;
END??
DELIMITER ;
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
