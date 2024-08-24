#> purec:api > run
#--------------------
# -> function: PurecIdentifier
# => input: obj = {}
#--------------------
# <- result: obj
#--------------------
#> attemps to get the cached result associated with the <function> and <input>;
#> if it does not exist, generate it by actually running the command associated with <function>.
#--------------------
#- >result< is cached in {purec:data -> cache.<function>.'<input>'.result} and the return value is cached in {purec:data -> cache.<function>.'<input>'.return}
#--------------------
# 1 - success
# -1 - there is no entry for <function> in the {purec:data -> function} object
# -2 - <function> returned a failure for the given <input>
#--------------------

execute unless data storage purec:in run.input run data modify storage purec:in run.input set value {}

data remove storage purec:out run
scoreboard players set *run.return --purec 1
execute store result score *run.check -purec run function purec:_/impl/run/check with storage purec:in run
execute unless score *run.check -purec matches 1 run function purec:_/impl/run/run with storage purec:in run
execute if score *run.exists -purec matches 0 run scoreboard players set *run.return --purec -1

data remove storage purec:in run
data remove storage purec:var run
scoreboard players reset *run.check -purec
scoreboard players reset *run.exists -purec

return run scoreboard players get *run.return --purec