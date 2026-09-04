DROP PROCEDURE IF EXISTS add_migration;
DELIMITER ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20260904181235');
IF v = 0 THEN
INSERT INTO `migrations` VALUES ('20260904181235');
-- AzerothLife Professions Reset: deny-list of vanilla profession skill lines.
-- The fork core loads this table once at startup (cached in ObjectMgr, see
-- LoadDisabledSkills) and consults it when rendering trainers, when learning
-- spells/skills and at login (the wipe). Reactivating a profession is data-only
-- and needs NO recompile: DELETE its row here (or in-DB) then `.professions
-- reload` (or restart). Lockpicking (633) and Poisons (40) are CLASS skills and
-- are intentionally NOT listed. See docs/design/professions-reset.md.
CREATE TABLE IF NOT EXISTS `al_disabled_skills` (
  `skill_id` int(10) unsigned NOT NULL COMMENT 'SkillLine.dbc id to disable',
  `note` varchar(64) NOT NULL DEFAULT '' COMMENT 'human-readable skill name',
  PRIMARY KEY (`skill_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='AzerothLife professions-reset deny-list';

INSERT INTO `al_disabled_skills` (`skill_id`, `note`) VALUES
  (171, 'Alchemy'),
  (164, 'Blacksmithing'),
  (333, 'Enchanting'),
  (202, 'Engineering'),
  (182, 'Herbalism'),
  (165, 'Leatherworking'),
  (186, 'Mining'),
  (393, 'Skinning'),
  (197, 'Tailoring'),
  (129, 'First Aid'),
  (185, 'Cooking'),
  (356, 'Fishing')
ON DUPLICATE KEY UPDATE `note` = VALUES(`note`);

-- End of migration.
END IF;
END??
DELIMITER ;
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
