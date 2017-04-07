#!/usr/bin/env lsc
#
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

