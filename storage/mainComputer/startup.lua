print('packaged installed via github')
print('packaged loaded')
local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(15) -- Open 15 so we can receive replies

-- Send our message
modem.transmit(43, 15, "Hello, world!")

-- And wait for a reply
local event, side, channel, replyChannel, message, distance
repeat  event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
until channel == 15

print("Received a reply: " .. tostring(message))