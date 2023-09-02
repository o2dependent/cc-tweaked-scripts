CHEST_ROW = {"minecraft:deepslate","minecraft:deepslate","minecraft:deepslate","minecraft:deepslate","minecraft:deepslate","minecraft:deepslate","minecraft:deepslate","minecraft:deepslate"}

print('packaged installed via github')
print('packaged loaded')
modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(43) -- Open 43 so we can receive replies

-- Send our message
modem.transmit( 43,1, "Hello, world!")

--- --- FUNCTIONS --- ---
function getChestData()
	print("Pulling chest data")
	local chestData = {}
	local chest = peripheral.find("minecraft:chest")
	print(chest)
	local chestItems = chest.list()
	for i, v in pairs(chestItems) do
		local name = v.name
		local count = v.count
		if (chestData[name]) then
			chestData[name] = chestData[name] + count
		else
			chestData[name] = count
		end
	end
	print("Sending chest data")
	return chestData
end

function getAllChestData()
	allChestData = {}
	allChestErrors = {}
	for i, CHEST_NAME in pairs(CHEST_ROW) do
		print("Getting chest data for " .. CHEST_NAME)
		if (not (i == 1)) then
			turtle.turnLeft()
			turtle.forward()
			turtle.turnRight()
		end
		local chestData = getChestData()
		if (allChestData[CHEST_NAME]) then
			for k, v in pairs(chestData) do
				if (allChestData[CHEST_NAME][k]) then
					allChestData[CHEST_NAME][k] = allChestData[CHEST_NAME][k] + v
				else
					allChestData[CHEST_NAME][k] = v
				end
			end
		else
			allChestData[CHEST_NAME] = chestData
		end

		print(textutils.serialize(chestData))

		-- check if there are any items that do not have CHEST_NAME as a key
		for k, v in pairs(chestData) do
			if (not (allChestData[CHEST_NAME][k])) then
				allChestErrors[k] = true
			else
				allChestErrors[k] = false
			end

		end
	end

	turtle.turnRight()
	for i, _ in ipairs(CHEST_ROW) do
		turtle.forward()
	end

	turtle.turnLeft()
	print(textutils.serialize(allChestData))
	local chestDataString = textutils.serialize(allChestData)
	modem.transmit(1, 43, chestDataString)
end

--- --- HANDLERS --- ---
-- handle modem messages
function modemMessageHandler(data)
	local event, side, channel, replyChannel, message, distance = table.unpack(data)

	if (channel == 43) then
		getAllChestData()
	end
end

--- --- MAIN --- ---
while true do
	local eventData = {os.pullEvent()}
	local event = eventData[1]

	if event == "modem_message" then
		modemMessageHandler(eventData)
	end
end
