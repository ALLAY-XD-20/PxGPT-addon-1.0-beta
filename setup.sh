#!/bin/bash

# --- Custom Colors ---
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# --- Custom Loading Screen ---
loading_animation() {
    echo -ne "${CYAN}Starting PxGPT System "
    for i in {1..3}; do
        echo -ne "."
        sleep 0.4
    done
    echo -e "${RESET}"
}

# --- Custom ASCII Art ---
show_logo() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
  _____            _____ _____ _______ 
 |  __ \          / ____|  __ \__   __|
 | |__) |  __  __| |  __| |__) | | |   
 |  ___/ \ \/ / | | |_ |  ___/  | |   
 | |      >  <  | |__| | |      | |   
 |_|     /_/\_\  \_____|_|      |_|   
                                       
EOF
    echo -e "${YELLOW}BUILDER :- PAWAN${RESET}"
    echo -e "------------------------------------"
}

# --- Functions ---
install_maven() {
    echo -e "${YELLOW}[!] Installing Maven...${RESET}"
    sudo apt update && sudo apt install maven -y
    echo -e "${GREEN}[+] Maven Installed Successfully!${RESET}"
    sleep 2
}

install_gradle() {
    echo -e "${YELLOW}[!] Installing SDKMAN & Gradle...${RESET}"
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk install gradle 8.10
    echo -e "${GREEN}[+] Gradle 8.10 Installed Successfully!${RESET}"
    sleep 2
}

install_java25() {
    echo -e "${YELLOW}[!] Installing OpenJDK 25...${RESET}"
    sudo apt update
    sudo apt install openjdk-25-jdk -y
    echo -e "${GREEN}[+] Java 25 Installed Successfully!${RESET}"
    sleep 2
}

set_java_auto() {
    echo -e "${YELLOW}[!] Configuring System Defaults...${RESET}"
    sudo update-alternatives --set java /usr/lib/jvm/java-25-openjdk-amd64/bin/java
    sudo update-alternatives --set javac /usr/lib/jvm/java-25-openjdk-amd64/bin/javac
    echo 'export JAVA_HOME=/usr/lib/jvm/java-25-openjdk-amd64' >> ~/.bashrc
    source ~/.bashrc
    echo -e "${GREEN}[+] Java 25 is now the default!${RESET}"
    sleep 2
}

create_plugin() {
    show_logo
    echo -e "${CYAN}PROJECT CREATOR${RESET}"
    echo "1) Maven Project"
    echo "2) Gradle Project"
    read -p "Select choice: " p_choice
    
    read -p "Enter Group ID (e.g. me.pawan.pxtotems): " g_id
    read -p "Enter Artifact ID (e.g. PxTotems): " a_id

    if [ "$p_choice" == "1" ]; then
        mvn archetype:generate -DgroupId=$g_id -DartifactId=$a_id -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false
    else
        mkdir -p $a_id && cd $a_id
        gradle init --type java-library --dsl groovy --package $g_id
    fi
    echo -e "${GREEN}[+] Project Created in folder: $a_id${RESET}"
    sleep 3
}

# --- Main Logic ---
loading_animation
while true; do
    show_logo
    echo "1) Install Maven"
    echo "2) Install Gradle"
    echo "3) Install Java 25"
    echo "4) Set Java 25 as Auto-Default"
    echo "5) Setup New Minecraft Plugin"
    echo "6) Exit"
    echo -e "------------------------------------"
    read -p "PxGPT >> " choice

    case $choice in
        1) install_maven ;;
        2) install_gradle ;;
        3) install_java25 ;;
        4) set_java_auto ;;
        5) create_plugin ;;
        6) echo "Goodbye!"; exit ;;
        *) echo -e "${YELLOW}Invalid option!${RESET}"; sleep 1 ;;
    esac
done
