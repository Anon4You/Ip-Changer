#!/bin/bash

# Define ANSI color codes
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

# Define the installation directory
IPCHANGER="/usr/local/share/ip-changer"

# Function to check and install packages
install_packages() {
    packages=("git" "curl" "tor" "privoxy" "netcat")
    for pkg in "${packages[@]}"; do
        if ! dpkg -s "$pkg" &> /dev/null; then
            echo -e "${YELLOW}🚀 Installing $pkg...${NC}"
            sudo apt update && sudo apt install -y "$pkg"
        else
            echo -e "${GREEN}✅ $pkg is already installed.${NC}"
        fi
    done
}

# Install required packages
echo -e "${CYAN}🛠️ Checking and installing required packages...${NC}"
install_packages

# Clone or update the repository
echo -e "${CYAN}📦 Cloning Ip-Changer repository...${NC}"
if [ -d "$IPCHANGER" ]; then
    echo -e "${YELLOW}📂 Directory $IPCHANGER already exists. Updating repository...${NC}"
    cd "$IPCHANGER" || exit
    git pull origin master
else
    sudo git clone https://github.com/Anon4You/Ip-Changer.git "$IPCHANGER"
    echo -e "${GREEN}✅ Repository cloned successfully!${NC}"
fi

# Create the launcher script
LAUNCHER_SCRIPT="/usr/local/bin/ip-changer"
echo -e "${CYAN}📝 Creating launcher script at $LAUNCHER_SCRIPT...${NC}"
sudo bash -c "cat > $LAUNCHER_SCRIPT" << EOF
#!/bin/bash
cd "$IPCHANGER"
bash Kali-Linux-Release/kali-ip-changer.sh "\$@"
EOF

# Make the launcher script executable
sudo chmod +x "$LAUNCHER_SCRIPT"
echo -e "${GREEN}✅ Launcher script created and made executable!${NC}"

# Final message
echo -e "${BLUE}🎉 Installation complete! You can now run 'ip-changer' from anywhere in Kali Linux.${NC}"
echo -e "${CYAN}🚀 Just type ${GREEN}ip-changer${CYAN} to start using the tool.${NC}"
