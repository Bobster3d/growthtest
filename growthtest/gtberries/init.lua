gtberries = { }

gtberries.berry_bushes = { }

local bush_model = {
	type = "fixed",
	fixed = {
		{-0.375, -0.5, -0.375, 0.375, 0.3125, 0.375},
	}
}

dofile(minetest.get_modpath("gtberries").."/api.lua")

gtberries.register_bush("gtberries:bush",{
	description = "Bush",
	tiles = {
		"gtberries_bush.png",
	},
	node_box = bush_model,
})

gtberries.register_bush(
"gtberries:bush_blueberry",{
	description = "Blueberry Bush",
	tiles = {
		"gtberries_bush.png^gtberries_blueberry_overlay.png",
	},
	node_box = bush_model,
	min_light_level = 8, --minimum light level to grow
},
"gtberries:blueberry",{
	description = "Blueberry",
	inventory_image = "gtberries_blueberry.png",
	health = 2,
	drop_amount = {
		min = 1,
		max = 3,
	},
})

plantslib:register_generate_plant({
	surface = {
		"default:dirt_with_grass",
	},
	avoid_radius = 5,
	avoid_nodes = {"group:bush"},
	max_count = 15, --10,15
	rarity = 30, --3,4
	min_elevation = 1, -- above sea level
	plantlife_limit = -0.9,
	temp_min = 0.4, -- approx 2-3C
	temp_max = -0.15, -- approx 35C
	},
	"gtberries:bush"
)	

plantslib:register_generate_plant({
	surface = {
		"default:dirt_with_grass",
	},
	avoid_radius = 8,
	avoid_nodes = {"group:bush"},
	max_count = 8, --10,15
	rarity = 70, --3,4
	min_elevation = 1, -- above sea level
	plantlife_limit = -0.9,
	temp_min = 0.4, -- approx 2-3C
	temp_max = -0.15, -- approx 35C
	},
	gtberries.berry_bushes
)	