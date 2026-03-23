#!/bin/bash

# ==============================================
#        NS Jagat yt - INSANE CYBER UI
#   TOR Live Identity Rotator (Termux Edition)
# ==============================================

# -------- COLORS --------
R="\e[31m"; G="\e[32m"; Y="\e[33m"; B="\e[34m"
M="\e[35m"; C="\e[36m"; W="\e[37m"; N="\e[0m"

# -------- LOADING BAR --------
progress_bar() {
    msg=$1
    echo -ne "${C}$msg ${N}"
    for i in {1..20}; do
        echo -ne "${G}█${N}"
        sleep 0.05
    done
    echo ""
}

# -------- WORLD MAP BANNER --------
show_map() {
echo -e "${B}
        🌍 GLOBAL ROUTING MAP 🌍
   ┌───────────────┬───────────────┐
   │   USA 🇺🇸      │   EUROPE 🇪🇺   │
   │       ●───────●───────●       │
   │      /                 \      │
   │ INDIA 🇮🇳         JAPAN 🇯🇵 │
   │       ●──────────────●       │
   └───────────────┴───────────────┘
${N}"
}

# -------- CHECK INSTALL --------
install_if_missing() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${Y}[+] Installing $1...${N}"
        pkg install $2 -y > /dev/null 2>&1
    fi
}

echo -e "${B}[*] Initializing System...${N}"
pkg update -y > /dev/null 2>&1

install_if_missing curl curl
install_if_missing tor tor
install_if_missing nc netcat-openbsd
install_if_missing privoxy privoxy

clear

# -------- MAIN BANNER --------
echo -e "${G}
 ███╗   ██╗███████╗     ██╗ █████╗  ██████╗  █████╗ ████████╗
 ████╗  ██║██╔════╝     ██║██╔══██╗██╔════╝ ██╔══██╗╚══██╔══╝
 ██╔██╗ ██║███████╗     ██║███████║██║  ███╗███████║   ██║   
 ██║╚██╗██║╚════██║██   ██║██╔══██║██║   ██║██╔══██║   ██║   
 ██║ ╚████║███████║╚█████╔╝██║  ██║╚██████╔╝██║  ██║   ██║   
 ╚═╝  ╚═══╝╚══════╝ ╚════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   
${N}"

echo -e "${C}      ⚡ LIVE TOR IDENTITY CHANGER ⚡${N}\n"

show_map

# -------- PROXY GUIDE (ADDED) --------
echo -e "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
echo -e "${Y}📡 HOW TO CONNECT PROXY${N}"
echo -e "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
echo -e "${G}Step 1:${N} Open WiFi settings"
echo -e "${G}Step 2:${N} Modify Network"
echo -e "${G}Step 3:${N} Set Proxy → Manual"
echo ""
echo -e "${C}IP ADDRESS : 127.0.0.1${N}"
echo -e "${C}PORT       : 8118${N}"
echo -e "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}\n"

# -------- CONFIG --------
TORRC="$PREFIX/etc/tor/torrc"
PASSWORD="mypass"
HASH=$(tor --hash-password $PASSWORD | tail -n 1)

cat <<EOF > $TORRC
ControlPort 9051
HashedControlPassword $HASH
SocksPort 9050
EOF

progress_bar "Configuring TOR"

# -------- PRIVOXY --------
PRIVOXY_CFG="$PREFIX/etc/privoxy/config"
cat <<EOF > $PRIVOXY_CFG
listen-address 127.0.0.1:8118
forward-socks5t / 127.0.0.1:9050 .
EOF

progress_bar "Starting Proxy Bridge"

# -------- TIMER --------
echo -e "${Y}Select Speed:${N}"
echo "1) ⚡ 5 sec"
echo "2) 🚀 10 sec"
echo "3) 🐢 30 sec"
read -p "Choice: " ch

case $ch in
    1) DELAY=5 ;;
    2) DELAY=10 ;;
    3) DELAY=30 ;;
    *) DELAY=10 ;;
esac

# -------- START SERVICES --------
echo -e "\n${C}[+] Booting TOR Engine...${N}"
tor > /dev/null 2>&1 &
sleep 6

echo -e "${C}[+] Launching Proxy...${N}"
privoxy $PRIVOXY_CFG > /dev/null 2>&1 &
sleep 2

export http_proxy="socks5://127.0.0.1:9050"
export https_proxy="socks5://127.0.0.1:9050"

echo -e "${G}[✓] SYSTEM ONLINE${N}\n"

# -------- LOOP --------
while true
do
    echo -e "${Y}[⚡] Generating New Identity...${N}"

    echo -e "authenticate \"$PASSWORD\"\nsignal newnym\nquit" | nc 127.0.0.1 9051 > /dev/null
    sleep 2

    IP=$(curl --socks5 127.0.0.1:9050 -s https://ipinfo.io/ip)
    COUNTRY=$(curl --socks5 127.0.0.1:9050 -s https://ipinfo.io/country)

    echo -e "${M}[🌐] IP: ${IP}${N}"
    echo -e "${G}[📍] Location: ${COUNTRY}${N}"

    # -------- FAKE ROUTE VISUAL --------
    echo -e "${B}[Routing] Device → Node → Node → Exit (${COUNTRY})${N}"

    # -------- PROGRESS COUNTDOWN --------
    for ((i=$DELAY; i>0; i--)); do
        echo -ne "${C}Next switch in: $i sec ⏳   \r${N}"
        sleep 1
    done

    echo ""
done
