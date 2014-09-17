if not growthtest.modsupport.mesecons then
	minetest.register_craft({
		output = "gtbrewing:fruit_press",
		recipe = {
			{"group:wood", "default:steel_ingot", "group:wood"},
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
			{"group:wood", "group:wood", "group:wood"}
		}
	})
else
	minetest.register_craft({
		output = "gtbrewing:fruit_press",
		recipe = {
			{"group:wood", "mesecons_pistons:piston_normal_off", "group:wood"},
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
			{"group:wood", "group:wood", "group:wood"}
		}
	})
end