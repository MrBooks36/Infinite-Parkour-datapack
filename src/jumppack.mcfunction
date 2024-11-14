/fetch
  $data modify storage infinite_parkour:jumppack jumppack set from storage jumppack:$(jumppack_id) jumppack
/store
  $data modify storage jumppack:$(jumppack_id) jumppack set from storage infinite_parkour:jumppack jumppack
/delete
  $data remove storage jumppack:$(jumppack_id) jumppack
/get_jump
  $data modify storage infinite_parkour:calc jump set from storage jumppack:$(jumppack_id) jumppack.jumps[$(page)][$(row)][$(col)]
/set_jump
  $execute unless data storage jumppack:$(jumppack_id) jumppack run data modify storage jumppack:$(jumppack_id) jumppack set value {jumps:[]}
  $execute unless data storage jumppack:$(jumppack_id) jumppack.jumps[$(page)] run data modify storage jumppack:$(jumppack_id) jumppack.jumps set value [[],[],[],[],[],[],[],[]]
  $execute unless data storage jumppack:$(jumppack_id) jumppack.jumps[$(page)][$(row)] run data modify storage jumppack:$(jumppack_id) jumppack.jumps[$(page)] set value [[],[],[],[],[],[]]
  $execute unless data storage jumppack:$(jumppack_id) jumppack.jumps[$(page)][$(row)][$(col)] run data modify storage jumppack:$(jumppack_id) jumppack.jumps[$(page)][$(row)] set value [{},{},{},{},{}]
  $data modify storage jumppack:$(jumppack_id) jumppack.jumps[$(page)][$(row)][$(col)] set from storage infinite_parkour:calc jump