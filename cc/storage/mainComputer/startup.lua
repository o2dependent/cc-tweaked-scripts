-- transmit channel 43 - turtle
-- receive channel 1 - main computer

print('packaged loaded')
modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(1) -- Open 43 so we can receive replies

-- Send our message
modem.transmit(15, 43, "Hello, world!")

--- --- HANDLERS --- ---
-- modem handler
function modemMessageHandler(data)
	-- pull event from modem and process via channel
	local event, side, channel, replyChannel, message, distance = table.unpack(data)
	print(channel, message)
	if (channel == 1) then
		print("Received a message: " .. tostring(message))
		io.open("data.txt", "w"):write(message):close()
	end
end

-- click handler
function clickHandler(data)
	local event, button, x, y = table.unpack(data)
	print(("The mouse button %s was pressed at %d, %d"):format(button, x, y))
	modem.transmit(43, 1, "chest_data")
end

--- --- MAIN --- ---
while true do
	local eventData = {os.pullEvent()}
	local event = eventData[1]

	if event == "mouse_click" then
		clickHandler(eventData)
	elseif event == "modem_message" then
		modemMessageHandler(eventData)
	end
end
