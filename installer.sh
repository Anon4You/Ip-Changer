#!/bin/bash

# Define ANSI color codes
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

# Detect environment
if [ -d "/data/data/com.termux/files/usr" ]; then
    # Termux environment
    echo -e "${CYAN}🔍 Detected Termux environment${NC}"
    PREFIX="/data/data/com.termux/files/usr"
    IPCHANGER="$PREFIX/share/ip-changer"
    LAUNCHER_SCRIPT="$PREFIX/bin/ip-changer"
    MAIN_SCRIPT="ip-changer.sh"
    PACKAGES=("git" "curl" "tor" "privoxy" "netcat-openbsd")
    PKG_MANAGER="apt"
    USE_SUDO=false
else
    # Debian-based Linux environment
    echo -e "${CYAN}🔍 Detected Linux environment${NC}"
    PREFIX="/usr"
    IPCHANGER="$PREFIX/share/ip-changer"
    LAUNCHER_SCRIPT="$PREFIX/bin/ip-changer"
    MAIN_SCRIPT="ip-changer-linux.sh"
    PACKAGES=("git" "curl" "tor" "netcat-openbsd")
    PKG_MANAGER="apt-get"
    USE_SUDO=true
fi

# Function to run commands with or without sudo
run_command() {
    if [ "$USE_SUDO" = true ]; then
        sudo "$@"
    else
        "$@"
    fi
}

# Function to check and install packages
install_packages() {
    echo -e "${CYAN}🛠️ Checking and installing required packages...${NC}"
    
    # Update package lists
    if [ "$USE_SUDO" = true ]; then
        echo -e "${YELLOW}🔄 Updating package lists...${NC}"
        run_command $PKG_MANAGER update -y
    fi
    
    for pkg in "${PACKAGES[@]}"; do
        if ! dpkg -s $pkg &>/dev/null && ! pacman -Qi $pkg &>/dev/null; then
            echo -e "${YELLOW}🚀 Installing $pkg...${NC}"
            run_command $PKG_MANAGER install -y $pkg
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ $pkg installed successfully!${NC}"
            else
                echo -e "${RED}❌ Failed to install $pkg${NC}"
                exit 1
            fi
        else
            echo -e "${GREEN}✅ $pkg is already installed.${NC}"
        fi
    done
}

# Clone or update the repository
setup_repository() {
    echo -e "${CYAN}📦 Setting up Ip-Changer repository...${NC}"
    if [ -d "$IPCHANGER" ]; then
        echo -e "${YELLOW}📂 Directory exists. Updating repository...${NC}"
        cd "$IPCHANGER" || exit
        git pull origin master
    else
        echo -e "${YELLOW}📥 Cloning repository...${NC}"
        run_command mkdir -p "$IPCHANGER"
        git clone https://github.com/Anon4You/Ip-Changer.git "$IPCHANGER"
        if [ "$USE_SUDO" = true ]; then
            run_command chown -R $(whoami) "$IPCHANGER"
        fi
        echo -e "${GREEN}✅ Repository cloned successfully!${NC}"
    fi
}

# Create the launcher script
create_launcher() {
    echo -e "${CYAN}📝 Creating launcher script at $LAUNCHER_SCRIPT...${NC}"
    
    # Create directory if it doesn't exist
    run_command mkdir -p "$(dirname "$LAUNCHER_SCRIPT")"
    
    # Create the script
    run_command bash -c "cat > \"$LAUNCHER_SCRIPT\"" << EOF
#!/bin/bash
cd "$IPCHANGER"
bash $MAIN_SCRIPT "\$@"
EOF

    run_command chmod +x "$LAUNCHER_SCRIPT"
    echo -e "${GREEN}✅ Launcher script created and made executable!${NC}"
}

# Main installation process
install_packages
setup_repository
create_launcher

# Final message
echo -e "${BLUE}🎉 Installation complete! You can now run 'ip-changer' from anywhere.${NC}"
echo -e "${CYAN}🚀 Just type ${GREEN}ip-changer${CYAN} to start using the tool.${NC}"
