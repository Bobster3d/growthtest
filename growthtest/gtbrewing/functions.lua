local function swap_node(pos,name)
	local node = minetest.get_node(pos)
	if node.name == name then
		return
	end
	node.name = name
	minetest.swap_node(pos,node)
end

function gtbrewing.add_node_above(pos, newdata)
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

function gtbrewing.remove_node_above(pos, removedata)
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

function gtbrewing.swap_press_node(pos,pressName,pistonName)
	local pressNode = minetest.get_node_or_nil(pos)
	local pistonPos = {x=pos.x,y=pos.y+1,z=pos.z}
	local pistonNode = minetest.get_node(pistonPos)
	if not pressNode or not pistonNode then return end
		swap_node(pos, pressName)
	if minetest.get_item_group(pistonNode.name, "fruitpress") == 2 and pressNode.param2 == pistonNode.param2 then
		swap_node(pistonPos, pistonName)
	end
end

function gtbrewing.item_drink(amt,replace)
	return minetest.item_eat(amt,replace)
end

function gtbrewing.press_abm_action(pos, node)
	local meta = minetest.get_meta(pos)
			for i, name in ipairs({
			"press_totaltime",
			"press_time",
			"stored_juice",
	}) do
		if meta:get_string(name) == "" then
			meta:set_float(name, 0.0)
		end
	end
	
	local max_juice = 100.0
	
	local inv = meta:get_inventory()
	local press_input = nil
	local press_inputlist = inv:get_list("src")
	if press_inputlist then
		press_input = gtbrewing.get_juice(press_inputlist[1])
	end
	
	if meta:get_float("stored_juice") > 0 then
		local percent = math.floor(meta:get_float("stored_juice") / max_juice * 100)
		meta:set_string("formspec", gtbrewing.get_press_formspec(pos, percent))
	else
		meta:set_string("formspec", gtbrewing.press_inactive_formspec)
	end
	
	if growthtest.modsupport.mesecons then
		local has_mesecons_power = minetest.registered_nodes[node.name].has_mesecons_power
		if not has_mesecons_power then
			return
		end
	end
	
	if press_input and press_input.item then
		if meta:get_float("stored_juice") <= 0 and meta:get_string("stored_juice_name") ~= press_input.item:get_name() then
			meta:set_string("stored_juice_name", press_input.item:get_name())
		elseif meta:get_float("stored_juice") > 0 and meta:get_string("stored_juice_name") ~= press_input.item:get_name() then
			return
		end
	end
	
	if meta:get_float("stored_juice") >= max_juice then
		if not growthtest.modsupport.mesecons then
			gtbrewing.swap_press_node(pos, "gtbrewing:fruit_press", "gtbrewing:fruit_press_piston_off")
		end
		return
	end
	
	if meta:get_float("press_time") < meta:get_float("press_totaltime") then
		meta:set_float("press_time", meta:get_float("press_time") + 1)
		if press_input and meta:get_float("press_time") >= press_input.juice.press_time then
			meta:set_float("stored_juice", meta:get_float("stored_juice") + 2)
			if meta:get_float("stored_juice") >= max_juice then
				meta:set_float("stored_juice", max_juice)
			end
			press_input.item:take_item(1)
			inv:set_stack("src", 1, press_input.item)
		end
		if not growthtest.modsupport.mesecons then
			gtbrewing.swap_press_node(pos, "gtbrewing:fruit_press_on", "gtbrewing:fruit_press_piston_on")
		end
		return
	end
	
	if not press_input or press_input.juice.press_time <= 0 then
		if not growthtest.modsupport.mesecons then
			gtbrewing.swap_press_node(pos, "gtbrewing:fruit_press", "gtbrewing:fruit_press_piston_off")
		end
	end
	
	if inv:is_empty("src") then
		if not growthtest.modsupport.mesecons then
			gtbrewing.swap_press_node(pos, "gtbrewing:fruit_press", "gtbrewing:fruit_press_piston_off")
		end
		return
	end
	
	meta:set_string("press_totaltime", press_input.juice.press_time)
	meta:set_string("press_time", 0)
end
