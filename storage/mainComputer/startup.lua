-- transmit channel 43 - turtle
-- receive channel 1 - main computer

print('packaged loaded')
local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(43) -- Open 43 so we can receive replies

-- Send our message
modem.transmit(15, 43, "Hello, world!")

function modemMessageHandler()
	-- pull event from modem and process via channel
	local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")

	if (channel == 1) then
		print("Received a message: " .. tostring(message))
	end
	return true
end

function clickHandler()
	event, button, x, y = os.pullEvent("mouse_click")
	print(("The mouse button %s was pressed at %d, %d"):format(button, x, y))
	return true
end

repeat
	clickHandler()
	modemMessageHandler()
until false
-- And wait for a reply