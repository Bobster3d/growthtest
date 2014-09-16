gtberries = { }

local bush_model = {
	type = "fixed",
	fixed = {
		{-0.375, -0.5, -0.375, 0.375, 0.3125, 0.375},
	}
}

dofile(minetest.get_modpath("gtberries").."/api.lua")

---- GET PLANT LIB FOR GEN OR SOMETHING

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
},
"gtberries:blueberry",{
	description = "Blueberry",
	inventory_image = "gtberries_blueberry.png",
})
