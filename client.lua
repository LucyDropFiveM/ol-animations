-- functions

Notification = function (msg)
    AddTextEntry('Notification', msg)
    SetNotificationTextEntry('Notification')
    DrawNotification(false, true)
end

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

function Split(s, delimiter)
	result = {};
	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match);
	end
	return result;
end

-- Code


local data = LoadResourceFile(GetCurrentResourceName(), 'animations.txt')
local split_string = Split(data, " ")
local index = 1
local dictionary = split_string[index]
local animName = split_string[index+1]

local stop = false

dictionary = string.gsub(dictionary, "%s+", "")
animName = string.gsub(animName, "%s+", "")

RegisterCommand('testanim', function() -- if you want to test animatons manually
	ClearPedTasks(PlayerPedId())
	
	print(dictionary, animName)
	LoadDict(dictionary)
	
	TaskPlayAnim(PlayerPedId(), dictionary, animName, 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)

	local msg = dictionary..''..animName
	Notification(msg)
	
	index = index + 2
	dictionary = split_string[index]
	animName = split_string[index+1]
	dictionary = string.gsub(dictionary, "%s+", "")
	animName = string.gsub(animName, "%s+", "")
end)

RegisterCommand('testanim2', function() -- if you want to test animatons automatically
	local data = LoadResourceFile(GetCurrentResourceName(), 'animations.txt')
	local split_string = Split(data, " ")
	local position = GetEntityCoords(PlayerPedId())
	for i=1, #split_string, 2 do
		if stop then
			i = #split_string
			ClearPedTasks(PlayerPedId())
			return
		end
		SetEntityCoordsNoOffset(PlayerPedId(), position.x, position.y, position.z, 1, 1, 1)
		ClearPedTasks(PlayerPedId())
		local dictionary = split_string[i]
		local animName = split_string[i+1]
		dictionary = string.gsub(dictionary, "%s+", "")
		animName = string.gsub(animName, "%s+", "")

		LoadDict(dictionary)
		TaskPlayAnim(PlayerPedId(), dictionary, animName, 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)

		print(dictionary, animName)
		local msg = dictionary..''..animName
		Notification(msg)
		Citizen.Wait(3000)
	end
end)

RegisterCommand('testanimstop', function()
	stop = true
end)


