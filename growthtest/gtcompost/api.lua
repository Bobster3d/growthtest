function gtcompost.register_compostable(def)
	if def.seed ~= nil then
		for i, seed in ipairs(gtcompost.compostable.seeds) do
			if seed == def.seed then 
				return 
			end
		end
		table.insert(gtcompost.compostable.seeds, def.seed)
	end
	if def.crops ~= nil then
		table.insert(gtcompost.compostable.crops, def.crops)
	end
end

function gtcompost.is_seed(name)
	for i, seed in ipairs(gtcompost.compostable.seeds) do
		if seed == name then 
			return true
		end
	end
	return false
end

function gtcompost.is_crop(crop_name)
	for i, crops in ipairs(gtcompost.compostable.crops) do
		for j, crop in ipairs(crops) do
			if crop == crop_name then 
				return crops
			end
		end
	end
	return nil
end

function gtcompost.forcegrow(itemstack,pointed_thing)
	local pos = pointed_thing.under
	if not pos then return end
	local node = minetest.get_node(pos)
	if not node then return end
	local crops = gtcompost.is_crop(node.name)
	if gtcompost.is_seed(node.name) then
		minetest.set_node(pos, {name = node.name:gsub("seed_", "") .. "_1"})
	elseif crops ~= nil then
		local stage = 1
		for i,name in ipairs(crops) do
			if name == node.name then
				stage = i
				break
			end
		end
		if stage >= #crops then
			return
		end
		local new_crop = crops[stage + 1]
		minetest.set_node(pos, {name = new_crop})
	elseif node.name == "gtvines:vine" then
		gtvines.grow(pos, node)
	else
		return
	end
	itemstack:take_item()
	return itemstack
end