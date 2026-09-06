DROP PROCEDURE IF EXISTS add_migration;
DELIMITER ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20260906162444');
IF v = 0 THEN
INSERT INTO `migrations` VALUES ('20260906162444');
-- Add your query below.

-- Survival profession recipe: Roasted Boar Meat (custom spell 60100).
-- Server mechanics = clone of vanilla cooking recipe 2540: SPELL_EFFECT_CREATE_ITEM
-- produces item 2681 (Roasted Boar Meat) from reagent 769 (Chunk of Boar Meat), and
-- requiresSpellFocus=4 (cooking fire) so it must be crafted near any cooking fire,
-- identical to the Cooking version. The skill-line link to custom skill 401 and the
-- auto-learn (AcquireMethod=1) live in SkillLineAbility.dbc, so casting it skills up 401.
DELETE FROM `spell_template` WHERE `entry`=60100 AND `build`=5302;
CREATE TEMPORARY TABLE _t AS SELECT * FROM `spell_template` WHERE `entry`=2540 AND `build`=4222 LIMIT 1;
UPDATE _t SET `entry`=60100, `build`=5302, `name`='Roasted Boar Meat';
INSERT INTO `spell_template` SELECT * FROM _t;
DROP TEMPORARY TABLE _t;

-- Formalize the Survival opener's custom skill link (60040 -> skill 401), previously a
-- direct UPDATE during the fresh-skill-line work (prof-3). Idempotent.
UPDATE `spell_template` SET `effectMiscValue2`=401 WHERE `entry`=60040 AND `build`=5302;

-- End of migration.
END IF;
END??
DELIMITER ;
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
