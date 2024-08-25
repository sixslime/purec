#> purec:api > run
#--------------------
# -> pfunction: PurecIdentifier
# => input: obj = {}
#--------------------
# <- result: obj
#--------------------
#> attemps to get the cached result associated with the <pfunction> and <input>;
#> if it does not exist, generate it by actually running the command associated with <pfunction>.
#--------------------
#- >result< is cached in {purec:data -> cache.<pfunction>.'<input>'.result} and the return value is cached in {purec:data -> cache.<pfunction>.'<input>'.return}
#--------------------
# 1 - success
# -1 - there is no entry for <pfunction> in the {purec:data -> pfunction} object
# -2 - <pfunction> returned a failure for the given <input>
#--------------------

execute unless data storage purec:in run.input run data modify storage purec:in run.input set value {}

data remove storage purec:out run
scoreboard players set *run.return --purec 1
execute store result score *run.check -purec run function purec:_/impl/run/check with storage purec:in run
execute unless score *run.check -purec matches 1 run function purec:_/impl/run/run with storage purec:in run

# volitile reading, only works because of how the control flow works out, and how this check is explicitly for 0 and not NOT 1..
execute if score *run.exists -purec matches 0 run scoreboard players set *run.return --purec -1

data remove storage purec:in run
data remove storage purec:var run
scoreboard players reset *run.check -purec
scoreboard players reset *run.exists -purec

return run scoreboard players get *run.return --purec