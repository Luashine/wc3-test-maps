# GetSummonedUnit and Events

Functions:

- GetSummonedUnit
- GetSummoningUnit
- GetTriggerUnit

Events:

- EVENT_PLAYER_UNIT_SUMMON
- EVENT_UNIT_SUMMON

Using Eikoniums Debug Utils map as a base (print func). Map attached here.

## Results

EVENT_PLAYER_UNIT_SUMMON:

PlayerUnitEvent: summoned/trigger unit == summoned unit; summoning = actual summoner

EVENT_UNIT_SUMMON:

UnitEvent: summoned = nil and trigger unit/summoning = caster

## Code

```lua
do
    FCC = {}
    local p, u, m, b = string.pack, string.unpack, string.match, string.byte
    function FCC.to(int)
        return m(p(">I4", int), "[^\0]+")
    end
    -- very fast
    function FCC.from4(str)
        return (u(">I4", str))
    end
    function FCC.from(str)
        local n = 0
        local len = #str
        for i = len, 1, -1 do
            n = n + (b(str, i, i) << 8*(len-i))
        end
        return n
    end
end



function GetSummonedUnitSetup()
	local FilterTrue = Filter( function() return true end )

	wizardUnit = CreateUnit(Player(0), FourCC'Oshd', -200, 0, 0)

	triggerPlayerUnitEv = CreateTrigger()
	TriggerAddAction(triggerPlayerUnitEv, TriggerPlayerUnitEventAction_summoned)
	TriggerRegisterPlayerUnitEvent(triggerPlayerUnitEv, Player(0), EVENT_PLAYER_UNIT_SUMMON, FilterTrue)

	triggerUnitEv = CreateTrigger()
	TriggerAddAction(triggerUnitEv, TriggerUnitEventAction_summoned)
	TriggerRegisterUnitEvent(triggerUnitEv, wizardUnit, EVENT_UNIT_SUMMON)

end

function TriggerPlayerUnitEventAction_summoned()
	TriggerUnitAction_summoned("PlayerUnitEvent")
	return true
end
function TriggerUnitEventAction_summoned()
	TriggerUnitAction_summoned("UnitEvent")
	return true
end

function TriggerUnitAction_summoned(triggerType)
	local summoned = GetSummonedUnit()
	local summonedRawcode = GetUnitTypeId(summoned) and FCC.to(GetUnitTypeId(summoned)) or "nil"
	local summonedName = summoned and GetUnitName(summoned) or "nil"

	local summoner = GetSummoningUnit()
	local summonerRawcode = GetUnitTypeId(summoner) and FCC.to(GetUnitTypeId(summoner)) or "nil"
	local summonerName = summoner and GetUnitName(summoner) or "nil"

	local causer = GetTriggerUnit()
	local causerRawcode = GetUnitTypeId(causer) and FCC.to(GetUnitTypeId(causer)) or "nil"
	local causerName = causer and GetUnitName(causer) or "nil"
	local spellId = GetSpellAbilityId() or "nil"
	print(tostring(triggerType) ..": GetSummonedUnit is: '".. summonedName .."' (".. summonedRawcode ..") and GetTriggerUnit is: '".. causerName .."' (".. causerRawcode ..") and Summoning: '".. summonerName .."' and spellId: ".. spellId)
end
```
