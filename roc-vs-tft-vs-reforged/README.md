# ROC-vs-TFT-vs-Reforged

**TLDR:** ROC v1.07 does not exist. And it does exist. It's a frankenstein.
ROC 1.10\*, TFT 1.10 (1.07->1.10) are real but never distributed as standalone patches, only as online updates from bnet.
PVPGN servers from that time are our only source of the patch.

Note, ROC 1.10 is probably still a ROC+TFT frankenstein, but it has a separate "War3patch.mpq" of its own.

*1.07/1.10 ROC doesn't load correctly (black screen in main menu, only version shown) if you delete the war3x.mpq and war3xlocal.mpq. ROC v1.11 patch restores the ROC-only install. QED.*

- IsROCReforged uses a 1.32 Reforged native in code (injected)
- IsROCTFT uses a 1.07 TFT native (injected)
- IsROCVanilla is a control, created using a TFT 1.07 GUI Trigger but saved as ROC map
   - Using "Custom Script" in GUI would automatically mark the map as Expansion-only


## Result

After installing TFT from CD, both ROC and TFT show the v1.07 game version. However there's no "war3patch.mpq" that's supposed to be patching ROC.

Checking with Procmon, it is apparent that even launching ROC (from a ROC/TFT install) loads war3x.mpq and war3xlocal.mpq -- indicating that the "ROC" version is loading some parts from the Expansion archives. We need to go deeper.

Therefore I made 3 maps to find out which `common.j` code is being loaded. Both ROC and TFT load the TFT's common.j file, so IF you had installed TFT, it'd be possible to run newer natives and code from TFT while playing in ROC mode.
Of course this means that pure ROC players would crash on this map, as indicated by "IsROCReforged" that's coming up as invalid map code for both ROC and TFT (no lobby setup).

- IsROCReforged: invalid code for ROC, TFT (expected)
- IsROCTFT: can be run both ROC 1.07 and TFT 1.07 (expected ROC to crash)
- IsROCVanilla: can be run both ROC 1.07 and TFT 1.07 (as expected)

## What is ROC 1.07

I said it's a frankenstein and I stand by it.

[**Patch 1.12**](https://warcraft.wiki.gg/wiki/Warcraft_III/Patch_1.12)

> The multiplayer custom map desync that occurs between Reign of Chaos and Frozen Throne players has been fixed.

It'd be nigh impossible for maps at the time to use TFT natives and keep the map in ROC format.
So my interpretation of the above is: "Players that only own ROC and those with ROC+TFT are playing the ROC game.
When they meet to play a ROC map, they would desync".
This screams like loaded game data mismatch (supporting my "frankenstein" assertion) where ROC+TFT players would load game data
tainted by the war3x.mpq/war3xlocal.mpq patches, that are **not** supposed to touch ROC.

It is no mistake that the description of the [1.07](https://warcraft.wiki.gg/wiki/Warcraft_III/Patch_1.07)
patch says nothing more than *"Patch 1.07 is the gold master version of The Frozen Throne."*

If you read further patch notes, it's apparent that to some extent Blizzard handled ROC and TFT as separate games
(balance updates were separate), but some parts were updated in tandem. For purposes of history tracking and
diffing, it's better to **handle ROC 1.07 as not existing** and the further versions to be diverging ROC & TFT branches.

What about inofficial 1.10 patches? I don't even know what happened around there. Did Blizzard ship 1.10 as a bnet-only update?
There sure weren't standalone patches, only for 1.11. But the patch notes say 1.10 was a big planned update.
That's probably why there's no standalone patch for WC3 ROC, because only TFT players received it over bnet?

## The 1.10 Patch

It's a custom made installer of the TFT patch (apply on top of 1.07). It says:

> This patch upgrades Warcraft IIIX from version 1.07 to version 1.10.

> Brought to u by AmAdEuS
> www.world-of-amadeus.de
> ...
> Patch applied successfully
> visit
> www.world-of-amadeus.de
> www.pvpgn.de
> www.pvpgn-europe.de
>  for future updates...

Here's your motivation for the patch. Non-official bnet servers! :)

Why is there apparently a Russian patch? The website tells us:

> B@le.net (Europe/Korea/USA) Ladder-Stats 	w3.battle.net 	WC3 & D2 & SC
> Ender (USA) 	216.89.228.18 	official PvPGN TestServer
> youxia 	202.101.165.145 	WarCraft III
> XC_ONLINE D2CS Server (China) 	61.139.54.70 	WC3 & D2
> Purga.Net (Russia) 	195.58.6.10 	WC3 & D2 & SC
> Ptath's (Russia) 	217.23.91.4 	WC3 & D2

The community was well connected.

It launches the official Blizzard Updater v2.64 and also has proper patch notes embedded.
While it is "unofficial", it's based on official data!

Similarly to 1.07, ROC menu shows 1.10.

```
--------------------------------------------------------------------------
  WARCRAFT III VERSION HISTORY
--------------------------------------------------------------------------
- PATCH 1.10
--------------------------------------------------------------------------

THE FROZEN THRONE SPECIFICS

FEATURE INFORMATION

- Further information regarding modifying hotkeys can be found in your
  Warcraft III installation directory.

MAPS

- Numerous maps have had minor improvements made to them.

BALANCE CHANGES

Human
- Lumber Mill cost reduced to 120 from 145.
- Lumber upgrade now gives +10 lumber capacity per level of the upgrade, up
  from +5 lumber capacity per level of the upgrade.
- Human masonry upgrade cost reduced to 100/25, 125/50 and 150/75 from 100/100,
  125/175, 175/250.
- Guard Towers and Arcane Towers now cost 70/50 to upgrade, down from 80/60.
- Mortar Teams now have a limitless supply of flares. However, a particular
  Mortar Team can only use a flare once per 2 minutes.
- Flying Machine damage versus air increased to 12-13 from 7-8.
- Gryphon Aviary cost changed to 140/150 from 120/240.
- Gryphon Aviaries now require a Keep instead of a Castle. However, both the
  Cloud upgrade and Gryphon Riders require a Castle to access.
- Dragonhawk Riders are now correctly a level 3 unit instead of a level 5 unit.
  This only impacts the experience gained when they are killed.
- Dragonhawk Rider build time reduced to 30 from 45.
- Spell Breaker hit points reduced to 600 from 650.
- Spell Breaker armor type changed to Medium.
- Mana cost of Spell Steal increased to 75.
- Scroll of Regeneration now heals 225 hit points over its 45 second duration,
  up from 150 hit points.
- Thunder Clap damage reduced to 60/100/140 from 70/110/150.
- Orb of Fire cost reduced to 375 from 400 and splash radius increased to 140
  from 125.
- Priest heal effect increased to 25 hit points per cast, up from 20; Priest
  heal mana cost increased to 5 from 4.
- Sorceress damage increased to 10-12 from 8-10.
- Powerbuild has been improved. Each additional Peasant contributes 60% of
  the speed of the first, up from 50%.

Undead
- Crypt Fiend damage reduced from 28-33 to 26-31.
- Burrowed Crypt Fiends now heal 5 hp/sec down from 10 hp/sec.
- Ghoul hit points upgraded to 340 from 330.
- Orb of Corruption cost was reduced to 375 from 400, and its armor decrease
  has gone to 5 from 4.
- Rod of Necromancy cooldown increased from 15 to 22.
- Carrion Swarm max damage reduced to 300/600/1000 from 375/700/1000 and
  damage per target reduced to 75/125/200 from 100/150/200.
- Impale area of effect width reduced to 250 from 300.
- Gargoyles now require Halls of the Dead instead of Black Citadel.
- Obsidian Statue Spirit Touch now replenishes 4 mana per casting, down from 5.
- Obsidian Statue Aura of Blight effect reduced to 10 hp/sec from 12 hp/sec.
- Boneyard cost changed to 175/200 from 125/250.
- Halls of the Dead and Black Citadel deal one quarter as much damage as
  previously, but now possess a frost attack similar to that of Nerubian Towers.
- Nerubian Tower damage reduced to 1d2 + 8 from 1d2 + 10.
- The Tomb of Relics now sells Dust of Appearance, but no longer sells
  Lesser Clarity Potions.
- Devour Magic now heals 50 hit points per spell devoured, up from 25, and
  restores 75 mana, up from 50.
- Destroyer damage reduced to 19-21 from 21-24.
- Frost Wyrm damage increased to 93-115 from 85-105.

Orc
- Demolisher damage reduced from 82-102 to 76-94.
- Kodo Beasts are now Unarmored.
- Raiders now have a base armor of 1, up from 0.
- Ensnare duration increased to 15 from 12, and range increased to 500 from 400.
- Shockwave area of effect width reduced to 250 from 300.
- Chain Lightning base damage reduced to 85/125/180 from 100/140/180.
- Feral Spirit mana cost reduced to 75 from 100 and cooldown increased to 25
  from 15.
- Tauren Chieftain speed increased to 270 from 250.
- The Tauren Chieftain now has a smaller collision size: 32 down from 48.
  This means that he takes up less space on the ground.
- Purge has been improved. It no longer slows friendly units when used on
  them, and it causes enemies to stop for a brief moment when first cast (in
  addition to slowing them later).
- Wind Riders no longer require a Fortress to be built.
- Wind Rider damage reduced to 36-44 from 39-47.
- Wind Rider poison now deals 4 damage a second, up from 3.3 damage a second.
- Wind Rider speed reduced to 320 from 350.
- Tauren Totem cost changed to 135/155 from 90/200.
- Orb of Lightning cost reduced to 375 from 400.
- The Voodoo Lounge now sells Lesser Clarity Potions, but no longer sells Dust
  of Appearance.
- Spirit Link mana cost reduced to 75 from 100.
- Mirror Image cost reduced to 125 from 150.
- Blademaster's base Agility increased to 24 from 23.

Night Elf
- Entangle duration versus Heroes reduced to 3/4/5 from 3/5/7.
- Fan of Knives maximum damage reduced to 300/625/950 from 350/675/950, and
  damage per target reduced to 75/120/180 from 90/135/180.
- Chimaera splash increments reduced by 50 for quarter, 25 for half. This
  effectively means that Chimaeras will do less splash damage than previously.
- Mana Flare has had a bug fixed that was preventing multiple Mana Flares from
  attacking multiple targets at the same time. As a result, Mana Flare has
  been rebalanced, and deals up to 90 damage to targets in a 250 area when a
  unit casts a spell, down from 125 damage.
- Archer hit points reduced to 240 from 310.
- Archers now have a new passive ability, Elune's Grace. This ability grants
  them 35% damage reduction against Piercing attacks, and 20% damage reduction
  against spells.
- Hippogryph Rider hit points decreased to 765 from 835 and armor increased to
  1 from 0.
- Dryad damage increased from 15-17 to 16-18.
- Mountain Giant base armor increased to 4 from 0 and hit points increased to
  1600 from 1400.
- Hardened Skin upgrade cost reduced to 100/175 from 100/250, and damage
  reduction reduced to 12 from 15.
- Chimaera Roost cost changed to 140/190 from 100/230.
- Orb of Venom cost reduced to 375 from 400 and poison damage/sec increased
  to 7 from 6.

Neutral Buildings, Units, and Heroes
- Forked Lightning damage reduced to 85/160/250 from 100/175/250.
- Tornado now deals 7 damage a second to buildings in its general vicinity
  (down from 10) and 50 damage to buildings it is over (down from 80), and
  it now costs 250 mana to cast, up from 150.
- Silence area of effect increased from 150/250/350 to 200/275/350.
- Mercenaries cost 25% more gold than previously.
- Mud Golem availability delayed to second day.
- Summoned Doom Guard hit points increased to 1600 from 1350.
- Howl of Terror % damage reduction increased by 5% at all levels.
- Zeppelin hit points increased to 575 from 500.
- Forest Troll Shadow Priests have had their starting availability delayed
  by 60 seconds to 120 seconds.
- The Beastmaster now has a smaller collision size: 32 down from 48.
  This means that he takes up less space on the ground.

Items
- Scroll of Restoration is now a level 5 item instead of a level 6 item.

Other
- Town Portal now takes 5 seconds to activate, up from 3.
- Units killed in a transport will "spill out" over a wider area. This means
  that surrounding a webbed transport and killing it will generally not kill
  the passengers.
- Tavern instant revive costs three times more lumber than previously.
- Heroes revived at the Tavern now are brought back to life with 0 mana and
  50% health.
- Tier 3 town halls all cost 20 lumber and 20 gold less.
- At tiers 2 and 3, a player who owns only one Hero (dead Heroes count) will
  gain bonus experience. This bonus is 10% at tier 2, and 20% at tier 3.
  This affects all experience gain--both from killing creeps and enemy units.

REIGN OF CHAOS SPECIFICS

MAPS

- All multiplayer maps that were shipped with the original product have
  been patched to have improved item drop tables.
- Some maps have been additionally improved with other minor enhancements.
- Tranquil Paths now has random creeps.

BALANCE CHANGES

Humans
- Devotion Aura now gives 1.5/3/4.5 armor per level.
- Powerbuild effectiveness has been reduced to 60% of its previous strength
  in terms of how much speed additional Peasants add when supporting the
  construction of a building. Note that the cost increase per additional
  Peasant is unchanged.
- Thunder Clap damage reduced to 60/100/140 from 70/110/150.
- Gyrocopter damage increased to 27-32 from 25-30.

Undead
- Shade speed increased to 350 from 270, but hit points reduced to 125
  from 250.
- Animate Dead's duration reduced to 40 from 120, cooldown reduced from
  180 to 240. Additionally, animated units are invulnerable, but can
  still be dispelled.
- Death Pact and Dark Ritual can now be used on invulnerable units.
- Carrion Swarm max damage reduced to 300/600/1000 from 375/700/1000 and
  damage per target reduced to 75/125/200 from 100/150/200.
- Halls of the Dead and Black Citadel attack cooldown is now 2 seconds
  up from 1 second, and their damage has been reduced by 33% as well
- Gargoyle attack versus air decreased to 1d11 + 43 from 1d13 + 50 to
  reflect new air pathing changes.

Orcs
- Wind Walk now has a cooldown of 5 seconds, costs 75 mana at all levels
  (changed from 100/75/25), and deals "backstab" damage. When a Blademaster
  attacks while using Wind Walk, he deals bonus damage to his victim.
- Lightning Shield range increased to 600 from 500.
- Ensnare duration increased to 15 from 12, and range increased to 500
  from 400.
- Feral Spirit mana cost reduced to 75 from 100 and cooldown increased to
  25 from 15.
- Shockwave area of effect width reduced to 250 from 300.
- Chain Lightning base damage reduced to 85/125/180 from 100/140/180.
- Tauren Chieftain speed increased to 270 from 250.
- The Tauren Chieftain now has a smaller collision size: 32 down from 48.
  This means that he takes up less space on the ground.
- Wyvern hit points increased to 600 from 500.
- Wyvern poison now lasts 25 seconds and deals 4 damage a second.
- Headhunter cooldown reduced to 2.26 from 2.34.
- Berserker Strength now requires a Stronghold instead of a Fortress.
- Mirror Image cost reduced to 125 from 150.

Night Elves
- Dryad damage increased from 15-17 to 16-18.
- Entangle now prevents an affected unit from attacking, and interrupts
  channeling spells such as Blizzard and Starfall. However, its duration
  has been reduced to 12(3)/24(4)/36(5) (unit(Hero)).
- Treants created by Force of Nature now benefit from the Nature's Blessing
  upgrade.
- Mana Burn cooldown is now 7/6/5 seconds by level, down from 7/7/7 seconds
  by level.
- Tranquility cooldown reduced to 60 from 120.
- Tranquility mana cost reduced to 125 from 200.
- Cyclone no longer affects mechanical units.
- Rejuvenation can now be cast on units at full health.
- Ancients now attack while rooted.
- Hippogryph attack decreased from 1d9 + 37 to 1d7 + 31 to reflect new
  air pathing changes.
- Chimaera splash increments reduced by 50 for quarter, 25 for half. This
  effectively means that Chimaeras will do less splash damage than previously.

Items
- Items have been revamped with new level tables. Items now have a level
  from 1 to 8, along with one of several categories. Items of levels 1 to 6
  can be charged items, permanent items, or powerups. Items of level 7 or
  higher are artifacts.
  Examples: Wand of Lightning Shield (charged), Stone Token (charged), Ring
  of Protection +2 (permanent), Tome of Strength +2 (powerup), Mask of Death
  (artifact).
- You can now sell items at the Goblin Merchant by right-clicking on an item,
  and then "dropping" it onto a Goblin Merchant.
- Scroll of Town Portal now takes 5 seconds to use. During this time it is
  being "channeled", and the Hero using it cannot be attacked or stunned.
  Under no circumstances can the town portal be aborted once started.
- Wand of Illusion can no longer be cast on hostile units. This change was
  made to prevent players from cheesing high level creep camps by using Wand
  of Illusion on high level creeps, and then using this illusionary creep to
  tank the damage.
- Boots of Speed no longer stack: two Boots of Speed will make a Hero just
  as fast as one.

Other
- When "attack-moving", air units now prefer to attack other air units more
  often than previously.
- Creeps that are not in combat now ignore flying units. This means that if
  you move flying units around using "move" instead of "attack move", creeps
  will generally not attack them.
- Creeps can no longer be dragged via constant attacks--they eventually give
  up and return to their start location.
- Goblin Sappers now deal 750 damage to buildings, 250 damage to all units,
  and 185 damage to Heroes. These values are reduced by armor values such as
  '5 armor', but do not interact with armor types (e.g. 'Medium armor').
- Units in a transport over ground will "spill out" over a wider area. This
  means that surrounding a webbed transport and killing it will generally
  not kill the passengers.

NOTES: Replays are incompatible between major game revisions. (1.07 replays
cannot be viewed with the 1.10 version of Warcraft III.) Custom save games will
not load from version 1.07.
```

Followed by 1.06 release notes.

In ROC 1.10 it is possible to queue rally points as indicated by [online patch notes](https://warcraft.wiki.gg/wiki/Warcraft_III/Patch_1.10):

> Rally points can now be given waypoints to avoid running into creep camps while rallying new units.

## Further digging

Names: https://web.archive.org/web/20030415153717/http://www.world-of-amadeus.de:80/pvpgn-stats/index.php
Files: https://web.archive.org/web/20030828124604/http://www.world-of-amadeus.de:80/files.html

> BNFTP: (to receive the autoupdate-mpqs from blizzard and add them to your server)
> "bnftp-package.exe"
