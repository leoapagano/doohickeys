# bash-speedtest

A Bash script I wrote to readably diagnose and benchmark the link between my laptop and my server.

If you use [Tailscale](https://tailscale.com/) to allow your machines to talk to one another, regardless of where they are, it will ping the machine. You can use this to determine whether your connection is direct or whether it goes through a DERP relay (and if so, which DERP relay). It will also determine the latency between your machines.

If the device you're connecting to has an [iperf3](https://iperf.fr/) (*not* iperf) server running on it, it will also tell you the link speed (in both directions) between your devices, and will give you an estimate for how long it will take to send or receive 1GB.

This script is designed for use on both macOS and Linux. If you are on macOS, and you use Tailscale, and you have not done so already, please add the following alias to `~/.zshrc`;

```bash
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
```

Dependencies;

- [iperf3](https://iperf.fr/iperf-download.php)
- [jq](https://github.com/jqlang/jq/releases)
- [tailscale](https://tailscale.com/download) (optional)

Setup;

- Add the `.bash-speedtest.sh` file to your home directory
- Add the following line to your `.bashrc` or `.zshrc`;

```bash
source ~/.bash-speedtest.sh
```

- Customize it! Add alias(es) like these to the beginning of `.bash-speedtest`;

```bash
# Feel free to name your alias(es) whatever you like.
# First argument: Tailscale target machine name
# Second argument: Target machine hostname or IP address
alias example-speedtest="bash-speedtest example example.com"
alias myserver-speedtest="bash-speedtest myserver myserver.net"
alias myrpi-speedtest="bash-speedtest myrpi 192.168.1.70"
```

To run, simply type `example-speedtest`, or whatever you named your custom alias(es), into a new terminal.

Example use:

```bash
# Add this to ~/.bash-speedtest.sh
alias pqrs-speedtest="bash-speedtest PQRS 100.126.98.47"
```

```
leo@leos-mbp ~ % pqrs-speedtest
Attempting to reach PQRS...
pong from pqrs (100.126.98.47) via DERP(nyc) in 18ms
pong from pqrs (100.126.98.47) via DERP(nyc) in 18ms
pong from pqrs (100.126.98.47) via DERP(nyc) in 18ms
pong from pqrs (100.126.98.47) via DERP(nyc) in 22ms
pong from pqrs (100.126.98.47) via DERP(nyc) in 17ms
2024/11/07 15:07:27 direct connection not established
Downloading from PQRS... 26.8 Mbps (3.35 MB/s) or 5m6s/1GB
Uploading to PQRS...     36.8 Mbps (4.6 MB/s) or 3m43s/1GB
```

### Tools Used

- Bash
- TCP/IP
- JSON/jq
- Tailscale