require! <[fs]>

ERR_EXIT = (message, code) -> 
	console.error message
	return process.exit code


TRAVERSE_JSON = (root, queue) ->
	{kvs} = global
	return kvs.push [(queue.join \_), root] unless \object is typeof root
	for k, v of root
		xs = [ x for x in queue ]
		xs.push k
		TRAVERSE_JSON v, xs

FLAT_TRANSFORM = (json) ->
	global.kvs = []
	global.result = {}
	TRAVERSE_JSON json, []
	# console.log "global.kvs = #{JSON.stringify global.kvs, null, ' '}"
	# process.exit 1
	for kv in global.kvs
		global.result[kv[0]] = kv[1]
	return global.result


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
			.alias \f, \flat
			.describe \f, "transform the json tree to a flat array of key-value pairs"
			.default \f, no
			.demand <[s o]>
			.boolean <[h f]>

	handler: (argv) ->
		{source, output, prefix, flat} = argv
		(read-err, buffer) <- fs.readFile source
		return ERR_EXIT "failed to read #{source} because of #{read-err}", 1 if read-err?
		text = "#{buffer}"
		json = JSON.parse text
		json = FLAT_TRANSFORM json if flat
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
		return global.safe-exit!
