function brewtest.register_juice(juice_data)
	brewtest.juices[juice_data.src_item] = {
		src_item = juice_data.src_item,
		press_time = juice_data.press_time or 1,
		name = juice_data.name,
		bucket = juice_data.bucket,
		bucket_img = juice_data.bucket_img,
		glass = juice_data.glass,
		glass_img = juice_data.glass_img,
		drink_hp = juice_data.drink_hp,
	}
	if juice_data.glass ~= nil then
		minetest.register_craftitem(juice_data.glass, {
			description = "Glass of "..juice_data.name,
			inventory_image = juice_data.glass_img,
			stack_max = 1,
			on_use = brewtest.item_drink(juice_data.drink_hp,"vessels:drinking_glass")
		})
	end
	if juice_data.bucket ~= nil then
		minetest.register_craftitem(juice_data.bucket, {
			description = "Bucket of "..juice_data.name,
			inventory_image = juice_data.bucket_img,
			stack_max = 1,
			groups = {not_in_creative_inventory=1},
			on_place = function(itemstack, user, pointed_thing)
			end
		})
	end
end

function brewtest.get_juice(stack)
	local item_name = stack:get_name()
	if brewtest.juices[item_name] ~= nil then
	local new_input
		return {juice = brewtest.juices[item_name], item = stack }
	end
	return nil
end