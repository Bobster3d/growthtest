function gtberries.register_bush(bush_name,bush_data, berry_name, berry_data)
	minetest.register_node(bush_name, {
		description = bush_data.description or "Bush",
		node_box = bush_data.node_box or bush_model,
		selection_box = bush_data.selection_box or bush_model,
		tiles = bush_data.tiles or {"gtberries_bush.png"},
		drawtype = "nodebox",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		groups = {snappy=3,flammable=2,attached_node=1},
		sounds = default.node_sound_leaves_defaults(), 
		after_place_node = function(pos, placer)
			if berry_name ~= nil and berry_name ~= "" then
				if berry_data ~= nil then
					return gtberries.place_bush(pos, bush_name.."_empty")
				end
			else
				return gtberries.place_bush(pos)
			end
		end,
		on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			if berry_name ~= nil and berry_name ~= "" then
				if berry_data ~= nil then
					gtberries.pick_berry(pos, berry_name, bush_name.."_empty")
				end
			end
		end,
	})
	if berry_name ~= nil and berry_name ~= "" then
		if berry_data ~= nil then
			minetest.register_craftitem(berry_name, {
				description = berry_data.description or "UNDEFINED BERRY",
				inventory_image = berry_data.inventory_image,
				on_use = minetest.item_eat(berry_data.health or 1),
			})
			minetest.register_node(bush_name.."_empty", {
				description = bush_data.description or "Bush",
				node_box = bush_data.node_box or bush_model,
				selection_box = bush_data.selection_box or bush_model,
				tiles = {"gtberries_bush.png"},
				drawtype = "nodebox",
				paramtype = "light",
				sunlight_propagates = true,
				walkable = false,
				drop = bush_name,
				groups = {snappy=3,flammable=2,attached_node=1,not_in_creative_inventory=1},
				sounds = default.node_sound_leaves_defaults(), 
				after_place_node = function(pos, placer)
					return gtberries.place_bush(pos)
				end,
			})
			minetest.register_abm({
				nodenames = {bush_name.."_empty"},
				interval = 120,
				chance = 2,
				action = function(pos, node)
					gtberries.set_bush(pos, bush_name)
				end,
			})
		end
	end
end

function gtberries.place_bush(pos, replace_with)
	local posbelow = {x=pos.x, y=pos.y-1, z=pos.z}
	local nodebelow = minetest.get_node_or_nil(posbelow)
	if nodebelow ~= nil then
		if minetest.get_item_group(nodebelow.name, "soil") == 1 then
			if replace_with ~= nil and replace_with ~= "" then
				gtberries.set_bush(pos, replace_with)
			end
			return false
		end
	end
	minetest.remove_node(pos)
	return true
end

function gtberries.set_bush(pos, replace_with)
	minetest.set_node(pos, {name = replace_with})
end

function gtberries.pick_berry(pos,berry_name,replace_with)
	gtberries.set_bush(pos, replace_with)
	minetest.add_item({x=pos.x+math.random(-1,1), y=pos.y+1, z=pos.z+math.random(-1,1)}, berry_name)
end