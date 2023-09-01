print('packaged installed via github')
print('packaged loaded')
modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(43) -- Open 43 so we can receive replies

-- Send our message
modem.transmit( 43,1, "Hello, world!")

--- --- FUNCTIONS --- ---
function sendChestData()
	print("Pulling chest data")
	local chestData = {}
	local chest = peripheral.find("minecraft:chest")
	print(chest)
	local chestItems = chest.list()
	for i, v in pairs(chestItems) do
		table.insert(chestData, v)
	end
	print("Sending chest data")
	local chestDataString = textutils.serialize(chestData)
	modem.transmit(1, 43, chestDataString)
end

--- --- HANDLERS --- ---
-- handle modem messages
function modemMessageHandler(data)
	local event, side, channel, replyChannel, message, distance = table.unpack(data)

	if (channel == 43) then
		sendChestData()
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
