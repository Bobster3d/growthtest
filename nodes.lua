brewtest.pipeworks = {
	fruit_press = {
		tube = {
			insert_object = function(pos, node, stack, direction)
				local meta = minetest.env:get_meta(pos)
				local inv = meta:get_inventory()
				return inv:add_item("src", stack)
			end,
			can_insert = function(pos, node, stack, direction)
				local meta = minetest.env:get_meta(pos)
				local inv = meta:get_inventory()
				return inv:room_for_item("src", stack)
			end,
			--input_inventory = "dst",
			connect_sides = {left=1, right=1, back=1, front=1, bottom=1, top=0}
		}
	}
}

function brewtest.press_active(pos, percent, item_percent)
	local formspec = 
	"size[8,8.5]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"label[0.1,0;Fruit Press]"..
	"list[current_name;src;2.75,1.5;1,1;]"..
    "image[3.75,1.5;1,1;gui_furnace_arrow_bg.png^[lowpart:"..
        (item_percent*100)..":gui_furnace_arrow_fg.png^[transformR270]"..
	"image[4.75,0.5;1,3.5;brewtest_fruit_press_liquid_bg.png^[lowpart:"..
	percent..":brewtest_fruit_press_liquid_fg.png]"..
	"list[current_name;dst;4.75,0.96;2,2;]"..
	"list[current_player;main;0,4.25;8,1;]"..
	"list[current_player;main;0,5.5;8,3;8]"..
	default.get_hotbar_bg(0,4.25)
    return formspec
end
function brewtest.get_press_active_formspec(pos, percent)
	local meta = minetest.get_meta(pos)local inv = meta:get_inventory()
	local press_input = nil
	local press_inputlist = inv:get_list("src")
	if press_inputlist then
		press_input = brewtest.get_juice(press_inputlist[1])
	end
	local item_percent = 0
	if press_input then
		item_percent = meta:get_float("press_time") / press_input.juice.press_time
	end
	return brewtest.press_active(pos, percent, item_percent)
end
 
brewtest.press_inactive_formspec =
	"size[8,8.5]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"label[0.1,0;Fruit Press]"..
	"list[current_name;src;2.75,1.5;1,1;]"..
	"image[3.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
	"image[4.75,0.5;1,3.5;brewtest_fruit_press_liquid_bg.png]"..
	"list[current_player;main;0,4.25;8,1;]"..
	"list[current_player;main;0,5.5;8,3;8]"..
	default.get_hotbar_bg(0,4.25)

minetest.register_node(brewtest.MOD_NAME..":fruit_press_piston_off", {
	drawtype = "nodebox",
	tiles = {
		"brewtest_fruitpress_top.png",
		"brewtest_fruitpress_bottom.png",
		"brewtest_fruitpress_s.png",
		"brewtest_fruitpress_s.png",
		"brewtest_fruitpress_s.png",
		"brewtest_fruitpress_s.png"
		},
	paramtype = "light",
	paramtype2 = "facedir",
	diggable = true,
	selection_box = brewtest.fruit_press_piston.off,
	node_box = brewtest.fruit_press_piston.off,
	groups = {fruitpress = 2,choppy=2, oddly_breakable_by_hand=2},
})

minetest.register_node(brewtest.MOD_NAME..":fruit_press_piston_on", {
	drawtype = "nodebox",
	tiles = {
		"brewtest_fruitpress_top.png",
		"brewtest_fruitpress_bottom.png",
		"brewtest_fruitpress_s_on.png",
		"brewtest_fruitpress_s_on.png",
		"brewtest_fruitpress_s_on.png",
		"brewtest_fruitpress_s_on.png"
		},
	paramtype = "light",
	paramtype2 = "facedir",
	diggable = false,
	selection_box = brewtest.fruit_press_piston.on,
	node_box = brewtest.fruit_press_piston.on,
	groups = {fruitpress = 2},
})

minetest.register_node(brewtest.MOD_NAME..":fruit_press", {
	description = "Fruit Press",
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = brewtest.fruit_press.off,
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	},
	tiles = {
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png"
	},
	tube = brewtest.pipeworks.fruit_press.tube,
	groups = {choppy=2, oddly_breakable_by_hand=2, fruitpress = 1, tubedevice = 1, tubedevice_receiver = 1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", brewtest.press_inactive_formspec)
		meta:set_string("infotext", "Fruit Press")
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
	end,
	after_place_node = function(pos, placer)
		if brewtest.modsupport.pipeworks then
			pipeworks.scan_for_tube_objects( pos );
		end
		return brewtest.add_node_above(pos, {name = brewtest.MOD_NAME..":fruit_press_piston_off"})
    end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("src") then
			return false
		end
		return true
	end,
	after_dig_node = function( pos )
		if brewtest.modsupport.pipeworks then            
		   pipeworks.scan_for_tube_objects(pos)
        end
	end,
	on_destruct = function(pos)
		brewtest.remove_node_above(pos,{group = "fruitpress", groupvalue = 2})
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if listname == "src" then
			if brewtest.get_juice(stack) ~= nil then
				return stack:get_count()
			else
				return 0
			end
		end
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "src" then
			if brewtest.get_juice(stack) ~= nil then
				return count
			else
				return 0
			end
		end
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end
		return stack:get_count()
	end,
})

minetest.register_node(brewtest.MOD_NAME..":fruit_press_on", {
	description = "Fruit Press",
	drop = brewtest.MOD_NAME..":fruit_press",
	paramtype = "light",
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	is_ground_content = false,
	drawtype = "nodebox",
	node_box = brewtest.fruit_press.on,
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	},
	tiles = {
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png"
	},
	tube = brewtest.pipeworks.fruit_press.tube,
	groups = {cracky=2, not_in_creative_inventory=1, fruitpress = 1, tubedevice = 1, tubedevice_receiver = 1},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", brewtest.press_inactive_formspec)
		meta:set_string("infotext", "Fruit Press")
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
	end,
	after_place_node = function(pos, placer)
		if brewtest.modsupport.pipeworks then
			pipeworks.scan_for_tube_objects( pos );
		end
		return brewtest.add_node_above(pos, {name = brewtest.MOD_NAME..":fruit_press_piston_off"})
    end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("src") then
			return false
		end
		return true
	end,
	after_dig_node = function( pos )
		if brewtest.modsupport.pipeworks then            
		   pipeworks.scan_for_tube_objects(pos)
        end
	end,
	on_destruct = function(pos)
		brewtest.remove_node_above(pos,{group = "fruitpress", groupvalue = 2})
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if listname == "src" then
			if brewtest.get_juice(stack) ~= nil then
				return stack:get_count()
			else
				return 0
			end
		end
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "src" then
			if brewtest.get_juice(stack) ~= nil then
				return count
			else
				return 0
			end
		end
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end
		return stack:get_count()
	end,
})


minetest.register_abm({
	nodenames = {brewtest.MOD_NAME..":fruit_press", brewtest.MOD_NAME..":fruit_press_on"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
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
		
		local inv = meta:get_inventory()
		
		local max_juice = 100.0
		local press_input = nil
		local press_inputlist = inv:get_list("src")
		
		if press_inputlist then
			press_input = brewtest.get_juice(press_inputlist[1])
		end
		
		if press_input and press_input.item then
			if meta:get_float("stored_juice") <= 0 and meta:get_string("stored_juice_name") ~= press_input.item:get_name() then
				meta:set_string("stored_juice_name", press_input.item:get_name())
			end
		end
		
		if press_input and press_input.item then
			if meta:get_string("stored_juice_name") ~= press_input.item:get_name() then
				return
			end
		end

		if meta:get_float("stored_juice") < max_juice then
			if meta:get_float("press_time") < meta:get_float("press_totaltime") then
				meta:set_float("press_time", meta:get_float("press_time") + 1)
				if press_input and meta:get_float("press_time") >= press_input.juice.press_time then
					meta:set_float("stored_juice", meta:get_float("stored_juice") + 5)
					press_input.item:take_item(1)
					inv:set_stack("src", 1, press_input.item)
					meta:set_float("press_time", 0)
				end
			end
			local percent = math.floor(meta:get_float("stored_juice") / max_juice * 100)
			meta:set_string("infotext","Fruit Press: Storage - "..percent.."%")
			meta:set_string("formspec", brewtest.get_press_active_formspec(pos, percent))
			if meta:get_float("press_time") < meta:get_float("press_totaltime") then
				brewtest.swap_press_node(pos, brewtest.MOD_NAME..":fruit_press_on",
										brewtest.MOD_NAME..":fruit_press_piston_on")
				return
			end
		elseif meta:get_float("stored_juice") >= max_juice then
			meta:set_string("infotext","Fruit Press: Storage - 100%")
			meta:set_string("formspec", brewtest.get_press_active_formspec(pos, 100))
			brewtest.swap_press_node(pos, brewtest.MOD_NAME..":fruit_press",
							brewtest.MOD_NAME..":fruit_press_piston_off")
			return
		end

		if not press_input or press_input.juice.press_time <= 0 then
			if meta:get_float("stored_juice") <= 0 then
				meta:set_string("infotext","Fruit Press")
				meta:set_string("formspec", brewtest.press_inactive_formspec)
			end
			brewtest.swap_press_node(pos, brewtest.MOD_NAME..":fruit_press",
							brewtest.MOD_NAME..":fruit_press_piston_off")
			return
		end
		
		if inv:is_empty("src") then
			if meta:get_float("stored_juice") <= 0 then
				meta:set_string("infotext","Fruit Press")
				meta:set_string("formspec", brewtest.press_inactive_formspec)
			end
			brewtest.swap_press_node(pos, brewtest.MOD_NAME..":fruit_press",
							brewtest.MOD_NAME..":fruit_press_piston_off")
			return
		end
		
		meta:set_string("press_totaltime", press_input.juice.press_time)
		meta:set_string("press_time", 0)
	end,
})