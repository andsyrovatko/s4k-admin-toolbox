# 🛠 S4K Admin Toolbox

A collection of battle-tested scripts and utilities for system administrators, DevOps engineers, and power users. This repository serves as a "Swiss Army Knife" for automating routine tasks across Windows and Linux environments.

---

## 📂 Navigation Table
This toolbox contains a `mix` of `built-in scripts` and `links to my standalone specialized projects` for easier navigation.
| OS | Stack | Utility Name | Description | Status |
| :--- | :--- | :--- | :--- | :--- |
| ![Windows](https://img.shields.io/badge/Windows-0078D6?style=flat-square&logo=windows&logoColor=white) | ![Batch](https://img.shields.io/badge/-Batch-4D4D4D?style=flat-square) | [AnyDesk Reset](./tools/windows/apps-reset) | Terminate [AnyDesk](https://anydesk.com/en) & clear config files (`ID reset`) | ✅ Stable <br> 🧰&nbsp;Built-in&nbsp; |
| ![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black) | ![Bash](https://img.shields.io/badge/-Bash-4EAA25?style=flat-square) | [Docker Network Manager](./tools/linux/docker-ce/network-manager) | Auto-IPAM & static bridge naming for `Docker` bridge networks | ✅ Stable <br> 🧰&nbsp;Built-in&nbsp; |
| ![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black) | ![Bash](https://img.shields.io/badge/-Bash-4EAA25?style=flat-square) | [Juniper Network Toggle](./tools/linux/juniper-ctrl/juniper-net-toggle) | Remote toggle for [Juniper](https://www.juniper.net/) interfaces & static routes | ✅ Stable <br> 🧰&nbsp;Built-in&nbsp; |
| ![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black) | ![Bash](https://img.shields.io/badge/-Bash-4EAA25?style=flat-square) | [Directory Comparator](./tools/linux/compare-dirs) | Recursive file comparison between two directories with detailed diff logging | ✅ Stable <br> 🧰&nbsp;Built-in&nbsp; |
| ![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black) | ![Bash](https://img.shields.io/badge/-Bash-4EAA25?style=flat-square) | [PSQL NFS Backup](https://github.com/andsyrovatko/s4k-psql-db-backuper) | Automation for [PostgreSQL](https://www.postgresql.org/) dumps with [NFS](https://en.wikipedia.org/wiki/Network_File_System) & [Telegram](https://telegram.org/) | ✅ Stable <br> 📦&nbsp;Standalone&nbsp; |
| ![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black) | ![Bash](https://img.shields.io/badge/-Bash-4EAA25?style=flat-square) | [PVE Rsync Backup Pro](https://github.com/andsyrovatko/s4k-pve-rsync-backup) | Surgical [Proxmox VE](https://www.proxmox.com/) VM backups with log-parsed paths & auto-cleanup | ✅ Stable <br> 📦&nbsp;Standalone&nbsp; |
| ![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black) | ![Bash](https://img.shields.io/badge/-Bash-4EAA25?style=flat-square) | [Whois Infrastructure Automator (for ISPs)](https://github.com/andsyrovatko/s4k-billing-whois-automator) | Automation for Whois DB update by billing system | ✅ Stable <br> 📦&nbsp;Standalone&nbsp; |
| ![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black) | ![Bash](https://img.shields.io/badge/-Bash-4EAA25?style=flat-square) | [IP Manager for ISPs (Billing ↔ IPSET)](https://github.com/andsyrovatko/s4k-ip-manager) |  Automation IP management by billing or external system for ISPs | ✅ Stable <br> 📦&nbsp;Standalone&nbsp; |
| ![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black) ![Windows](https://img.shields.io/badge/Windows-0078D6?style=flat-square&logo=windows&logoColor=white) | ![Py](https://img.shields.io/badge/-Python-3776AB?style=flat-square) | [Modbus Relay Control](https://github.com/andsyrovatko/s4k-modbus-relay-controller) | Cross-platform low-level Python control for [ETH/PoE Modbus relays](https://www.waveshare.com/wiki/Modbus_POE_ETH_Relay) | ✅ Stable <br> 📦&nbsp;Standalone&nbsp; |
| ![Linux](https://img.shields.io/badge/-Linux-FCC624?style=flat-square&logo=linux&logoColor=black) | ![PHP](https://img.shields.io/badge/-PHP-777BB4?style=flat-square&logo=php&logoColor=white) | ISP Console Shaper | CLI management for ISP client shapes, networks, and routers ([PostgreSQL](https://www.postgresql.org/)) | ✅ Stable <br> 🔐&nbsp;Private&nbsp; |
| ![Windows](https://img.shields.io/badge/Windows-0078D6?style=flat-square&logo=windows&logoColor=white) | ![UE](https://img.shields.io/badge/-Unreal_Engine-0E1128?style=flat-square&logo=unrealengine&logoColor=white) | "School Runner" (The Game) | Meditative runner game built with Unreal Engine 4 (C++ / Blueprints) | 🏗&nbsp;WIP <br> 🔐&nbsp;Private&nbsp; |

---

## ⭐ Featured Tools

### 🐳 Docker Network Manager
A surgical tool for managing Docker infrastructure. It eliminates the "random bridge names" problem by forcing static names at the OS level, making it perfect for custom firewall rules and network monitoring.
- **Auto-IPAM**: Scans and assigns free subnets.
- **Native Naming**: Direct mapping between Docker names and Linux interfaces.

---

### ⚠️ Disclaimer
> **Use at your own risk!** These scripts are designed for administrative tasks and may perform destructive actions (like killing processes or deleting config files). The author is not responsible for any data loss or system instability. Always test in a sandbox environment first.

---

### ⚖️ License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
