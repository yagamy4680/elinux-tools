require! <[fs]>

ERR_EXIT = (message, code) -> 
	console.error message
	return process.exit code

module.exports = exports =
	command: \json2env
	describe: "convert json file to BASH environment variable script for import"
	builder: (yargs) ->
		yargs
			.alias \h, \help
			.alias \p, \prefix
			.describe \p, "the prefix of output bash variable"
			.default \p, ""
			.alias \s, \source
			.describe \s, "the path to source json file to process"
			.alias \o, \output
			.describe \o, "the path to output bash file"
			.demand <[s o]>
			.boolean <[h]>

	handler: (argv) ->
		{source, output, prefix} = argv
		(read-err, buffer) <- fs.readFile source
		return ERR_EXIT "failed to read #{source} because of #{read-err}", 1 if read-err?
		text = "#{buffer}"
		json = JSON.parse text
		global.context = []
		for key, value of json
			xs = null
			ys = null
			xs = JSON.stringify value if \object is typeof value
			xs = "#{value}" unless xs?
			ys = if prefix is "" then key else "#{prefix}_#{key}"
			ys = ys.replace /-/g, '_'
			ys = ys.to-upper-case!
			line = "export #{ys}=\"#{xs}\""
			# console.error "#{key}: #{value} => #{line}"
			global.context.push line
		global.context.push ""
		xs = global.context.join "\n"
		(write-err, buffer) <- fs.writeFile output, xs
		return ERR_EXIT "failed to write #{output} because of #{write-err}", 2 if write-err?
		return process.exit 0
