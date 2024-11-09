#Here, We execute from the player's position and give the different block displays their first interpolations, 4 ticks after they've been created in generate-decorations.mcfunction.
#0 and 1 are the big gold pillars, they grow in size.
#2 is the big slab at the bottom of the world, it flys up from the void.
execute if score RandoDeco RandomNum matches 0 in infinite-parkour:infinite-parkour at @p[tag=ParkourScheduleTarget] positioned ~50 ~-40 ~50 run data merge entity @n[type=block_display,tag=!ParkourDecoInterpolating,tag=ParkourDecoPillar] {Tags:["ParkourDeco","ParkourDecoInterpolating","ParkourDecoPillar"],start_interpolation:-1,transformation:{translation:[20.0f,-350.0f,20.0f],left_rotation:[-0.075f,0.0f,0.075f,1f],right_rotation:[0.0f,0.0f,0.0f,1f],scale:[30.0f, 400.0f, 30.0f]}}
execute if score RandoDeco RandomNum matches 1 in infinite-parkour:infinite-parkour at @p[tag=ParkourScheduleTarget] positioned ~-20 ~-40 ~50 run data merge entity @n[type=block_display,tag=!ParkourDecoInterpolating,tag=ParkourDecoPillar] {Tags:["ParkourDeco","ParkourDecoInterpolating","ParkourDecoPillar"],start_interpolation:-1,transformation:{translation:[-80.0f,-350.0f,20.0f],left_rotation:[-0.075f,0.0f,-0.075f,1f],right_rotation:[0.0f,0.0f,0.0f,1f],scale:[30.0f, 400.0f, 30.0f]}}
execute if score RandoDeco RandomNum matches 2 in infinite-parkour:infinite-parkour at @p[tag=ParkourScheduleTarget] positioned ~30 ~-40 ~50 run data merge entity @n[type=block_display,tag=!ParkourDecoInterpolating,tag=ParkourDecoCarpet] {start_interpolation:-1,Tags:["ParkourDeco","ParkourDecoCarpet","ParkourDecoInterpolating"],transformation:{translation:[-60.0f,0.0f,-60.0f],left_rotation:[0.0f,0.0f,0.0f,1f],right_rotation:[0.0f,0.0f,0.0f,1f],scale:[60.0f, 1.0f, 60.0f]},block_state:{Name:"minecraft:gold_block"},view_range:50.0f}