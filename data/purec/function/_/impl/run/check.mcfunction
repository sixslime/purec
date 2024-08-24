#> purec:_/impl/run/check
#--------------------
# @api
#--------------------

$data modify storage purec:var run.entry set from storage purec:data cache.'$(function)'.'$(input)'
execute unless data storage purec:var run.entry{_:true} run return 0

execute store result score *run.return --purec run data get storage purec:var run.entry.return
execute if score *run.return --purec matches ..0 run scoreboard players set *run.return --purec -2
data modify storage purec:out run.result set from storage purec:var run.entry.result

return 1