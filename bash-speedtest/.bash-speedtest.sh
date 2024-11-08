bash-speedtest() {
	# This is used when printing out the user-friendly name.
	# If you're using Tailscale, this should be the Tailscale target machine name.
	SPEEDTEST_MACHINE_NAME="$1"
	# This is used as the hostname (or IP address) where the iperf3 server lives.
	SPEEDTEST_HOSTNAME="$2"

	# DERP test
	if which tailscale &> /dev/null; then
		echo "Attempting to reach $SPEEDTEST_MACHINE_NAME..."
		tailscale ping --c=5 $SPEEDTEST_MACHINE_NAME
	else
		echo "Tailscale not installed or not found in PATH. Skipping..."
	fi

	# iperf3/jq dependency check
	if ! which iperf3 &> /dev/null; then
		echo "Missing dependency: iperf3. Quitting!"
		exit 2
	fi
	if ! which jq &> /dev/null; then
		echo "Missing dependency: jq. Quitting!"
		exit 2
	fi

	# Check if iperf3 server is up and running
	iperf3 -c $SPEEDTEST_HOSTNAME -t 1 -i 1 &>/dev/null || { echo "iperf3 server not running/reachable on $SPEEDTEST_MACHINE_NAME. Quitting!"; exit 3; }

	# Download test
	echo -n "Downloading from $SPEEDTEST_MACHINE_NAME... "
	iperf3 -c $SPEEDTEST_HOSTNAME -4 -O 2 -t 6 --json | \
	jq -r "(.end.sum_received.bytes / .end.sum_received.seconds / 131072 | . * 10 | round / 10 | tostring) \
	+ \" Mbps (\" \
	+ (.end.sum_received.bytes / .end.sum_received.seconds / 1048576 | . * 100 | round / 100 | tostring) \
	+ \" MB/s) or \" \
	+ (.end.sum_received.seconds / .end.sum_received.bytes * 1073741824 | round | . / 60 | floor | tostring) \
	+ \"m\" \
	+ (.end.sum_received.seconds / .end.sum_received.bytes * 1073741824 | round | . % 60 | tostring) \
	+ \"s/1GB\""

	# Upload test
	echo -n "Uploading to $SPEEDTEST_MACHINE_NAME...     "
	iperf3 -c $SPEEDTEST_HOSTNAME -R -4 -O 2 -t 6 --json | \
	jq -r "(.end.sum_received.bytes / .end.sum_received.seconds / 131072 | . * 10 | round / 10 | tostring) \
	+ \" Mbps (\" \
	+ (.end.sum_received.bytes / .end.sum_received.seconds / 1048576 | . * 100 | round / 100 | tostring) \
	+ \" MB/s) or \" \
	+ (.end.sum_received.seconds / .end.sum_received.bytes * 1073741824 | round | . / 60 | floor | tostring) \
	+ \"m\" \
	+ (.end.sum_received.seconds / .end.sum_received.bytes * 1073741824 | round | . % 60 | tostring) \
	+ \"s/1GB\""
}