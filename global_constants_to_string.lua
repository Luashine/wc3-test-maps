-- returns a function that will pretty print the passed variable
-- that is defined as a constant in _G, whose name begins with
-- <namespace>
-- Example: prettyStringGameType = wc3ConstantToStringFactory("GAME_TYPE_")
-- Usage of created function: print(prettyStringGameType(GetGameTypeSelected()))
function wc3ConstantToStringFactory(namespace)
	local constants = {}
	local pattern = "^" .. namespace -- if const name begins with...
	for name, const in pairs(_G) do -- non-deterministic
		if name:match(pattern) then
			--print("Adding: ".. tostring(name) .."=".. tostring(const))
			local shortName = (name:gsub(namespace, ""))
			if shortName == "" then
				shortName = namespace
			end
			
			table.insert(constants, 
				{name = name, 
				value = const,
				shortName = shortName}
			)
			--print("shortName = ", shortName)
		end
	end
	
	return function(userValue)
		local strings -- lazy init
		for i = 1, #constants do
			local const = constants[i]
			
			if userValue == const.value then
				--print("Adding", userValue, const.value, const.shortName)
				strings = strings or {}
				table.insert(strings, const.shortName)
			else
				--print("Not adding", userValue, const.value, const.shortName)
			end
		end
		if strings then
			return table.concat(strings)
		else
			return "UNKNOWN!"
		end
	end
end
