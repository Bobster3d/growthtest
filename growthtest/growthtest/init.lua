growthtest = {
	MOD_NAME = "growthtest",
}
growthtest.modsupport = {
	pipeworks = minetest.get_modpath("pipeworks"),
	mesecons = minetest.get_modpath("mesecons"),
}

function growthtest.wallmounted_to_dir(wallmounteddir)
	--a table of possible dirs
	return ({{x=0, y=1, z=0},
			{x=0, y=-1, z=0},
			{x=1, y=0, z=0},
			{x=-1, y=0, z=0},
			{x=0, y=0, z=1},
			{x=0, y=0, z=-1}})
			--indexed into by a table of correlating wallmounteddir
			[({[0]=1, 2, 3, 4, 
				5, 6})
			--indexed into by the wallmounteddir in question
			[wallmounteddir]]
end