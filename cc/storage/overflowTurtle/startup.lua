function getFileData()
	local file = fs.open("data.json", "r")
	local rawData = file.readAll()
	-- print(rawData)
	local data = textutils.unserializeJSON(rawData)
	file.close()
	print(textutils.serialize(data))
	return data
end

function readChest(side)
	local chest = peripheral.wrap(side)
	local items = chest.list()
	local data = {}
	for i in pairs(items) do
		print(i)
		local detail = chest.getItemDetail(i)
		-- table.insert(data,i, detail)
		data[i] = detail
	end

	return data
end

function readNearbyChests()
	local data = {
		["right"] = nil,
		["left"] = nil
	}
	if (peripheral.isPresent("right")) then
		data["right"] = readChest("right")
	end

	if (peripheral.isPresent("left")) then
		data["left"] = readChest("left")
	end

	return data
end

function saveData(data)
	turtle.equipLeft()
	local x,y,z = gps.locate()
	local coords = {
		["x"] = x,
		["y"] = y,
		["z"] = z
	}
	turtle.equipLeft()
	local res = http.post("http://127.0.0.1:5500/items", textutils.serialiseJSON({["data"] = data,["coords"] = coords}), {
		["Accept"] = "*/*",
		["Content-Type"] = "application/json"
	 })
		-- local file = fs.open("data.json", "w")
		-- file.write(data)
		-- file.close()
end

function clickHandler()
	local chestData = readNearbyChests()
	saveData(chestData)
	getFileData()
end

while (true) do
	local eventData = {os.pullEvent()}
	local event = eventData[1]

	if event == "mouse_click" then
		clickHandler()
	elseif event == "modem_message" then
		print(event)
		-- modemMessageHandler(eventData)
	end
end