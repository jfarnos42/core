DROP PROCEDURE IF EXISTS add_migration;
DELIMITER ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20260905174123');
IF v = 0 THEN
INSERT INTO `migrations` VALUES ('20260905174123');
-- AzerothLife (Survival — Profession Skeleton): spell 60040 "Survival" (Apprentice).
-- Server reads spell mechanics from spell_template (client gets the icon/name via
-- patch-A.MPQ Spell.dbc). This is the profession trade spell: Effect1=TRADE_SKILL(47)
-- opens the native recipe book; Effect2=SKILL(118) misc=142 base=0 = learn SkillLine 142
-- (Survival) at tier step 1 -> max 75 (Apprentice), using its SkillTiers (61) fixed in
-- SkillRaceClassInfo. Cloned from Apprentice Cooking (2550); build=5302 = the row build
-- this 5875 realm loads. Granted to all via Player::EnsureSurvivalSkill (LearnSpell 60040).
-- Journeyman/Expert/Artisan (60041/60042/60043, max 150/225/300) are RESERVED for future
-- quest unlocks and intentionally NOT created here.
DELETE FROM `spell_template` WHERE `entry`=60040;
CREATE TEMPORARY TABLE _surv_tmpl AS SELECT * FROM `spell_template` WHERE `entry`=2550 AND `build`=4449 LIMIT 1;
UPDATE _surv_tmpl SET `entry`=60040, `build`=5302, `name`='Survival', `spellIconId`=179,
  `effectMiscValue2`=142;
INSERT INTO `spell_template` SELECT * FROM _surv_tmpl;
DROP TEMPORARY TABLE _surv_tmpl;

-- End of migration.
END IF;
END??
DELIMITER ;
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
