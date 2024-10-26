
# Pure Cache | purec
> Library for dynamically caching the results of pure functions.

## Dependencies
- [load](https://github.com/sixslime/load)

# Overview
A pure function is one that's output **only** depends on it's input. (i.e. given the same input(s), will **always** produce the same output(s).)

Given this definition, if a pure function is called multiple times with the same input, it really only needs to actually execute once--on the first call--while the successive calls *should* be able to just use the output from the first call. \
This is concept is particularly practical if said function is expensive to execute.

Pure Cache aims to do just this. It allows datapacks to define pure functions, then automatically caches output for each call, and will reference cached output if a pure function is called with previously seen input.


# Usage
Any dependent datapack must be using the [load](https://github.com/sixslime/load) paradigm and have Pure Cache load before it.

## Defining Pure Functions
### Function Identifier
A pure function must have a PFunctionIdentifier, which effectively acts as it's name. \
A PFunctionIdentifier must be in a format similar to NBT storage locations: `<namespace>:<arbitrary path>`. (ex: `mypack:some_category/my_function`) \
By convention, `<namespace>` must be the namespace that the pure function is being defined in. 

### Function Definition
To define a pure function, add an entry under the path `pfunction.<PFunctionIdentifier>` in storage `purec:data` with a **macro string** containing the command that the pure function should execute (referred to as the function body.) \
*Though the function body can technically be any command, anything other than `function <internal function>` would most likely be impractical.*

It is standard to define pure functions in or in a sub-function of your datapack's load function.

*Because PFunctionIdentifiers contain a ":", the NBT key needs to be quoted (ex: `pfunction."mypack:my_function"`).*

### Function Body
When a pure function is called (with un-cached inputs) it first sets `this[-1].input` in storage `purec:data` to the input given to the function (`run.input` when calling `purec:api/run`), then it executes it's body.

Any data contained in `this[-1].output` under storage `purec:data` after the function body is executed is deemed the output of the function.

## Calling Pure Functions
To call a defined pure function, run `purec:api/run` with the following inputs under NBT storage `purec:in`:
| NBT path | Type | Default Value |
|--|--|--|
| `run.pfunction` | string (PFunctionIdentifier) | *(none)* |
| `run.input` | object | {} |

This will call **\<pfunction\>** with the input **\<input\>**. \
`run.output` in `purec:out` is set to the output of **\<pfunction\>**.

`purec:api/run` has the following return codes:
- 1 : Success (no issues).
- -1 : There is no definition for **\<pfunction\>** (no entry under `pfunction.<pfunction>` in `purec:data`).
- -2 : **\<pfunction\>** itself returned a zero or negative code.

### Caching Behavior
If **\<pfunction\>** has never been called with **\<input\>**, the function body will execute and the output will be cached. \
If **\<pfunction\>** has already been called with the same **\<input\>**, the cached output of the previous call is retrieved.

## Clearing Cache / Removing Definitions
All cached outputs for a given pure function are under `cache.<PFunctionIdentifier>` in storage `purec:data`.

It is standard to clear the cache of your datapack's pure functions in or in a sub-function of your datapack's load function. \
*(Clearing the cache simply means using `data remove`.)*

To remove a defined pure function, simply remove the `pfunction.<PFunctionIdentifier>` key from `purec:data`.

Pure Cache does not automatically remove definitions or clear it's cache. \
It is recommended that a datapack remove all of it's pure function definitions and cache in an "uninstall" function.

# Example
Defines `mypack:add`, which takes two input numbers, `num_a` and `num_b`, adds them, and provides the result under `result`:
```mcfunction
#(load function)
data modify storage purec:data pfunction.'mypack:add' set value "function mypack:_/pure/add_body"
```

`data/mypack/function/_/pure/add_body.mcfunction`:
```mcfunction
# get inputs from purec:data 'this[-1].input':
execute store result score *add.result -mypack run data get storage purec:data this[-1].input.num_a
execute store result score *add.b -mypack run data get storage purec:data this[-1].input.num_b

# add numbers
scoreboard players operation *add.result -mypack += *add.b -mypack

# set the output of this function via 'this[-1].output':
execute store result storage purec:data this[-1].output.result int 1 run scoreboard players get *add.result -mypack
#<...>
```

The pure function can then be called like so:
```mcfunction
data merge storage purec:in {run:{pfunction:"mypack:add", input:{num_a:10, num_b:15}}}
function purec:api/run
data get storage purec:out run.output
# = {result:35}
```

A demonstration of caching behavior:
```mcfunction
data merge storage purec:in {run:{pfunction:"mypack:add", input:{num_a:20, num_b:30}}}
function purec:api/run
data get storage purec:out run.output
# = {result:50}
# pure function body was executed, output cached.

data merge storage purec:in {run:{pfunction:"mypack:add", input:{num_a:10, num_b:5}}}
function purec:api/run
data get storage purec:out run.output
# = {result:15}
# pure function body was executed again due to different inputs, output cached.

data merge storage purec:in {run:{pfunction:"mypack:add", input:{num_a:20, num_b:30}}}
function purec:api/run
data get storage purec:out run.output
# = {result:50}
# these exact inputs have been used before, output was retrieved from cache, pure function body NOT executed.
```

Clear `mypack:add`'s cache:
```mcfunction
data remove storage purec:data cache.'mypack:add'
# it would be standard to put this in the same file where 'mypack:add' is defined.
```

### Note:
Pure function definitions with very simple bodies (such as adding two numbers) should be avoided during real use. \
This is because running a pure function via Pure Cache has a rough overhead cost of 15 `data` commands; anything less expensive than this would be better off executed directly.

# Known Issues

- Inputs to pure functions cannot contain any single quotes (`'`). 
___

<p align="center">
  <img src="https://raw.githubusercontent.com/sixslime/sixslime.github.io/refs/heads/main/info/logos/temporary_documentation.svg" width="75%" alt="Temporary Documentation Tag"/>
</p>
