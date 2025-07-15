# 🛠 WordPress XML-RPC Brute Force Tool

This Bash script performs a brute-force attack on WordPress XML-RPC (`xmlrpc.php`) using the `wp.getUsersBlogs` method.  
It is designed for **penetration testing** and **security auditing** purposes only.

---

## ⚠️ Legal Disclaimer
This tool is intended for **authorized security testing only**.  
Do **NOT** use it on systems you do not own or have explicit permission to test.  
Unauthorized usage may violate laws and result in legal consequences.

---

## ✅ Features
- Interactive input (Target URL, Username, Wordlist).
- Colorful output (Status, Success, Errors).
- Optional logging to a file.
- Delay control between attempts.
- Clean exit on `Ctrl+C`.
- XML escaping for safety.

---

## 📦 Requirements
- **Bash** (Linux / macOS recommended)
- **curl** installed on the system

Install curl if missing:
```bash
sudo apt-get install curl   # Debian/Ubuntu
sudo yum install curl       # CentOS/RHEL

```
⚠️ Important Notes
Many sites disable xmlrpc.php or restrict it via .htaccess or WAF.

If you see 403 Forbidden, XML-RPC is likely disabled.

For such cases, try wp-login.php brute force or use wpscan:

```bash
wpscan --url https://target.com --usernames admin --passwords /usr/share/wordlists/rockyou.txt

wpscan --url https://www.target.com --usernames admin --passwords /usr/share/wordlists/rockyou.txt --max-threads 10

wpscan --url https://www.target.com --random-user-agent --usernames admin --passwords /usr/share/wordlists/rockyou.txt

