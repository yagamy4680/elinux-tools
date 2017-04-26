dependencies:
	# The debian packages to be installed
	# via `apt-get install`.
	#
	debian:
		# Wireless Network Tools.
		#
		* <[
			wireless-tools
			iw
			wpasupplicant
		]>

		# System monitors and utilities
		# 
		* <[
			sysstat
			htop
			nethogs
			parted
			dnsutils
			lsof
		]>

		# Development tools
		# 
		* <[
			build-essential
			cmake
		]>

		# Utilities
		#
		* <[
			gawk
			jq
			socat
			screen
			xz-utils
			vim
			telnet
			virt-what
		]>

		# For ntpd daemon and sntp tool.
		# 
		* <[
			ntp
		]>

		# For Wireless HotSpot feature.
		#
		* <[
			hostapd
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
		httpie
		colorama
		psutil
	]>
