# lowk this might be all we need

set -e

# ------------------------------------------------------------------------------
# 1. Check for root privileges.
# ------------------------------------------------------------------------------
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root. Use sudo." >&2
  exit 1
fi

# ------------------------------------------------------------------------------
# 2. Stop and uninstall the netbird daemon
# ------------------------------------------------------------------------------

netbird service stop

netbird service uninstall

# ------------------------------------------------------------------------------
# 3. Remove config data & netbird with snap
# ------------------------------------------------------------------------------

#this might b a little scorched earth, but this must be done to prevent reconnection to the management server
rm -rf /var/lib/netbird

rm -rf /etc/netbird

sudo apt remove netbird
