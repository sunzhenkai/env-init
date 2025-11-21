#!/bin/bash

# Script to set up Chinese input methods on Arch Linux
# This script installs fcitx5 and configures environment variables

set -e # Exit on any error

echo "Setting up Chinese input methods on Arch Linux..."

# Function to install packages using pacman and yay
install_packages() {
  echo "Installing required packages..."

  # Install core fcitx5 packages
  sudo pacman -S --noconfirm fcitx5-im fcitx5-chinese-addons #

  ifcitx5-pinyin

  # Install configuration tool
  sudo pacman -S --noconfirm fcitx5-configtool

  # Optional: install additional dictionaries
  sudo pacman -S --noconfirm fcitx5-pinyin-zhwiki

  echo "Packages installed successfully!"
}

# Function to configure environment variables
configure_environment() {
  echo "Configuring environment variables..."

  # Detect shell and add environment variables to the appropriate config file
  if [ -n "$ZSH_VERSION" ]; then
    CONFIG_FILE="$HOME/.zshrc"
  elif [ -n "$BASH_VERSION" ]; then
    CONFIG_FILE="$HOME/.bashrc"
  else
    CONFIG_FILE="$HOME/.bashrc" # Default to bashrc
  fi

  # Check if environment variables are already configured
  if ! grep -q "GTK_IM_MODULE=fcitx5" "$CONFIG_FILE"; then
    echo "" >>"$CONFIG_FILE"
    echo "# Fcitx5 Input Method" >>"$CONFIG_FILE"
    echo "export GTK_IM_MODULE=fcitx5" >>"$CONFIG_FILE"
    echo "export QT_IM_MODULE=fcitx5" >>"$CONFIG_FILE"
    echo 'export XMODIFIERS="@im=fcitx5"' >>"$CONFIG_FILE"
    echo "Environment variables added to $CONFIG_FILE"
  else
    echo "Environment variables already configured in $CONFIG_FILE"
  fi
}

# Function to set up systemd service for fcitx5
setup_systemd_service() {
  echo "Setting up systemd service for fcitx5..."

  mkdir -p ~/.config/systemd/user

  cat >~/.config/systemd/user/fcitx5.service <<'EOF'
[Unit]
Description=Fcitx5 input method
Documentation=man:fcitx5(1)

[Service]
Type=forking
Environment=LC_ALL=zh_CN.UTF-8
ExecStart=/usr/bin/fcitx5 -d
ExecReload=/usr/bin/fcitx5 -r

[Install]
WantedBy=default.target
EOF

  # Enable and start the service
  systemctl --user daemon-reload
  systemctl --user enable fcitx5.service
  systemctl --user start fcitx5.service

  echo "Systemd service for fcitx5 set up and started!"
}

# Function to create basic fcitx5 configuration
setup_fcitx_config() {
  echo "Setting up basic fcitx5 configuration..."

  # Create config directory if it doesn't exist
  mkdir -p ~/.config/fcitx5

  # Create input method configuration
  mkdir -p ~/.config/fcitx5/conf
  cat >~/.config/fcitx5/inputmethod.conf <<'EOF'
[Groups/0]
Name=Default
DefaultIM=pinyin

[Groups/0/Items/0]
Name=pinyin
Weight=100

[Groups/0/Items/1]
Name=keyboard-us
Weight=0
EOF

  echo "Basic fcitx5 configuration created!"
}

# Main execution
main() {
  echo "This script will:"
  echo "1. Install fcitx5 and Chinese input methods"
  echo "2. Configure environment variables"
  echo "3. Set up systemd service"
  echo "4. Create basic configuration"
  echo ""

  read -p "Do you want to continue? (y/N): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_packages
    configure_environment
    setup_systemd_service
    setup_fcitx_config

    echo ""
    echo "Setup completed!"
    echo "Please log out and log back in for all changes to take effect."
    echo ""
    echo "After logging back in, you can configure input methods using:"
    echo "fcitx5-configtool"
    echo ""
    echo "You can also check if fcitx5 is running with:"
    echo "ps aux | grep fcitx5"
  else
    echo ""
    echo "Setup cancelled."
    exit 1
  fi
}

main "$@"
