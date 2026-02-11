#!/bin/bash

# ==============================================
#        Made by NS Jagat yt (Fixed Version)
#   TOR IP Rotator + Privoxy for Android Proxy
# ==============================================

clear
echo -e "\e[34m===========================================\e[0m"
echo -e "\e[32m        Made by NS Jagat yt\e[0m"
echo -e "\e[36m  TOR IP Rotator + Browser Support\e[0m"
echo -e "\e[34m===========================================\e[0m"
echo ""

# -------------------------------
# Step 1: Update repos & install packages
# -------------------------------
echo -e "\e[33m[*] Updating Termux packages...\e[0m"
pkg update -y && pkg upgrade -y

echo -e "\e[33m[*] Installing dependencies...\e[0m"
pkg install curl -y
pkg install tor -y
pkg install netcat-openbsd -y
pkg install privoxy -y
pkg install busybox -y
pkg install coreutils -y
pkg install tur-repo -y
# -------------------------------
# Step 2: Setup TOR configuration
# -------------------------------
TORRC="$PREFIX/etc/tor/torrc"
PASSWORD="mypass"
mkdir -p $PREFIX/etc/tor

HASH=$(tor --hash-password $PASSWORD | tail -n 1)

cat <<EOF > $TORRC
ControlPort 9051
HashedControlPassword $HASH
SocksPort 9050
ExitNodes {us}
StrictNodes 1
EOF

echo -e "\e[32m[*] TOR config applied!\e[0m"

# -------------------------------
# Step 3: Setup Privoxy for Android Browser
# -------------------------------
PRIVOXY_CFG="$PREFIX/etc/privoxy/config"

cat <<EOF > $PRIVOXY_CFG
listen-address  127.0.0.1:8118
forward-socks5t / 127.0.0.1:9050 .
toggle 1
enable-remote-toggle 0
enable-edit-actions 0
buffer-limit 4096
EOF

echo -e "\e[32m[*] Privoxy configured (HTTP→SOCKS5 bridge)!\e[0m"
echo -e "\e[32m[*] Set Android WiFi Proxy → 127.0.0.1:8118\e[0m"

# -------------------------------
# Step 4: Timer Menu
# -------------------------------
echo ""
echo -e "\e[33m[*] Choose IP rotation time:\e[0m"
echo "1) 5 sec"
echo "2) 10 sec"
echo "3) 30 sec"
echo "4) 60 sec"
read -p "Select (1-4): " CHOICE

case $CHOICE in
    1) DELAY=5 ;;
    2) DELAY=10 ;;
    3) DELAY=30 ;;
    4) DELAY=60 ;;
    *) DELAY=10 ;;
esac

LOGFILE="$HOME/ip_logs.txt"

# -------------------------------
# Step 5: Start TOR + Privoxy
# -------------------------------
echo -e "\e[36m[*] Starting TOR...\e[0m"
tor > /dev/null 2>&1 &
sleep 8

echo -e "\e[36m[*] Starting Privoxy...\e[0m"
privoxy $PRIVOXY_CFG > /dev/null 2>&1 &
sleep 3

# Only Termux tools use Tor SOCKS proxy
export http_proxy="socks5://127.0.0.1:9050"
export https_proxy="socks5://127.0.0.1:9050"

echo -e "\e[32m[*] Tor + Privoxy Running Successfully!\e[0m"
echo -e "\e[32m[*] Android Browser Proxy: 127.0.0.1:8118\e[0m"
echo ""

# -------------------------------
# Step 6: IP Rotation Loop
# -------------------------------
while true
do
    # If TOR crashes, restart
    if ! pgrep -x tor > /dev/null
    then
        echo -e "\e[31m[!] TOR crashed! Restarting...\e[0m"
        tor > /dev/null 2>&1 &
        sleep 6
    fi

    # Send newnym signal
    echo -e "authenticate \"$PASSWORD\"\nsignal newnym\nquit" | nc 127.0.0.1 9051
    sleep 2

    NEWIP=$(curl --socks5 127.0.0.1:9050 -s https://api.ipify.org)

    if [ -z "$NEWIP" ]; then
        echo -e "\e[31m[!] IP fetch error. Retrying...\e[0m"
        sleep 3
        continue
    fi

    echo -e "\e[35m[+] New TOR IP: $NEWIP\e[0m"
    echo "$(date) → $NEWIP" >> "$LOGFILE"

    echo -e "\e[34m[*] Next rotation in $DELAY sec...\e[0m"
    sleep $DELAY
done
