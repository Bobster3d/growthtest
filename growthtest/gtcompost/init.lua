gtcompost = { }
gtcompost.compostable = { seeds = {}, crops = {}, plant = { } }

dofile(minetest.get_modpath("gtcompost").."/api.lua")

minetest.register_craftitem("gtcompost:compost_bucket", {
	description = "Compost bucket",
	inventory_image = "gtcompost_compost_bucket.png",
	groups = {not_in_creative_inventory=1},
	on_use = function(itemstack, user, pointed_thing)
		return gtcompost.forcegrow(itemstack,pointed_thing)
	end
})

gtcompost.register_compostable({
seed = "farming:seed_wheat",
crops = { 
	"farming:wheat_1","farming:wheat_2",
	"farming:wheat_3","farming:wheat_4",
	"farming:wheat_5","farming:wheat_6",
	"farming:wheat_7","farming:wheat_8",
},
})

gtcompost.register_compostable({
seed = "farming:seed_cotton",
crops = { 
	"farming:cotton_1","farming:cotton_2",
	"farming:cotton_3","farming:cotton_4",
	"farming:cotton_5","farming:cotton_6",
	"farming:cotton_7","farming:cotton_8",
},
})