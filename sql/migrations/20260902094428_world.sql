DROP PROCEDURE IF EXISTS add_migration;
DELIMITER ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20260902094428');
IF v = 0 THEN
INSERT INTO `migrations` VALUES ('20260902094428');
-- AzerothLife 2.0b Wounds & Diseases: custom aura spells in spell_template.
-- Bleed 60010-60012, Concussion 60020-60022, Diseases 60030-60036.
-- Cloned from Resurrection Sickness (15007, debuff) / War Stomp (20549, stun,
-- mechanic 12 for PvP diminishing returns). Magnitudes are placeholders; the
-- core (Workstream C/D) drives dynamic values (bleed snapshot, stun via DR,
-- Needs-sabotage). Kept in sync with client Spell.dbc (patch-A.MPQ) 1:1.
DELETE FROM `spell_template` WHERE `entry` BETWEEN 60010 AND 60036;

-- 60010 Minor Bleed
CREATE TEMPORARY TABLE _t AS SELECT * FROM `spell_template` WHERE `entry`=15007 AND `build`=5302 LIMIT 1;
UPDATE _t SET `entry`=60010,
  `build`=5302,
  `name`='Minor Bleed',
  `spellIconId`=108,
  `durationIndex`=21,
  `mechanic`=0,
  `effect1`=6,
  `effectApplyAuraName1`=3,
  `effectBasePoints1`=4,
  `effectMiscValue1`=0,
  `effectImplicitTargetA1`=1,
  `effectAmplitude1`=3000,
  `effectMechanic1`=0,
  `effect2`=0,
  `effectApplyAuraName2`=0,
  `effectBasePoints2`=0,
  `effectMiscValue2`=0,
  `effectImplicitTargetA2`=0,
  `effectAmplitude2`=0,
  `effectMechanic2`=0,
  `effect3`=0,
  `effectApplyAuraName3`=0,
  `effectBasePoints3`=0,
  `effectMiscValue3`=0,
  `effectImplicitTargetA3`=0,
  `effectAmplitude3`=0,
  `effectMechanic3`=0,
  `description`='You are bleeding. Minor blood loss.',
  `auraDescription`='You are bleeding. Minor blood loss.';
INSERT INTO `spell_template` SELECT * FROM _t;
DROP TEMPORARY TABLE _t;

-- 60011 Deep Wound
CREATE TEMPORARY TABLE _t AS SELECT * FROM `spell_template` WHERE `entry`=15007 AND `build`=5302 LIMIT 1;
UPDATE _t SET `entry`=60011,
  `build`=5302,
  `name`='Deep Wound',
  `spellIconId`=243,
  `durationIndex`=21,
  `mechanic`=0,
  `effect1`=6,
  `effectApplyAuraName1`=3,
  `effectBasePoints1`=7,
  `effectMiscValue1`=0,
  `effectImplicitTargetA1`=1,
  `effectAmplitude1`=3000,
  `effectMechanic1`=0,
  `effect2`=0,
  `effectApplyAuraName2`=0,
  `effectBasePoints2`=0,
  `effectMiscValue2`=0,
  `effectImplicitTargetA2`=0,
  `effectAmplitude2`=0,
  `effectMechanic2`=0,
  `effect3`=0,
  `effectApplyAuraName3`=0,
  `effectBasePoints3`=0,
  `effectMiscValue3`=0,
  `effectImplicitTargetA3`=0,
  `effectAmplitude3`=0,
  `effectMechanic3`=0,
  `description`='A deep wound bleeds freely. Serious blood loss.',
  `auraDescription`='A deep wound bleeds freely. Serious blood loss.';
INSERT INTO `spell_template` SELECT * FROM _t;
DROP TEMPORARY TABLE _t;

-- 60012 Hemorrhage
CREATE TEMPORARY TABLE _t AS SELECT * FROM `spell_template` WHERE `entry`=15007 AND `build`=5302 LIMIT 1;
UPDATE _t SET `entry`=60012,
  `build`=5302,
  `name`='Hemorrhage',
  `spellIconId`=153,
  `durationIndex`=21,
  `mechanic`=0,
  `effect1`=6,
  `effectApplyAuraName1`=3,
  `effectBasePoints1`=11,
  `effectMiscValue1`=0,
  `effectImplicitTargetA1`=1,
  `effectAmplitude1`=3000,
  `effectMechanic1`=0,
  `effect2`=0,
  `effectApplyAuraName2`=0,
  `effectBasePoints2`=0,
  `effectMiscValue2`=0,
  `effectImplicitTargetA2`=0,
  `effectAmplitude2`=0,
  `effectMechanic2`=0,
  `effect3`=0,
  `effectApplyAuraName3`=0,
  `effectBasePoints3`=0,
  `effectMiscValue3`=0,
  `effectImplicitTargetA3`=0,
  `effectAmplitude3`=0,
  `effectMechanic3`=0,
  `description`='You are hemorrhaging. Severe blood loss.',
  `auraDescription`='You are hemorrhaging. Severe blood loss.';
INSERT INTO `spell_template` SELECT * FROM _t;
DROP TEMPORARY TABLE _t;

-- 60020 Rattled
CREATE TEMPORARY TABLE _t AS SELECT * FROM `spell_template` WHERE `entry`=15007 AND `build`=5302 LIMIT 1;
UPDATE _t SET `entry`=60020,
  `build`=5302,
  `name`='Rattled',
  `spellIconId`=282,
  `durationIndex`=21,
  `mechanic`=0,
  `effect1`=6,
  `effectApplyAuraName1`=33,
  `effectBasePoints1`=-16,
  `effectMiscValue1`=0,
  `effectImplicitTargetA1`=1,
  `effectAmplitude1`=0,
  `effectMechanic1`=0,
  `effect2`=6,
  `effectApplyAuraName2`=9,
  `effectBasePoints2`=-11,
  `effectMiscValue2`=0,
  `effectImplicitTargetA2`=1,
  `effectAmplitude2`=0,
  `effectMechanic2`=0,
  `effect3`=0,
  `effectApplyAuraName3`=0,
  `effectBasePoints3`=0,
  `effectMiscValue3`=0,
  `effectImplicitTargetA3`=0,
  `effectAmplitude3`=0,
  `effectMechanic3`=0,
  `description`='Your head is rattled. Slowed and clumsy.',
  `auraDescription`='Your head is rattled. Slowed and clumsy.';
INSERT INTO `spell_template` SELECT * FROM _t;
DROP TEMPORARY TABLE _t;

-- 60021 Concussed
CREATE TEMPORARY TABLE _t AS SELECT * FROM `spell_template` WHERE `entry`=15007 AND `build`=5302 LIMIT 1;
UPDATE _t SET `entry`=60021,
  `build`=5302,
  `name`='Concussed',
  `spellIconId`=129,
  `durationIndex`=21,
  `mechanic`=0,
  `effect1`=6,
  `effectApplyAuraName1`=33,
  `effectBasePoints1`=-31,
  `effectMiscValue1`=0,
  `effectImplicitTargetA1`=1,
  `effectAmplitude1`=0,
  `effectMechanic1`=0,
  `effect2`=6,
  `effectApplyAuraName2`=9,
  `effectBasePoints2`=-21,
  `effectMiscValue2`=0,
  `effectImplicitTargetA2`=1,
  `effectAmplitude2`=0,
  `effectMechanic2`=0,
  `effect3`=6,
  `effectApplyAuraName3`=54,
  `effectBasePoints3`=-6,
  `effectMiscValue3`=0,
  `effectImplicitTargetA3`=1,
  `effectAmplitude3`=0,
  `effectMechanic3`=0,
  `description`='You are concussed. Badly slowed, clumsy and dazed.',
  `auraDescription`='You are concussed. Badly slowed, clumsy and dazed.';
INSERT INTO `spell_template` SELECT * FROM _t;
DROP TEMPORARY TABLE _t;

-- 60022 Knockout
CREATE TEMPORARY TABLE _t AS SELECT * FROM `spell_template` WHERE `entry`=20549 AND `build`=5302 LIMIT 1;
UPDATE _t SET `entry`=60022,
  `build`=5302,
  `name`='Knockout',
  `spellIconId`=129,
  `durationIndex`=39,
  `mechanic`=12,
  `effect1`=6,
  `effectApplyAuraName1`=12,
  `effectBasePoints1`=0,
  `effectMiscValue1`=0,
  `effectImplicitTargetA1`=1,
  `effectAmplitude1`=0,
  `effectMechanic1`=0,
  `effect2`=0,
  `effectApplyAuraName2`=0,
  `effectBasePoints2`=0,
  `effectMiscValue2`=0,
  `effectImplicitTargetA2`=0,
  `effectAmplitude2`=0,
  `effectMechanic2`=0,
  `effect3`=0,
  `effectApplyAuraName3`=0,
  `effectBasePoints3`=0,
  `effectMiscValue3`=0,
  `effectImplicitTargetA3`=0,
  `effectAmplitude3`=0,
  `effectMechanic3`=0,
  `description`='You are knocked senseless.',
  `auraDescription`='You are knocked senseless.';
INSERT INTO `spell_template` SELECT * FROM _t;
DROP TEMPORARY TABLE _t;

-- 60030 Festering Wound
CREATE TEMPORARY TABLE _t AS SELECT * FROM `spell_template` WHERE `entry`=15007 AND `build`=5302 LIMIT 1;
UPDATE _t SET `entry`=60030,
  `build`=5302,
  `name`='Festering Wound',
  `spellIconId`=1496,
  `durationIndex`=21,
  `mechanic`=0,
  `effect1`=6,
  `effectApplyAuraName1`=3,
  `effectBasePoints1`=4,
  `effectMiscValue1`=0,
  `effectImplicitTargetA1`=1,
  `effectAmplitude1`=3000,
  `effectMechanic1`=0,
  `effect2`=6,
  `effectApplyAuraName2`=118,
  `effectBasePoints2`=-21,
  `effectMiscValue2`=0,
  `effectImplicitTargetA2`=1,
  `effectAmplitude2`=0,
  `effectMechanic2`=0,
  `effect3`=0,
  `effectApplyAuraName3`=0,
  `effectBasePoints3`=0,
  `effectMiscValue3`=0,
  `effectImplicitTargetA3`=0,
  `effectAmplitude3`=0,
  `effectMechanic3`=0,
  `description`='Your wound festers. It will not close and slowly rots.',
  `auraDescription`='Your wound festers. It will not close and slowly rots.';
INSERT INTO `spell_template` SELECT * FROM _t;
DROP TEMPORARY TABLE _t;

-- 60031 Sepsis
CREATE TEMPORARY TABLE _t AS SELECT * FROM `spell_template` WHERE `entry`=15007 AND `build`=5302 LIMIT 1;
UPDATE _t SET `entry`=60031,
  `build`=5302,
  `name`='Sepsis',
  `spellIconId`=160,
  `durationIndex`=21,
  `mechanic`=0,
  `effect1`=6,
  `effectApplyAuraName1`=3,
  `effectBasePoints1`=9,
  `effectMiscValue1`=0,
  `effectImplicitTargetA1`=1,
  `effectAmplitude1`=3000,
  `effectMechanic1`=0,
  `effect2`=6,
  `effectApplyAuraName2`=118,
  `effectBasePoints2`=-41,
  `effectMiscValue2`=0,
  `effectImplicitTargetA2`=1,
  `effectAmplitude2`=0,
  `effectMechanic2`=0,
  `effect3`=6,
  `effectApplyAuraName3`=80,
  `effectBasePoints3`=-6,
  `effectMiscValue3`=-1,
  `effectImplicitTargetA3`=1,
  `effectAmplitude3`=0,
  `effectMechanic3`=0,
  `description`='Sepsis. The infection has spread into your blood.',
  `auraDescription`='Sepsis. The infection has spread into your blood.';
INSERT INTO `spell_template` SELECT * FROM _t;
DROP TEMPORARY TABLE _t;

-- 60032 Spider Venom
CREATE TEMPORARY TABLE _t AS SELECT * FROM `spell_template` WHERE `entry`=15007 AND `build`=5302 LIMIT 1;
UPDATE _t SET `entry`=60032,
  `build`=5302,
  `name`='Spider Venom',
  `spellIconId`=68,
  `durationIndex`=21,
  `mechanic`=0,
  `effect1`=6,
  `effectApplyAuraName1`=3,
  `effectBasePoints1`=6,
  `effectMiscValue1`=0,
  `effectImplicitTargetA1`=1,
  `effectAmplitude1`=3000,
  `effectMechanic1`=0,
  `effect2`=6,
  `effectApplyAuraName2`=118,
  `effectBasePoints2`=-26,
  `effectMiscValue2`=0,
  `effectImplicitTargetA2`=1,
  `effectAmplitude2`=0,
  `effectMechanic2`=0,
  `effect3`=6,
  `effectApplyAuraName3`=9,
  `effectBasePoints3`=-11,
  `effectMiscValue3`=0,
  `effectImplicitTargetA3`=1,
  `effectAmplitude3`=0,
  `effectMechanic3`=0,
  `description`='Necrotic venom courses through you, rotting flesh and wound alike.',
  `auraDescription`='Necrotic venom courses through you, rotting flesh and wound alike.';
INSERT INTO `spell_template` SELECT * FROM _t;
DROP TEMPORARY TABLE _t;

-- 60033 Rabies
CREATE TEMPORARY TABLE _t AS SELECT * FROM `spell_template` WHERE `entry`=15007 AND `build`=5302 LIMIT 1;
UPDATE _t SET `entry`=60033,
  `build`=5302,
  `name`='Rabies',
  `spellIconId`=264,
  `durationIndex`=21,
  `mechanic`=0,
  `effect1`=6,
  `effectApplyAuraName1`=3,
  `effectBasePoints1`=5,
  `effectMiscValue1`=0,
  `effectImplicitTargetA1`=1,
  `effectAmplitude1`=3000,
  `effectMechanic1`=0,
  `effect2`=6,
  `effectApplyAuraName2`=126,
  `effectBasePoints2`=4,
  `effectMiscValue2`=0,
  `effectImplicitTargetA2`=1,
  `effectAmplitude2`=0,
  `effectMechanic2`=0,
  `effect3`=0,
  `effectApplyAuraName3`=0,
  `effectBasePoints3`=0,
  `effectMiscValue3`=0,
  `effectImplicitTargetA3`=0,
  `effectAmplitude3`=0,
  `effectMechanic3`=0,
  `description`='Rabid fever grips you. You cannot bear to drink.',
  `auraDescription`='Rabid fever grips you. You cannot bear to drink.';
INSERT INTO `spell_template` SELECT * FROM _t;
DROP TEMPORARY TABLE _t;

-- 60034 Filth Fever
CREATE TEMPORARY TABLE _t AS SELECT * FROM `spell_template` WHERE `entry`=15007 AND `build`=5302 LIMIT 1;
UPDATE _t SET `entry`=60034,
  `build`=5302,
  `name`='Filth Fever',
  `spellIconId`=163,
  `durationIndex`=21,
  `mechanic`=0,
  `effect1`=6,
  `effectApplyAuraName1`=80,
  `effectBasePoints1`=-6,
  `effectMiscValue1`=-1,
  `effectImplicitTargetA1`=1,
  `effectAmplitude1`=0,
  `effectMechanic1`=0,
  `effect2`=0,
  `effectApplyAuraName2`=0,
  `effectBasePoints2`=0,
  `effectMiscValue2`=0,
  `effectImplicitTargetA2`=0,
  `effectAmplitude2`=0,
  `effectMechanic2`=0,
  `effect3`=0,
  `effectApplyAuraName3`=0,
  `effectBasePoints3`=0,
  `effectMiscValue3`=0,
  `effectImplicitTargetA3`=0,
  `effectAmplitude3`=0,
  `effectMechanic3`=0,
  `description`='Filth fever weakens you. Nausea turns your stomach.',
  `auraDescription`='Filth fever weakens you. Nausea turns your stomach.';
INSERT INTO `spell_template` SELECT * FROM _t;
DROP TEMPORARY TABLE _t;

-- 60035 Marsh Fever
CREATE TEMPORARY TABLE _t AS SELECT * FROM `spell_template` WHERE `entry`=15007 AND `build`=5302 LIMIT 1;
UPDATE _t SET `entry`=60035,
  `build`=5302,
  `name`='Marsh Fever',
  `spellIconId`=543,
  `durationIndex`=21,
  `mechanic`=0,
  `effect1`=6,
  `effectApplyAuraName1`=80,
  `effectBasePoints1`=-6,
  `effectMiscValue1`=-1,
  `effectImplicitTargetA1`=1,
  `effectAmplitude1`=0,
  `effectMechanic1`=0,
  `effect2`=6,
  `effectApplyAuraName2`=3,
  `effectBasePoints2`=4,
  `effectMiscValue2`=0,
  `effectImplicitTargetA2`=1,
  `effectAmplitude2`=3000,
  `effectMechanic2`=0,
  `effect3`=6,
  `effectApplyAuraName3`=33,
  `effectBasePoints3`=-11,
  `effectMiscValue3`=0,
  `effectImplicitTargetA3`=1,
  `effectAmplitude3`=0,
  `effectMechanic3`=0,
  `description`='Marsh fever burns and chills you by turns.',
  `auraDescription`='Marsh fever burns and chills you by turns.';
INSERT INTO `spell_template` SELECT * FROM _t;
DROP TEMPORARY TABLE _t;

-- 60036 The Plague
CREATE TEMPORARY TABLE _t AS SELECT * FROM `spell_template` WHERE `entry`=15007 AND `build`=5302 LIMIT 1;
UPDATE _t SET `entry`=60036,
  `build`=5302,
  `name`='The Plague',
  `spellIconId`=160,
  `durationIndex`=21,
  `mechanic`=0,
  `effect1`=6,
  `effectApplyAuraName1`=3,
  `effectBasePoints1`=11,
  `effectMiscValue1`=0,
  `effectImplicitTargetA1`=1,
  `effectAmplitude1`=3000,
  `effectMechanic1`=0,
  `effect2`=6,
  `effectApplyAuraName2`=118,
  `effectBasePoints2`=-41,
  `effectMiscValue2`=0,
  `effectImplicitTargetA2`=1,
  `effectAmplitude2`=0,
  `effectMechanic2`=0,
  `effect3`=6,
  `effectApplyAuraName3`=80,
  `effectBasePoints3`=-8,
  `effectMiscValue3`=-1,
  `effectImplicitTargetA3`=1,
  `effectAmplitude3`=0,
  `effectMechanic3`=0,
  `description`='The Plague rots you from within, and it is worsening.',
  `auraDescription`='The Plague rots you from within, and it is worsening.';
INSERT INTO `spell_template` SELECT * FROM _t;
DROP TEMPORARY TABLE _t;

-- End of migration.
END IF;
END??
DELIMITER ;
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
