gtcompost = { }
gtcompost.compostable = { seeds = {}, crops = {}, saplings = { } }

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

--farming_plus compat
gtcompost.register_compostable({
crops = { 
	"farming_plus:carrot_1",
	"farming_plus:carrot_2",
	"farming_plus:carrot_3",
	"farming_plus:carrot",
},
})

gtcompost.register_compostable({
crops = { 
	"farming_plus:orange_1",
	"farming_plus:orange_2",
	"farming_plus:orange_3",
	"farming_plus:orange",
},
})

gtcompost.register_compostable({
crops = { 
	"farming_plus:potato_1",
	"farming_plus:potato_2",
	"farming_plus:potato",
},
})

gtcompost.register_compostable({
crops = { 
	"farming:pumpkin_1",
	"farming:pumpkin_2",
	"farming:pumpkin",
},
})

gtcompost.register_compostable({
crops = { 
	"farming_plus:rhubarb_1",
	"farming_plus:rhubarb_2",
	"farming_plus:rhubarb",
},
})

gtcompost.register_compostable({
crops = { 
	"farming_plus:strawberry_1",
	"farming_plus:strawberry_2",
	"farming_plus:strawberry_3",
	"farming_plus:strawberry",
},
})

gtcompost.register_compostable({
crops = { 
	"farming_plus:tomato_1",
	"farming_plus:tomato_2",
	"farming_plus:tomato_3",
	"farming_plus:tomato",
},
})

gtcompost.register_compostable({
crops = { 
	"gtberries:bush_blueberry_empty",
	"gtberries:bush_blueberry",
},
})