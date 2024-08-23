#>purec:_/load
#--------------------
# @LOAD
#--------------------

# load
scoreboard players set *purec load-status 1

#declare storage purec:var
#declare storage purec:in
#declare storage purec:out
#declare storage purec:data
#declare storage purec:hook
#declare storage purec:implement

# scoreboards
scoreboard objectives add -purec dummy
scoreboard objectives add --purec dummy
#scoreboard objectives add purec-scoreboard dummy

# tick
schedule clear purec:_/tick
function purec:_/tick