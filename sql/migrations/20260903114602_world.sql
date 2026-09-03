DROP PROCEDURE IF EXISTS add_migration;
DELIMITER ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20260903114602');
IF v = 0 THEN
INSERT INTO `migrations` VALUES ('20260903114602');
-- AzerothLife 2.0b fix: give wound auras FINITE durations so they recover.
-- Bug: 60010-60012 (Bleed) and 60020/60021 (Concussion) shipped with
-- durationIndex 21 = -1 (infinite), so their auras never expired and
-- Unit::UpdateWounds (which de-escalates only when !HasAura) never fired --
-- wounds were permanent, breaking wounds.md D4 natural recovery. Knockout
-- (60022, index 39 = 2s) and the disease auras (managed by the disease state
-- machine, meant to persist until cured) are intentionally left as-is.
-- SpellDuration.dbc indices: 8=15s, 22=45s, 3=60s, 2=30s.
UPDATE `spell_template` SET `durationIndex`=8  WHERE `entry`=60010 AND `build`=5302; -- Minor Bleed 15s
UPDATE `spell_template` SET `durationIndex`=22 WHERE `entry`=60011 AND `build`=5302; -- Deep Wound 45s
UPDATE `spell_template` SET `durationIndex`=3  WHERE `entry`=60012 AND `build`=5302; -- Hemorrhage 60s
UPDATE `spell_template` SET `durationIndex`=2  WHERE `entry`=60020 AND `build`=5302; -- Rattled 30s
UPDATE `spell_template` SET `durationIndex`=22 WHERE `entry`=60021 AND `build`=5302; -- Concussed 45s
-- End of migration.
END IF;
END??
DELIMITER ;
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
