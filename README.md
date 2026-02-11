🧅 TOR IP Rotator + Privoxy (Termux / Linux)

Automatic TOR identity changer with HTTP proxy support for browsers.

Made by: NS Jagat

📌 What is this?

TOR IP Rotator is a bash script that:

✔ Installs & configures TOR
✔ Connects applications through TOR SOCKS proxy
✔ Bridges SOCKS → HTTP using Privoxy
✔ Changes TOR exit IP automatically after a selected time
✔ Restarts TOR if it crashes
✔ Logs new IP addresses
✔ Works inside Termux (Android) and Linux environments

This project is created for privacy research, cybersecurity learning, and educational demonstrations.

🚀 Features

Automatic TOR setup

One-click start

Multiple rotation timers (5 / 10 / 30 / 60 sec)

Crash auto-recovery

Android WiFi proxy support

IP logging

Lightweight & beginner friendly

🧠 How it Works (Simple)

Your traffic → Privoxy (HTTP) → TOR SOCKS → Random Exit Node → Internet

Every few seconds script asks TOR for new identity, so your public IP changes.

💻 Supported Devices

✅ Android (Termux)
✅ Linux
✅ Kali Linux
✅ Ubuntu / Debian
✅ WSL

(Mac may work with small changes)

⚙️ Installation & Usage
📱 Android (Termux)
pkg update && pkg upgrade -y
pkg install git -y
git clone https://github.com/YOUR-USERNAME/YOUR-REPO.git
cd YOUR-REPO
bash IpChang-NS.sh

After Start (Important for browser)

Set WiFi Proxy manually:

Host: 127.0.0.1  
Port: 8118

🐧 Linux / Kali / Ubuntu
sudo apt update
sudo apt install tor privoxy curl netcat -y
git clone https://github.com/YOUR-USERNAME/YOUR-REPO.git
cd YOUR-REPO
bash IpChang-NS.sh

⏱ Choose Rotation Time

When script runs, select:

1 → 5 sec  
2 → 10 sec  
3 → 30 sec  
4 → 60 sec

📄 Log File

Saved at:

~/ip_logs.txt

🛑 Stop Script

Press:

CTRL + C

⚠️ Disclaimer

This tool is for:

✔ privacy testing
✔ research
✔ learning networking
✔ cybersecurity awareness

❌ Do NOT use for illegal activity.
User is responsible for their actions.

🌟 Support the Project

If this helped you:

⭐ Star the repo
🍴 Fork it
📢 Share with friends
📺 Subscribe: NS Jagat

🧑‍💻 Author

NS Jagat
Cybersecurity & Ethical Hacking Tutorials
YouTube: NS Jagat

🔍 Keywords (SEO)

tor ip changer, tor identity changer, tor termux, change ip termux, tor proxy android, privoxy tor, tor automation, kali tor script, ethical hacking privacy tool
