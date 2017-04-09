require! <[fs handlebars livescript]>

ERR_EXIT = (message, code) -> 
	console.error message
	return process.exit code

module.exports = exports =
	command: \ls2json
	describe: "load livescript as handlebar template, merge with environment variables, and compiled to json output"
	builder: (yargs) ->
		yargs
			.alias \h, \help
			.alias \s, \source
			.describe \s, "the path to livescript source file"
			.alias \o, \output
			.describe \o, "the path to output json file"
			.demand <[s o]>
			.boolean <[h]>

	handler: (argv) ->
		{source, output} = argv
		# console.error "config => #{source}"
		(read-err, buffer) <- fs.readFile source
		return ERR_EXIT "failed to read #{source} because of #{read-err}", 1 if read-err?
		src = "#{buffer}"
		template = handlebars.compile src
		text = template process.env
		xs = livescript.compile text, {json: yes}
		xs = JSON.parse xs
		text = JSON.stringify xs
		(write-err) <- fs.writeFile output, text
		return ERR_EXIT "failed to write #{output} because of #{write-err}", 2 if write-err?
		return global.safe-exit!

