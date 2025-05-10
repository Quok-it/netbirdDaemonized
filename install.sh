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

if ! netbird service install; then
  log_error "Failed to install Netbird service."
fi

if ! netbird service start; then
  log_error "Failed to start Netbird service."
fi
# ------------------------------------------------------------------------------
# 6. Connect to management server
# ------------------------------------------------------------------------------

echo "Configuring Netbird"

if ! netbird up --setup-key="${SETUP_KEY}" --management-url="${MANAGEMENT_URL}" --admin-url="${MANAGEMENT_URL}"; then
  log_error "Netbird login failed."
fi


# ------------------------------------------------------------------------------
# 7. Start Netbird
# ------------------------------------------------------------------------------

if ! netbird up; then
  log_error "Failed to bring Netbird up."
fi

echo "Script execution completed."
