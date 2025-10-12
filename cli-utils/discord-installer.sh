#!/bin/bash

set -e

INSTALL_DIR="$HOME/applications/discord/Discord"
DOWNLOAD_DIR="/tmp/discord-download"
DISCORD_URL="https://discord.com/api/download?platform=linux&format=tar.gz"
DESKTOP_FILE="$HOME/.local/share/applications/discord.desktop"
VENCORD_URL="https://github.com/Vendicated/VencordInstaller/releases/latest/download/VencordInstallerCli-Linux"
VENCORD_DIR="$DOWNLOAD_DIR/vencord"

var=""

for arg in "$@"; do
    case "$arg" in
        --var=*)
            var="${arg#--var=} "
            ;;
        *)
            args+=("$arg")
            ;;
    esac
done

rm -rf "$INSTALL_DIR"

mkdir -p "$INSTALL_DIR"
mkdir -p "$DOWNLOAD_DIR"

echo "Downloading Discord..."
curl -L "$DISCORD_URL" -o "$DOWNLOAD_DIR/discord.tar.gz"

tar -xf "$DOWNLOAD_DIR/discord.tar.gz" -C "$DOWNLOAD_DIR"

mv "$DOWNLOAD_DIR/Discord" "$INSTALL_DIR/.."

rm -rf "$DESKTOP_FILE"
if [ ! -f "$DESKTOP_FILE" ]; then
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Discord (Manual)
Exec=$var$INSTALL_DIR/Discord
Icon=$INSTALL_DIR/discord.png
Type=Application
Categories=Network;Chat;
EOF
    echo "Recreated $DESKTOP_FILE"
fi

echo "Discord downloaded successfully at: $INSTALL_DIR"

echo "Installing Vencord"

curl -sSLf "$VENCORD_URL" -o $VENCORD_DIR
chmod a+x $VENCORD_DIR
$VENCORD_DIR -install -location $INSTALL_DIR

rm -rf $DOWNLOAD_DIR

echo "Let's go!!"
