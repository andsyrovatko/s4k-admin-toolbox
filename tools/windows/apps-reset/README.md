# 🛠 Anydesk ID reset utility

A lightweight Batch utility to hard-reset AnyDesk configuration and identity. Useful for resolving ID-related issues or clearing workstation footprints on Windows 10/11 \
(including LTSC).

---

### 🚀 Key Features
* **Hard Reset:** Cleans both User (`%AppData%`) and System (`%ProgramData%`) configurations.
* **Registry Cleanup:** Automatically detects and removes AnyDesk keys from HKLM (`32-bit` & `64-bit` paths).
* **Process Management:** Safely terminates AnyDesk processes before cleanup.
* **Privilege Check:** Built-in verification for Administrator rights.
* **Zero Dependencies:** Pure Windows Batch. No external tools required.
* **Portable:** Can be run directly from a USB flash drive. No installation required.

### 🛠 Usage
1. Right-click `anydesk-id-reseter.bat`.
2. Select Run as Administrator.
3. Follow the on-screen status.
4. Launch AnyDesk to generate a new ID.

### 🔍 Technical Details
The script targets the following components:
* **Files:** `service.conf`, `system.conf` (User & System-wide).
* **Registry:**\
`HKLM\SOFTWARE\WOW6432Node\AnyDesk`\
`HKLM\SOFTWARE\AnyDesk`

---

### ⚖️ License
MIT [LICENSE](https://github.com/andsyrovatko/s4k-admin-toolbox/blob/main/LICENSE). Free to use and modify.
