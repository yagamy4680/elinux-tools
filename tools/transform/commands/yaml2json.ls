require! <[fs handlebars js-yaml]>

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


FLAT_TRANSFORM = (json, prefix) ->
	global.kvs = []
	global.result = {}
	TRAVERSE_JSON json, []
	# console.log "global.kvs = #{JSON.stringify global.kvs, null, ' '}"
	# process.exit 1
	for kv in global.kvs
		[key, value] = kv
		key = if prefix is "" then key else "#{prefix}_#{key}"
		key = key.replace /-/g, '_'
		global.result[key] = value
	return global.result



module.exports = exports =
	command: \yaml2json
	describe: "load yaml config as handlebar template, merge with environment variables, and compiled to json output"
	builder: (yargs) ->
		yargs
			.alias \h, \help
			.alias \s, \source
			.describe \s, "the path to config source file"
			.alias \o, \output
			.describe \o, "the path to output json file"
			.alias \f, \flat
			.describe \f, "apply flat transformation"
			.default \f, no
			.alias \p, \prefix
			.describe \p, "prefix used in flat transformation"
			.default \p, ""
			.demand <[s o]>
			.boolean <[h f]>

	handler: (argv) ->
		{source, output, flat, prefix} = argv
		console.error "config => #{source}"
		(read-err, buffer) <- fs.readFile source
		return ERR_EXIT "failed to read #{source} because of #{read-err}", 1 if read-err?
		src = "#{buffer}"
		template = handlebars.compile src
		text = template process.env
		xs = jsYaml.safeLoad text
		xs = {} unless xs?
		xs = FLAT_TRANSFORM xs, prefix if flat
		text = JSON.stringify xs
		(write-err) <- fs.writeFile output, text
		return ERR_EXIT "failed to write #{output} because of #{write-err}", 2 if write-err?
		return global.safe-exit!
