DROP PROCEDURE IF EXISTS add_migration;
DELIMITER ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20260902000809');
IF v = 0 THEN
INSERT INTO `migrations` VALUES ('20260902000809');
-- AzerothLife: Needs (Hunger & Thirst) Phase 2 state auras in spell_template.
-- Server reads spell mechanics from spell_template, not the client Spell.dbc
-- (client gets these via patch-A.MPQ). Clone known templates and override name/
-- icon/duration/effects. Magnitudes are placeholders tuned in Phase 3 via
-- spell_effect_mod. build=5302 = the row build this 5875 realm loads.
DELETE FROM `spell_template` WHERE `entry` BETWEEN 60000 AND 60003;

-- 60000 Starving: clone Resurrection Sickness (debuff look), -- all stats.
CREATE TEMPORARY TABLE _needs_tmpl AS SELECT * FROM `spell_template` WHERE `entry`=15007 AND `build`=5302 LIMIT 1;
UPDATE _needs_tmpl SET `entry`=60000, `build`=5302, `name`='Starving', `spellIconId`=358, `durationIndex`=21,
  `effect1`=6, `effectApplyAuraName1`=80, `effectMiscValue1`=-1, `effectBasePoints1`=-11, `effectImplicitTargetA1`=1,
  `effect2`=0, `effectApplyAuraName2`=0, `effectBasePoints2`=0, `effectMiscValue2`=0, `effectImplicitTargetA2`=0,
  `effect3`=0, `effectApplyAuraName3`=0, `effectBasePoints3`=0, `effectMiscValue3`=0, `effectImplicitTargetA3`=0,
  `description`='You are starving. Your body is weakened.', `auraDescription`='You are starving. Your body is weakened.';
INSERT INTO `spell_template` SELECT * FROM _needs_tmpl;
DROP TEMPORARY TABLE _needs_tmpl;

-- 60001 Sated: clone Well Fed (buff look), ++ all stats.
CREATE TEMPORARY TABLE _needs_tmpl AS SELECT * FROM `spell_template` WHERE `entry`=19705 AND `build`=4222 LIMIT 1;
UPDATE _needs_tmpl SET `entry`=60001, `build`=5302, `name`='Sated', `spellIconId`=1467, `durationIndex`=21, `attributesEx2`=0, `attributes`=(`attributes` | 2147483648),
  `effect1`=6, `effectApplyAuraName1`=80, `effectMiscValue1`=-1, `effectBasePoints1`=9, `effectImplicitTargetA1`=1,
  `effect2`=0, `effectApplyAuraName2`=0, `effectBasePoints2`=0, `effectMiscValue2`=0, `effectImplicitTargetA2`=0,
  `effect3`=0, `effectApplyAuraName3`=0, `effectBasePoints3`=0, `effectMiscValue3`=0, `effectImplicitTargetA3`=0,
  `description`='You are sated. You feel hale and strong.', `auraDescription`='You are sated. You feel hale and strong.';
INSERT INTO `spell_template` SELECT * FROM _needs_tmpl;
DROP TEMPORARY TABLE _needs_tmpl;

-- 60002 Dehydrated: clone Resurrection Sickness (debuff look), -- health & mana regen.
CREATE TEMPORARY TABLE _needs_tmpl AS SELECT * FROM `spell_template` WHERE `entry`=15007 AND `build`=5302 LIMIT 1;
UPDATE _needs_tmpl SET `entry`=60002, `build`=5302, `name`='Dehydrated', `spellIconId`=1309, `durationIndex`=21,
  `effect1`=6, `effectApplyAuraName1`=84, `effectMiscValue1`=0, `effectBasePoints1`=-6, `effectImplicitTargetA1`=1,
  `effect2`=6, `effectApplyAuraName2`=85, `effectMiscValue2`=0, `effectBasePoints2`=-6, `effectImplicitTargetA2`=1,
  `effect3`=6, `effectApplyAuraName3`=33, `effectBasePoints3`=-11, `effectMiscValue3`=0, `effectImplicitTargetA3`=1,
  `description`='You are dehydrated. Your recovery falters.', `auraDescription`='You are dehydrated. Your recovery falters.';
INSERT INTO `spell_template` SELECT * FROM _needs_tmpl;
DROP TEMPORARY TABLE _needs_tmpl;

-- 60003 Quenched: clone Well Fed (buff look), ++ health & mana regen.
CREATE TEMPORARY TABLE _needs_tmpl AS SELECT * FROM `spell_template` WHERE `entry`=19705 AND `build`=4222 LIMIT 1;
UPDATE _needs_tmpl SET `entry`=60003, `build`=5302, `name`='Quenched', `spellIconId`=1309, `durationIndex`=21, `attributesEx2`=0, `attributes`=(`attributes` | 2147483648),
  `effect1`=6, `effectApplyAuraName1`=84, `effectMiscValue1`=0, `effectBasePoints1`=4, `effectImplicitTargetA1`=1,
  `effect2`=6, `effectApplyAuraName2`=85, `effectMiscValue2`=0, `effectBasePoints2`=4, `effectImplicitTargetA2`=1,
  `effect3`=6, `effectApplyAuraName3`=31, `effectBasePoints3`=9, `effectMiscValue3`=0, `effectImplicitTargetA3`=1,
  `description`='Your thirst is quenched. You recover swiftly.', `auraDescription`='Your thirst is quenched. You recover swiftly.';
INSERT INTO `spell_template` SELECT * FROM _needs_tmpl;
DROP TEMPORARY TABLE _needs_tmpl;

-- End of migration.
END IF;
END??
DELIMITER ;
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
