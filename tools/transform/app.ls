#!/usr/bin/env lsc
#
global.start-time = new Date!
global.safe-exit = ->
	# console.log "\ttotal time: #{(new Date!) - global.start-time}"
	return process.exit 0

require! <[yargs]>

argv = 
	yargs
		.alias \h, \help
		.command require \./commands/yaml2json
		.command require \./commands/ls2json
		.command require \./commands/jsons
		.command require \./commands/json2env
		.demand 1
		.strict!
		.help!
		.argv

