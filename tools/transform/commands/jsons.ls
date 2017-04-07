require! <[fs]>

ERR_EXIT = (message, code) -> 
	console.error message
	return process.exit code

module.exports = exports =
	command: \jsons
	describe: "load several json files, and merge them in order"
	builder: (yargs) ->
		yargs
			.alias \h, \help
			.alias \o, \output
			.describe \o, "the path to output json file"
			.demand <[o]>
			.boolean <[h]>

	handler: (argv) ->
		{output} = argv
		files = argv._
		files.shift!
		# console.error "files => #{JSON.stringify files}"
		j0 = files.shift!
		# console.error "loading #{j0}"
		text = fs.readFileSync j0
		global.context = JSON.parse text
		for f in files
			console.error "loading #{f}"
			text = fs.readFileSync f
			json = JSON.parse text
			for key, value of json
				global.context[key] = value
		text = JSON.stringify global.context
		(write-err) <- fs.writeFile output, text
		return ERR_EXIT "failed to write #{output} because of #{write-err}", 1 if write-err?
		return process.exit 0

