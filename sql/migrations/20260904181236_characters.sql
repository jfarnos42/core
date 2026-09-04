DROP PROCEDURE IF EXISTS add_migration;
DELIMITER ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20260904181236');
IF v = 0 THEN
INSERT INTO `migrations` VALUES ('20260904181236');
-- AzerothLife Professions Reset: immediate bulk wipe of the 12 disabled vanilla
-- profession skill lines from every existing character. This is a convenience so
-- offline characters are cleaned without waiting for their next login; the core
-- login-strip (Player::StripDisabledProfessions) catches any remainder AND clears
-- the orphaned recipe spells from character_spell, which this migration leaves to
-- the core (removing them by SQL would require enumerating every recipe spellId).
-- The PM takes a backup before applying. Skill ids match al_disabled_skills.
DELETE FROM `character_skills` WHERE `skill` IN
  (171, 164, 333, 202, 182, 165, 186, 393, 197, 129, 185, 356);

-- End of migration.
END IF;
END??
DELIMITER ;
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
