gtvines = { }
gtvines.drops = { items = { } }
function gtvines.register_vine_drop(drop)
	for i, items in ipairs(gtvines.drops.items) do
		for key, value in ipairs(items.items) do
			if value == drop.item then 
				print("vine drop exists use overwrite_vine_drop") 
				return 
			end
		end
	end
	table.insert(gtvines.drops.items, {items = {drop.item}, rarity = drop.rarity})
end

function gtvines.overwrite_vine_drop(drop)
	local overwrite_drop = drop
	for i, items in ipairs(gtvines.drops.items) do
		for key, value in ipairs(items.items) do
			if value == overwrite_drop.item then 	
				value = overwrite_drop.item
				if items.rarity ~= nil then
					items.rarity = overwrite_drop.rarity
				end
				print("overwrote vine drop "..items.rarity ) 
			end
		end
	end
end

minetest.register_node("gtvines:vine", {
	description = "Vine",
	drawtype = "signlike",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	legacy_wallmounted = true,
	selection_box = {
		type = "wallmounted",
	},
	tile_images = { "gtvines_vine.png" },
	inventory_image = "gtvines_vine.png",
	wield_image = "gtvines_vine.png",
	drop = gtvines.drops,
	groups = {snappy=3,flammable=2,vines=1,attached_node=1,hanging_node=1},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = function(pos, placer)
		local n = minetest.get_node_or_nil(pos)
		local dir = n.param2
		if dir == 0 or dir == 1 then
			minetest.remove_node(pos)
			return true
		end
		return false
    end,
})

function gtvines.grow(pos, node)
	local dir = growthtest.wallmounted_to_dir(node.param2)
	local posbelow = {x=pos.x, y=pos.y-1, z=pos.z}
	local nodebelow = minetest.get_node(posbelow)
	if nodebelow.name == "air" then
		minetest.add_node(posbelow, {name=node.name, param2 = node.param2})
	end
end

minetest.register_abm({
	nodenames = {"gtvines:vine"},
	interval = 180,
	chance = 2,
	action = function(pos, node, active_object_count, active_object_count_wider)
		gtvines.grow(pos, node)
	end
})