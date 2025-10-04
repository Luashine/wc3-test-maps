# Does the 'ability' type need a destructor?

Version tested: **2.0.3.23101**

TLDR: No. It's tied to the unit / item lifecycle. If you Remove the unit/item, eventually (in Lua) the corresponding abilities will be removed too.

```
constant native GetSpellAbility takes nothing returns ability
native LoadAbilityHandle takes hashtable table, integer parentKey, integer childKey returns ability
native BlzGetUnitAbility takes unit whichUnit, integer abilId returns ability
native BlzGetUnitAbilityByIndex takes unit whichUnit, integer index returns ability
native BlzGetItemAbilityByIndex takes item whichItem, integer index returns ability
native BlzGetItemAbility takes item whichItem, integer abilCode returns ability
function LoadAbilityHandleBJ takes integer key, integer missionKey, hashtable table returns ability
```

All of these return an ability instance. Do they still need a destructor? Turns out, no.
The test code uploaded here (`ability-destructor-reusage-test.lua`) showcases how it works with GC.

1. Create Unit and retrieve an ability as an `ability` object.
2. Record the ability handle ID, dismiss the object.
3. Wait until this userdata object (pointer) is removed by GC.
4. Retrieve the handle ID again. Another pointer/userdata object, but the underlying `GetHandleId` stays the same
5. Remove the unit and all references to it. Wait some time for GC to clear up the references.
6. Now create some dummy handles (Locations) to prove/disprove ID reusage, we should encounter `ability`'s handle ID reuse eventually.
7. Yes, we do. One of the dummy locations occupies the same Handle ID as the ability had previously.

QED: when a unit (item?) is freed, the corresponding abilities are eventually removed and freed
and thus we observe through ID reusal that everything had been freed without leaking anything.
