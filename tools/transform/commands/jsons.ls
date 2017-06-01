require! <[fs]>
merge = require \lodash.merge

ERR_EXIT = (message, code) -> 
	console.error message
	return process.exit code

READ_FILE_AS_JSON = (f) ->
	[name, file] = tokens = f.split \:
	return JSON.parse fs.readFileSync name unless file?
	result = {}
	result[name] = JSON.parse fs.readFileSync file
	return result


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
		jsons = [ READ_FILE_AS_JSON f for f in files ]
		jsons = [ {} ] ++ jsons
		result = merge.apply null, jsons
		text = JSON.stringify result
		(write-err) <- fs.writeFile output, text
		return ERR_EXIT "failed to write #{output} because of #{write-err}", 1 if write-err?
		return global.safe-exit!

