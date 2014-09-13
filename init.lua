brewtest = {
	MOD_NAME = "brewtest",
	version = 0.2,
}
brewtest.modsupport = {
	pipeworks = minetest.get_modpath("pipeworks"),
	mesecons = minetest.get_modpath("mesecons"),
	mesecons_mvps = minetest.get_modpath("mesecons_mvps"),
}
brewtest.juices = { }

dofile(minetest.get_modpath(brewtest.MOD_NAME).."/api.lua")
dofile(minetest.get_modpath(brewtest.MOD_NAME).."/functions.lua")
dofile(minetest.get_modpath(brewtest.MOD_NAME).."/models.lua")
dofile(minetest.get_modpath(brewtest.MOD_NAME).."/juices.lua")
dofile(minetest.get_modpath(brewtest.MOD_NAME).."/nodes.lua")

minetest.override_item("bucket:bucket_empty", {
    on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		local node = minetest.get_node(pointed_thing.under)
		local meta = minetest.get_meta(pointed_thing.under)
		if node.name == brewtest.MOD_NAME..":fruit_press" or node.name == brewtest.MOD_NAME..":fruit_press_on" then
			local juicedef = brewtest.juices[meta:get_string("stored_juice_name")]
			if juicedef ~= nil and juicedef.bucket ~= nil then
				if meta:get_float("stored_juice") < 10 then
					return
				end
				meta:set_float("stored_juice", meta:get_float("stored_juice") - 10)
				return ItemStack({name = juicedef.bucket})
			end
		end
	end
})

minetest.override_item("vessels:drinking_glass", {
    on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		local node = minetest.get_node(pointed_thing.under)
		local meta = minetest.get_meta(pointed_thing.under)
		if node.name == brewtest.MOD_NAME..":fruit_press" or node.name == brewtest.MOD_NAME..":fruit_press_on" then
			local juicedef = brewtest.juices[meta:get_string("stored_juice_name")]
			if juicedef ~= nil and juicedef.glass ~= nil then
				if meta:get_float("stored_juice") < 4 then
					return
				end
				meta:set_float("stored_juice", meta:get_float("stored_juice") - 4)
				return ItemStack({name = juicedef.glass})
			end
		end
	end
})