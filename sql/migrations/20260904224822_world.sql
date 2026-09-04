-- AzerothLife Survival v0.1 — gathering content (Kindling + Firewood nodes).
-- World migration. Timestamp assigned when placed into core/sql/migrations.
-- Depends on al_survival_node (created by the C++ agent's schema migration); a
-- defensive CREATE TABLE IF NOT EXISTS mirrors that schema so apply-order is safe.
-- NOT applied to any live DB here — placed + applied at deploy.
DROP PROCEDURE IF EXISTS add_migration;
DELIMITER ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20260904224822');
IF v = 0 THEN
INSERT INTO `migrations` VALUES ('20260904224822');

-- Defensive: same schema the C++ agent creates. No-op if it already exists.
CREATE TABLE IF NOT EXISTS `al_survival_node` (
  `go_entry` int(10) unsigned NOT NULL,
  `required_skill` int(10) unsigned NOT NULL DEFAULT 0,
  `red_level` int(10) unsigned NOT NULL DEFAULT 0,
  `skill_gain` int(10) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`go_entry`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='AzerothLife Survival gather nodes';

-- ---- Items (trade goods). Icons: 928 = sycamore branch, 929 = bundle of wood.
-- Kindling = Poor (grey), Firewood = Common (white): a visible quality step.
INSERT INTO `item_template`
  (`entry`,`class`,`subclass`,`name`,`description`,`display_id`,`quality`,
   `buy_price`,`sell_price`,`inventory_type`,`item_level`,`stackable`) VALUES
  (90001, 7, 0, 'Kindling',  'Dry twigs and thin branches, good for starting a fire.', 928, 0, 0, 1, 0, 1, 20),
  (90002, 7, 0, 'Firewood',  'A bundle of split logs, proper fuel for a lasting fire.', 929, 1, 0, 5, 0, 5, 20);

-- ---- Gathering nodes (GO type 3 CHEST, lockId 0 = server hook gates by Survival).
-- displayId 760 = stick bundle (kindling), 199 = firewood pile (firewood).
-- data1 = lootId (keyed into gameobject_loot_template), data3 = 1 (consumed on loot).
INSERT INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`size`,`data1`,`data3`) VALUES
  (900001, 3, 760, 'Kindling', 1.0, 900001, 1),
  (900002, 3, 199, 'Firewood', 1.0, 900002, 1);

-- ---- Node loot (100% the tier's wood, 1-2 per gather).
INSERT INTO `gameobject_loot_template`
  (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`,`patch_min`,`patch_max`) VALUES
  (900001, 90001, 100, 0, 1, 2, 0, 0, 10),
  (900002, 90002, 100, 0, 1, 2, 0, 0, 10);

-- ---- Survival gating: node -> required Survival + grey level (+ gain multiplier).
INSERT INTO `al_survival_node` (`go_entry`,`required_skill`,`red_level`,`skill_gain`) VALUES
  (900001, 1,  100, 1),   -- Kindling: Survival 1+, greys at 100
  (900002, 75, 175, 1);   -- Firewood: Survival 75+, greys at 175

-- ---- Pools (native): max_limit = how many nodes active at once among all their
-- spawn points. Spawn points (pool_gameobject rows) are added AFTER the GM places
-- them in-game; these empty pools are ready to receive members.
INSERT INTO `pool_template` (`entry`,`max_limit`,`description`,`flags`,`instance`,`patch_min`,`patch_max`) VALUES
  (43848, 15, 'Survival Kindling - Elwynn', 0, 0, 0, 10),
  (43849, 10, 'Survival Firewood - Elwynn', 0, 0, 0, 10);

END IF;
END??
DELIMITER ;
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
