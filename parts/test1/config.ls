dependencies:
	# The debian packages to be installed
	# via `apt-get install`.
	#
	debian:
		# Utilities
		#
		* <[
			socat
			screen
			vim
		]>

	# The python2 packages to be installed via 
	# `pip install`
	#
	python2: <[
		httpie
		colorama
	]>

	# The python3 packages to be installed via 
	# `pip3 install`
	#
	python3: <[
		psutil
	]>
