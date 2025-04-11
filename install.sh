#!/bin/bash
# This script installs Netbird, sets up its configuration and directories (sourced from quok.it's repos),
# creates a dedicated system user, installs a systemd service,
# enables it to start on boot, and then starts the Nomad agent.

# ------------------------------------------------------------------------------
# 1. Check for root privileges.
# ------------------------------------------------------------------------------
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root. Use sudo." >&2
  exit 1
fi

# ------------------------------------------------------------------------------
# 2. Variables (adjust these as needed)
# ------------------------------------------------------------------------------

SETUP_KEY="$1"

MANAGEMENT_URL="https://netbird.quok.it"

# ------------------------------------------------------------------------------
# 3. Ensure required tools are installed.
# ------------------------------------------------------------------------------

apt install -y snapd

# ------------------------------------------------------------------------------
# 4. install netbird
# ------------------------------------------------------------------------------

curl -fsSL https://pkgs.netbird.io/install.sh | sh

# ------------------------------------------------------------------------------
# 5. Set up netbird
# ------------------------------------------------------------------------------

# for self hosted

echo "Starting Netbird daemon"

netbird service install

netbird service start

echo "configuring Netbird"

netbird login --setup-key=${SETUP_KEY} --management-url=${MANAGEMENT_URL}

# ------------------------------------------------------------------------------
# 6. Make sure installation went smoothly
# ------------------------------------------------------------------------------

snap services netbird

# ------------------------------------------------------------------------------
# 7. Start netbird
# ------------------------------------------------------------------------------

netbird up
