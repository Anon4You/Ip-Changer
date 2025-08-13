#!/bin/bash

IPCHANGER="/usr/local/share/ip-changer"

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[37m"
RESET="\e[0m"

DEFAULT_ROTATION_TIME=10
MIN_ROTATION_TIME=5
ROTATION_TIME=$DEFAULT_ROTATION_TIME

usage() {
    echo -e "${BLUE}Usage: ip-changer [-r SECONDS]${RESET}"
    exit 1
}

while getopts ":r:h" opt; do
    case $opt in
        r)
            if [[ "$OPTARG" =~ ^[0-9]+$ ]] && [[ "$OPTARG" -ge $MIN_ROTATION_TIME ]]; then
                ROTATION_TIME="$OPTARG"
            else
                echo -e "${RED}Invalid rotation interval. Using default $DEFAULT_ROTATION_TIME seconds.${RESET}"
            fi
            ;;
        h) usage ;;
    esac
done

echo -e "${YELLOW}Stopping existing Tor and Privoxy...${RESET}"
sudo systemctl stop tor > /dev/null 2>&1
sudo pkill tor
sudo pkill privoxy

rm -rf "$IPCHANGER/.tor_multi" "$IPCHANGER/.privoxy"
mkdir -p "$IPCHANGER/.tor_multi" "$IPCHANGER/.privoxy"

PORTS=(9050 9060 9070 9080 9090)
CONTROL_PORTS=(9051 9061 9071 9081 9091)

echo -e "${CYAN}Starting Tor instances...${RESET}"
for i in {0..4}; do
    TOR_DIR="$IPCHANGER/.tor_multi/tor$i"
    mkdir -p "$TOR_DIR"
    cat <<EOF > "$TOR_DIR/torrc"
SocksPort ${PORTS[$i]}
ControlPort ${CONTROL_PORTS[$i]}
DataDirectory $TOR_DIR
CookieAuthentication 0
EOF
    sudo tor -f "$TOR_DIR/torrc" > "$TOR_DIR/tor.log" 2>&1 &
done

# Wait for all Tor ports to be ready
for port in "${PORTS[@]}"; do
    echo -e "${BLUE}Waiting for Tor on port $port...${RESET}"
    until nc -z 127.0.0.1 "$port"; do
        sleep 1
    done
done
echo -e "${GREEN}All Tor instances are ready!${RESET}"

# Configure Privoxy
cat <<EOF > "$IPCHANGER/.privoxy/config"
listen-address 127.0.0.1:8118
EOF
for port in "${PORTS[@]}"; do
    echo "forward-socks5 / 127.0.0.1:$port ." >> "$IPCHANGER/.privoxy/config"
done

echo -e "${CYAN}Starting Privoxy...${RESET}"
sudo privoxy "$IPCHANGER/.privoxy/config" > "$IPCHANGER/.privoxy/privoxy.log" 2>&1 &

sleep 3

# Test connection
TEST_IP=$(curl --proxy http://127.0.0.1:8118 -s https://api64.ipify.org)
if [[ -z "$TEST_IP" ]]; then
    echo -e "${RED}[!] Initial connection through Privoxy failed. Check privoxy.log${RESET}"
    exit 1
else
    echo -e "${GREEN}Initial IP: $TEST_IP${RESET}"
fi

# Main loop
while true; do
    echo -e "${YELLOW}Renewing Tor circuit...${RESET}"
    for ctrl_port in "${CONTROL_PORTS[@]}"; do
        echo -e "AUTHENTICATE \"\"\r\nSIGNAL NEWNYM\r\nQUIT" | nc 127.0.0.1 $ctrl_port > /dev/null 2>&1
    done

    sleep 3 # Give Tor time to get a new IP

    NEW_IP=$(curl --proxy http://127.0.0.1:8118 -s https://api64.ipify.org)
    if [[ -z "$NEW_IP" ]]; then
        echo -e "${RED}[!] Failed to get new IP. Retrying...${RESET}"
        sleep 5
        continue
    fi

    echo -e "${GREEN}New IP: $NEW_IP${RESET}"
    echo -e "${BLUE}Next IP change in $ROTATION_TIME seconds...${RESET}"

    sleep "$ROTATION_TIME"
done
