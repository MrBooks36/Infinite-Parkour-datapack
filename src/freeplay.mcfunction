# this file is an incomplete rewrite of other files
# the attempt is to use lane.mcfunction and jumppack.mcfuncton

/tick
  %FILE%/lobby_tick
  %FILE%/game_tick
  %FILE%/fall_tick

/teleport_in
  execute in infinite_parkour:infinite_parkour run function infinite_parkour:player_saver/store
  
  data modify storage infinite_parkour:calc lane_tag set value "ip_freeplay_entry"
  function infinite_parkour:lane/alloc
  data remove storage infinite_parkour:calc lane_tag

  execute at @s run
    place template infinite_parkour:infinite_parkour_lobby ~-5 ~-1 ~-4

# Lobby
/lobby_tick
  execute in infinite_parkour:lane as @e[type=marker,tag=ip_freeplay_entry,distance=0..] at @s run
    execute store success score #player_in_lobby math positioned ~-8 ~-8 ~-8 if entity @p[dx=15,dy=15,dz=15]
    execute as @p if score #player_in_lobby math matches 1 run team join Highscore
    #Checks below to see if the first 2 blocks have been generated, if not, then they are created. The player is also tossed on ParkourPlayers team. I'm not sure if this is working intended actually since in theory the player could walk backwards, rejoin team Highscore, and then wouldn't be back on team ParkourPlayers when walking back forwards, but this doesn't happen.
    execute align xyz unless block ~ ~1 ~12 minecraft:barrier positioned ~-10 ~ ~ as @p[dx=20,dy=10,dz=12] if score #player_in_lobby math matches 0 positioned ~10 ~1 ~10 run %FILE%/setup_first_jump

  return 0
#Command below is a direct port over from pressure_plate_triggered.mcfunction (you know the confusing function that set up the first few jumps). It has also now been modified to set the blocks up correctly.
/setup_first_jump
  team join ParkourPlayers @s
  execute as @s[team=ParkourPlayers] run
    execute unless score @s BlockCheckpoint matches 0.. run scoreboard players set @s BlockCheckpoint 0
    execute unless score @s BlockDifficulty matches 0.. run scoreboard players set @s BlockDifficulty 1
    scoreboard players operation @s Blocks = @s BlockCheckpoint
  setblock ~ ~-1 ~5 barrier
#The next 4 commands sets up the first few jumps and markers, I'll define them here:
#ip_jump_mid is a marker on the very next jump.
#ip_scale_up is a block display that changes in size and is in place for the 2nd next jump.
#ParkourGeneratedJump is a marker that is located at the 2nd next jump. This can probably be replaced with ip_scale_up
#TODO It will be better to spawn ParkourCurr one block lower, but it will delete the platform
  execute positioned ~0.5 ~0.5 ~2.5 unless entity @n[type=marker,tag=ParkourCurr,distance=..1] run summon marker ~ ~ ~ {Tags:["ParkourCurr","ParkourBlock","ParkourPrevGoal"]}
  execute positioned ~0.5 ~-0.5 ~5.5 unless entity @n[type=marker,tag=ip_jump_mid,distance=..1] run
    summon block_display ~ ~ ~ {interpolation_duration:1,Tags:["ParkourBlockDisplay"],block_state:{Name:"minecraft:gold_block"},transformation:{scale:[1.0f,1.0f,1.0f],left_rotation:[0.0f,0.0f,0.0f,1.0f],right_rotation:[0.0f,0.0f,0.0f,1.0f],translation:[-0.5f,-0.5f,-0.5f]}}
    summon marker ~ ~ ~ {Tags:["ip_jump_mid","ParkourBlock","ip_jump_end"]}
  execute positioned ~0.5 ~-0.5 ~8.5 unless entity @n[type=marker,tag=ParkourGeneratedJump,distance=..1] run
    summon block_display ~ ~ ~ {interpolation_duration:1,Tags:["ParkourBlockDisplay","ip_scale_up"],block_state:{Name:"minecraft:gold_block"},transformation:{scale:[0.0f,0.0f,0.0f],left_rotation:[0.0f,0.0f,0.0f,1.0f],right_rotation:[0.0f,0.0f,0.0f,1.0f],translation:[0.0f,0.0f,0.0f]}}
    summon marker ~ ~ ~ {Tags:["ParkourGeneratedJump","ParkourBlock","ParkourGenPos"]}


# Game
/game_tick
  execute in infinite_parkour:lane as @e[type=marker,tag=ip_freeplay_entry,distance=0..] at @s run
    data modify storage infinite_parkour:calc lane set from entity @s data
    %EMPTY%
      $execute as @a[nbt={UUID:$(player)}] run %FILE%/player_tick
    + with storage infinite_parkour:calc lane
    data modify entity @s data set from storage infinite_parkour:calc lane
  data remove storage infinite_parkour:calc lane

/player_tick
  execute unless entity @s[team=ParkourPlayers] run return 0
  %FILE%/set_distance_score
  # Clean decorations behind the players.
  execute at @s align xyz positioned ~-70 ~-50 ~-1 run kill @e[tag=ParkourDeco,dx=140,dy=100,dz=1]

  execute if entity @s[nbt={OnGround:1b}] at @s positioned ~-0.8 ~-1 ~-0.8 run
    execute as @e[type=marker,tag=ParkourBlock,tag=!ParkourDecoComplete,dx=0.6,dy=1,dz=0.6] at @s run
      execute if entity @s[tag=ip_jump_end] run function infinite_parkour:freeplay/finished_jump
      execute at @s run data merge entity @n[type=block_display,distance=..0.1] {block_state:{Name:"raw_gold_block"}}
      tag @s add ParkourDecoComplete
      function infinite_parkour:generate_decorations

/finished_jump
  tag @s remove ip_jump_mid
  execute positioned ~-31.5 ~-31.5 ~-63.5 as @n[type=marker,tag=ip_jump_start,dx=64,dy=64,dz=64] at @s run
    execute positioned ~-63.5 ~-63.5 ~-63.5 as @e[type=marker,tag=ip_jump_old,dx=128,dy=128,dz=64] at @s run
      kill @n[type=block_display,distance=..0.1,tag=ParkourBlockDisplay]
      kill @s
    tag @s add ip_jump_mid
    tag @s remove ip_jump_start
    execute positioned ~-31.5 ~-31.5 ~-0.5 as @e[type=marker,tag=ip_jump_mid,dx=64,dy=64,dz=64] at @s run
      setblock ~ ~ ~ air
      tag @n[type=block_display,distance=..0.1,tag=ParkourBlockDisplay] add ip_scale_down
      tag @s remove ip_jump_mid
      tag @s add ip_jump_old
  tag @s remove ip_jump_end
  tag @s add ip_jump_start
  function infinite_parkour:jump/place

  # generate jump, this is placeholder and TODO: allow for randomization between different jump packs, and selection of a jumppack
  function infinite_parkour:jumppack/fetch {jumppack_id:"my_jumppack"}
  function infinite_parkour:jumppack/random_jump
  data modify storage infinite_parkour:calc temp_blocks_list set from storage infinite_parkour:jumppack jump.blocks
  # Below gets a random number between 0 and 1, multiplies by 2, and then subtracts 1. This gives a random value of -1 or 1, which will be multiplied by every X value to randomly mirror jumps across the X axis, 50-50.
  execute store result storage infinite_parkour:calc jump_mirror_math int 2 run random value 0..1
  execute store result score #jump_mirror_math math run data get storage infinite_parkour:calc jump_mirror_math
  scoreboard players remove #jump_mirror_math math 1

  execute positioned ~-31.5 ~-31.5 ~-0.5 as @n[type=marker,tag=ParkourGenPos,dx=64,dy=64,dz=64] at @s run
    # remove old trail
    kill @e[type=marker,tag=ip_trail_curr,distance=..512]
    # mark next trail as current trail
    tag @e[type=marker,tag=ip_trail,distance=..512] add ip_trail_curr
    # spawn
    function infinite_parkour:jump/spawn

    tag @s remove ParkourGenPos

  execute at @e[type=marker,tag=ParkourGeneratedJump,distance=..512] align xyz run summon block_display ~0.5 ~0.5 ~0.5 {interpolation_duration:1,Tags:["ParkourBlockDisplay","ip_scale_up"],block_state:{Name:"minecraft:gold_block"},transformation:{scale:[0.0f,0.0f,0.0f],left_rotation:[0.0f,0.0f,0.0f,1.0f],right_rotation:[0.0f,0.0f,0.0f,1.0f],translation:[0.0f,0.0f,0.0f]}}
  execute at @e[type=marker,tag=ParkourBlocker,distance=..512] as @n[type=block_display,distance=..1] run data merge entity @s {block_state:{Name:"minecraft:yellow_stained_glass"}}
  # generate decoration, will be included here in the future on the next line

/macro_pos
  #Below multiples the X value by a scoreboard #jump_mirror_math within the math objective which will be set to either -1 or 1 from above. This mirrors the positions of the blocks across the X axis, and will be consistent per block within a jump.
  execute store result score #jump_current_x math run data get storage infinite_parkour:macro pos[0]
  scoreboard players operation #jump_current_x math *= #jump_mirror_math math
  execute store result storage infinite_parkour:macro data.x int 1 run scoreboard players get #jump_current_x math
  data modify storage infinite_parkour:macro data.y set from storage infinite_parkour:macro pos[1]
  data modify storage infinite_parkour:macro data.z set from storage infinite_parkour:macro pos[2]
  data remove storage infinite_parkour:macro pos
  scoreboard players reset #jump_current_x math

/fall_tick
  # this function is used for the falling effect and teleporting the players back
  execute as @a[team=ParkourPlayers] at @s run
    execute store result score py math run data get entity @s Pos[1]
    execute store result score by math run data get entity @n[tag=ip_jump_mid] Pos[1]
    execute if score py math >= by math run
      tag @s remove ParkourFalling
      stopsound @s ambient minecraft:item.elytra.flying
    execute if score py math >= by math run return 0

    execute if entity @s[tag=!ParkourFalling] run
      tag @s add ParkourFalling
      playsound minecraft:item.elytra.flying ambient @s ~ ~ ~ 0.4 2
    particle crit ~4 ~-5 ~4 -2 10 -2 0.5 0 normal
    particle crit ~-4 ~-5 ~4 2 10 -2 0.5 0 normal
    particle crit ~4 ~-5 ~-4 -2 10 2 0.5 0 normal
    particle crit ~-4 ~-5 ~-4 2 10 2 0.5 0 normal

    scoreboard players remove by math 8
    execute if score py math >= by math run return 0
    tag @s remove ParkourFalling
    stopsound @s ambient minecraft:item.elytra.flying
    execute as @e[tag=ParkourBlock,distance=..512] at @s run
      setblock ~ ~ ~ air
      kill @n[type=block_display,distance=..0.9]
      kill @s
    kill @e[tag=ParkourDeco,distance=..512]
    kill @e[type=marker,tag=ip_trail,distance=..512]
    function infinite_parkour:lane/teleport_entry
    team join Highscore @s

  stopsound @a[team=Highscore] ambient minecraft:item.elytra.flying
  tag @a[team=Highscore] remove ParkourFalling

/set_distance_score
  execute store result score @s Blocks run data get entity @s Pos[2] 1
  scoreboard players remove @s Blocks 12
  execute if score @s Blocks matches ..0 run scoreboard players set @s Blocks 0
  # Using unless in case the player doesn't have a high score yet
  execute unless score @s HighScore > @s Blocks run scoreboard players operation @s HighScore = @s Blocks