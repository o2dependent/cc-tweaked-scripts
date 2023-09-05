function selectWitherSkull()
	turtle.select(2)
	if (turtle.getItemCount() == 0) then
		return false
	end
	return true
end

function selectSoulsand()
	turtle.select(1)
	if (turtle.getItemCount() == 0) then
		return false
	end
	return true
end

function placeSoulSand()
	if (not selectSoulsand()) then
		return false
	end

	turtle.place()
	turtle.turnLeft()
	turtle.place()
	turtle.turnRight()
	turtle.turnRight()
	turtle.place()
	turtle.turnLeft()
	turtle.back()
	turtle.place()
	return true
end

function placeWitherSkulls()
	if (not selectWitherSkull()) then
		return false
	end
	turtle.turnLeft()
	turtle.place()
	turtle.turnRight()
	turtle.turnRight()
	turtle.place()
	turtle.turnLeft()
	turtle.down()
	turtle.placeUp()
	return true
end

function makeWither()
	turtle.up()
	turtle.forward()

	if (not placeSoulSand()) then
		return false
	end

	if (not placeWitherSkulls()) then
		return false
	end

	return true
end

function main()
	while true do
		local eventData = {os.pullEvent()}
		local event = eventData[1]

		if event == "mouse_click" then
			print("Making wither...")
			local success = makeWither()
			if (success) then
				print("Wither made!")
			else
				print("Wither not made!")
			end
		end
	end
end

main()