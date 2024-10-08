#> purec:_/impl/run/run
#--------------------
# @api
#--------------------

$execute store result score *run.exists -purec run data modify storage purec:var run.pfunction.command set from storage purec:data pfunction.'$(pfunction)'

execute unless score *run.exists -purec matches 1.. run return fail

data modify storage purec:data this append value {input:{},result:{}}
data modify storage purec:data this[-1].input set from storage purec:in run.input

execute store result storage purec:var run.out.return int 1 run function purec:_/impl/run/run.1 with storage purec:var run.pfunction

data modify storage purec:var run.out.result set from storage purec:data this[-1].result
data remove storage purec:data this[-1]

data merge storage purec:var {run:{out:{_:true}}}
$data modify storage purec:data cache.'$(pfunction)'.'$(input)' set from storage purec:var run.out

data modify storage purec:out run.result set from storage purec:var run.out.result

execute store result score *run.return --purec run data get storage purec:var run.out.return