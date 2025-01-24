#!/bin/bash

# Display logo (optional)
echo "========================================"
echo "               SKaaalper                "
echo "========================================"
sleep 2

# URL to download the miner file
INIMINER_URL="https://github.com/Project-InitVerse/ini-miner/releases/download/v1.0.0/iniminer-linux-x64"

# Miner file name
INIMINER_FILE="iniminer-linux-x64"

# Screen session name
SCREEN_NAME="mainnet_inichain"

# ==============================================
# Function: Update System and Install Screen
# ==============================================
update_system_and_install_screen() {
    echo
    echo "========================================"
    echo "🔄 Updating the system and installing screen..."
    echo "========================================"
    sudo apt update && sudo apt upgrade -y
    sudo apt install screen -y
    if [ $? -eq 0 ]; then
        echo "✅ System updated and screen installed successfully."
    else
        echo "❌ Failed to update the system or install screen."
        exit 1
    fi
    echo
}

# ==============================================
# Function: Download Miner File
# ==============================================
download_inichain() {
    echo
    echo "========================================"
    echo "⬇️  Downloading InitVerse Miner file..."
    echo "========================================"
    wget -q $INIMINER_URL -O $INIMINER_FILE
    if [ $? -eq 0 ]; then
        echo "✅ File downloaded successfully."
    else
        echo "❌ Failed to download the file. Check the URL or your internet connection."
        exit 1
    fi
    echo
}

# ==============================================
# Function: Grant Execution Permission
# ==============================================
give_permission() {
    echo
    echo "========================================"
    echo "🔑 Granting execution permission to the file..."
    echo "========================================"
    chmod +x $INIMINER_FILE
    if [ $? -eq 0 ]; then
        echo "✅ Execution permission granted successfully."
    else
        echo "❌ Failed to grant execution permission."
        exit 1
    fi
    echo
}

# ==============================================
# Function: Run Miner in Screen
# ==============================================
run_inichain_miner() {
    echo
    echo "========================================"
    echo "🚀 Running InitVerse Miner in a screen session..."
    echo "========================================"
    read -p "Enter your wallet address: " WALLET_ADDRESS
    read -p "Enter the Worker name (e.g., Worker001): " WORKER_NAME

    # Validate inputs
    if [[ -z "$WALLET_ADDRESS" || -z "$WORKER_NAME" ]]; then
        echo "❌ Wallet address or Worker name cannot be empty."
        exit 1
    fi

    echo
    echo "Select the mainnet pool URL:"
    echo "1. pool-a.yatespool.com:31588"
    echo "2. pool-b.yatespool.com:32488"
    read -p "Enter your choice (1 or 2): " POOL_CHOICE

    # Select the pool URL based on the choice
    case $POOL_CHOICE in
        1)
            POOL_URL="stratum+tcp://${WALLET_ADDRESS}.${WORKER_NAME}@pool-a.yatespool.com:31588"
            ;;
        2)
            POOL_URL="stratum+tcp://${WALLET_ADDRESS}.${WORKER_NAME}@pool-b.yatespool.com:32488"
            ;;
        *)
            echo "❌ Invalid choice. Please enter 1 or 2."
            exit 1
            ;;
    esac

    screen -dmS $SCREEN_NAME ./$INIMINER_FILE --pool $POOL_URL
    if [ $? -eq 0 ]; then
        echo "✅ InitVerse Miner is running in a screen session named '$SCREEN_NAME'."
        echo "ℹ️  Use the following command to monitor it:"
        echo "   screen -r $SCREEN_NAME"
    else
        echo "❌ Failed to run InitVerse Miner."
        exit 1
    fi
    echo
}

# ==============================================
# Execute Functions
# ==============================================
update_system_and_install_screen
download_inichain
give_permission
run_inichain_miner

echo
echo "========================================"
echo "🎉 Done! InitVerse Miner is set up and running."
echo "========================================"
