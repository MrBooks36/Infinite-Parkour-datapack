execute as @e[type=!player] at @s if dimension infinite-parkour:infinite-parkour run kill @s
execute in infinite-parkour:infinite-parkour positioned -100 -64 -100 run fill ~ ~ ~ ~200 ~200 ~200 air
execute as @e[type=interaction,tag=ParkourReturn] at @s run kill @s
execute as @e[type=text_display,tag=ParkourLabel] at @s run kill @s
function infinite-parkour:tp-player-to-test