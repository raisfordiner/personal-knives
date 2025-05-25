#!/bin/bash

set -e

INSTALL_DIR="$HOME/applications/discord/data"
DOWNLOAD_DIR="/tmp/discord-download"
DISCORD_URL="https://discord.com/api/download?platform=linux&format=tar.gz"
DESKTOP_FILE="$HOME/.local/share/applications/discord.desktop"

mkdir -p "$INSTALL_DIR"
mkdir -p "$DOWNLOAD_DIR"

echo "Downloading Discord..."
curl -L "$DISCORD_URL" -o "$DOWNLOAD_DIR/discord.tar.gz"

tar -xf "$DOWNLOAD_DIR/discord.tar.gz" -C "$DOWNLOAD_DIR"

VERSION=$(date +%Y%m%d_%H%M%S)
mv "$DOWNLOAD_DIR/Discord" "$INSTALL_DIR/Discord-$VERSION"

ln -sfn "$INSTALL_DIR/Discord-$VERSION" "$INSTALL_DIR/current"

rm -rf "$DESKTOP_FILE"
if [ ! -f "$DESKTOP_FILE" ]; then
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Discord (Manual)
Exec=env DISPLAY=:11 $INSTALL_DIR/current/Discord
Icon=$INSTALL_DIR/current/discord.png
Type=Application
Categories=Network;Chat;
EOF
    echo "Recreated $DESKTOP_FILE"
fi

echo "Discord downloaded successfully at: $INSTALL_DIR/current"

echo "Installing Vencord"
~/applications/discord/VencordInstallerCli-linux -install -location ~/applications/discord/data/current

echo "Let's go!!"
