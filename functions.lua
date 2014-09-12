local function swap_node(pos,name)
	local node = minetest.get_node(pos)
	if node.name == name then
		return
	end
	node.name = name
	minetest.swap_node(pos,node)
end

function brewtest.add_node_above(pos, newdata)
	local n = minetest.get_node_or_nil(pos)
	if not n or not n.param2 then
		minetest.remove_node(pos)
		return true
	end
	local dir = minetest.facedir_to_dir(n.param2)
	local p = {x=pos.x,y=pos.y+1,z=pos.z}
	local n2 = minetest.get_node_or_nil(p)
	local def = minetest.registered_items[n2.name] or nil
	if not n2 or not def or not def.buildable_to then
		minetest.remove_node(pos)
		return true
	end
	minetest.set_node(p, {name = newdata.name, param2 = n.param2})
	return false
end

function brewtest.remove_node_above(pos, removedata)
	local n = minetest.get_node_or_nil(pos)
	if not n then return end
	local dir = minetest.facedir_to_dir(n.param2)
	local p = {x=pos.x,y=pos.y+1,z=pos.z}
	local n2 = minetest.get_node(p)
	if removedata.group ~= nil then
		if minetest.get_item_group(n2.name, removedata.group) == removedata.groupvalue and n.param2 == n2.param2 then
			minetest.remove_node(p)
		end
	elseif removedata.name ~= nil then
		if n2.name == removedata.name and n.param2 == n2.param2 then
			minetest.remove_node(p)
		end
	else
		if n.param2 == n2.param2 then
			minetest.remove_node(p)
		end
	end
end

function brewtest.swap_press_node(pos,pressName,pistonName)
	local pressNode = minetest.get_node_or_nil(pos)
	local pistonPos = {x=pos.x,y=pos.y+1,z=pos.z}
	local pistonNode = minetest.get_node(pistonPos)
	if not pressNode or not pistonNode then return end
		swap_node(pos, pressName)
	if minetest.get_item_group(pistonNode.name, "fruitpress") == 2 and pressNode.param2 == pistonNode.param2 then
		swap_node(pistonPos, pistonName)
	end
end

function brewtest.item_drink(amt,replace)
	return minetest.item_eat(amt,replace)
end