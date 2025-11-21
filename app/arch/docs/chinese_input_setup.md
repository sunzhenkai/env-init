# Installing Chinese Input Methods on Arch Linux

This guide will help you set up Chinese input methods on Arch Linux. We'll use Fcitx5 which is the current recommended input method framework.

## Installation Steps

### 1. Install Fcitx5 and Chinese Input Methods

```bash
# Install Fcitx5 base packages
sudo pacman -S fcitx5-im fcitx5-chinese-addons fcitx5-rkm

# Install additional packages if needed
sudo pacman -S fcitx5-pinyin fcitx5-pinyin-zhwiki fcitx5-configtool
```

### 2. AUR Packages (Optional)

If you prefer more input methods, you can install from AUR:

```bash
# Install yay if not already installed
sudo pacman -S yay

# Install additional Chinese input methods from AUR
yay -S fcitx5-sogoupinyin  # Sogou Pinyin
yay -S fcitx5-libpinyin    # Libpinyin
```

### 3. Configure Environment Variables

Add the following to your shell configuration file (e.g., `~/.bashrc`, `~/.zshrc`, or `~/.profile`):

```bash
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS="@im=fcitx5"
```

### 4. Configure Desktop Environment

For systemd-based autostart, create a user service:

```bash
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/fcitx5.service << EOF
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

systemctl --user enable fcitx5.service
systemctl --user start fcitx5.service
```

Alternatively, add to your desktop environment's startup:

For i3wm, add to `~/.config/i3/config`:
```
exec --no-startup-id fcitx5 -d
```

For other DEs, add `fcitx5 -d` to autostart applications.

### 5. Restart Your Session

Log out and log back in for the changes to take effect.

## Configuration

### Using Fcitx5 Configuration Tool

1. Launch the configuration tool:
   ```bash
   fcitx5-configtool
   ```

2. In the "Input Method" tab, add Chinese input methods like:
   - Chinese - Pinyin
   - Chinese - Rime (if installed)

3. Adjust settings as needed in other tabs.

### Additional Configuration Files

Fcitx5 configuration is located at:
- `~/.config/fcitx5/`

## Troubleshooting

### 1. Input method not appearing
- Make sure environment variables are set in the correct shell config file
- Check that you're using the same shell for which you configured the variables

### 2. Switch between input methods
- Default: Ctrl+Space to toggle input methods
- You can change this in the configuration tool

### 3. Input method not working in some applications
- Make sure you're not running applications with sudo that bypass user environment variables
- Some Java applications might need special configuration:
  ```bash
  export _JAVA_AWT_WM_NONREPARENTING=1
  ```

## Alternative: IBus

If you prefer IBus instead of Fcitx5:

```bash
sudo pacman -S ibus ibus-rime ibus-pinyin
```

Then set environment variables:
```bash
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS="@im=ibus"
```

And auto-start IBus instead of Fcitx5.

## Verification

To verify the installation works:
1. Make sure Fcitx5 is running: `ps aux | grep fcitx5`
2. Check input methods in the configuration tool
3. Try typing in a text editor