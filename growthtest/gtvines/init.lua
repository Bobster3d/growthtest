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


function gtvines.grow(pos, node)
	local dir = growthtest.wallmounted_to_dir(node.param2)
	local posbelow = {x=pos.x, y=pos.y-1, z=pos.z}
	local nodebelow = minetest.get_node(posbelow)
	if nodebelow.name == "air" then
		minetest.set_node(posbelow, {name=node.name, param2 = node.param2})
		return true
	end
	return false
end

function gtvines.get_air_around(pos)
	local left = {x=pos.x-1, y=pos.y, z=pos.z}
	local left_node = minetest.get_node_or_nil(left)
	local right = {x=pos.x+1, y=pos.y, z=pos.z}
	local right_node = minetest.get_node_or_nil(right)
	local front = {x=pos.x, y=pos.y, z=pos.z+1}
	local front_node = minetest.get_node_or_nil(front)
	local back = {x=pos.x, y=pos.y, z=pos.z-1}
	local back_node = minetest.get_node_or_nil(back)
	if left_node.name == "air" then
		return {pos = left, dir = minetest.dir_to_wallmounted({x=1,y=0,z=0})}
	elseif right_node.name == "air" then
		return {pos = right, dir = minetest.dir_to_wallmounted({x=-1,y=0,z=0})}
	elseif front_node.name == "air" then
		return {pos = front, dir = minetest.dir_to_wallmounted({x=0,y=0,z=-1})}
	elseif back_node.name == "air" then
		return {pos = back, dir = minetest.dir_to_wallmounted({x=0,y=0,z=1})}
	else
		return nil
	end
end

function gtvines.generate_vines(pos)
	local height = math.random(5,10)
	local air_node = gtvines.get_air_around(pos)
	if air_node ~= nil then
		local face_dir = air_node.dir
		minetest.set_node(air_node.pos, {name="gtvines:vine", param2 = face_dir})
		for i = 1, height do
			local posbelow = {x=air_node.pos.x, y=air_node.pos.y-i, z=air_node.pos.z}
			local nodebelow = minetest.get_node(posbelow)
			if nodebelow.name == "air" then
				minetest.set_node(posbelow, {name="gtvines:vine", param2 = face_dir})
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
		print(dir)
		if dir == 0 or dir == 1 then
			minetest.remove_node(pos)
			return true
		end
		return false
    end,
})

minetest.register_abm({
	nodenames = {"gtvines:vine"},
	interval = 180,
	chance = 2,
	action = function(pos, node, active_object_count, active_object_count_wider)
		return gtvines.grow(pos, node)
	end
})

plantslib:spawn_on_surfaces({
	avoid_nodes = {"gtvines:vine"},
	avoid_radius = 3,
	spawn_delay = 90,
	spawn_plants = {"vines:vine"},
	spawn_chance = 10,
	spawn_surfaces = {"group:leafdecay"},
	spawn_on_side = true,
	near_nodes = {"default:jungletree"},
	near_nodes_size = 10,
	near_nodes_vertical = 5,
	near_nodes_count = 1,
	plantlife_limit = -0.9,
})

plantslib:register_generate_plant({
	surface = {"default:jungleleaves","default:leaves"},
	max_count = 40,
	rarity = 15,
	avoid_nodes = {"gtvines:vine"},
	avoid_radius = 2,
	near_nodes = {"default:jungletree"},
	near_nodes_size = 10,
	near_nodes_vertical = 5,
	near_nodes_count = 1,
	plantlife_limit = -0.9,
	},
	gtvines.generate_vines
)


minetest.register_alias("vines:side", "gtvines:vine")
minetest.register_alias("vines:vine", "gtvines:vine")