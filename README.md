# 🛠 S4K Admin Toolbox

A collection of battle-tested scripts and utilities for system administrators, DevOps engineers, and power users. This repository serves as a "Swiss Army Knife" for automating routine tasks across Windows and Linux environments.

---

### 📂 Navigation Table

| OS | Stack | Utility Name | Description | Status |
| :--- | :--- | :--- | :--- | :--- |
| ![Windows](https://img.shields.io/badge/Windows-0078D6?style=flat-square&logo=windows&logoColor=white) | ![Batch](https://img.shields.io/badge/-Batch-4D4D4D?style=flat-square) | [AnyDesk Reset](./tools/windows/apps-reset/anydesk-id-reseter.bat) | Terminate [AnyDesk](https://anydesk.com/en) & clear config files (`ID reset`) | ✅ Stable |
| ![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black) | ![Bash](https://img.shields.io/badge/-Bash-4EAA25?style=flat-square) | [PSQL NFS Backup](https://github.com/andsyrovatko/s4k-psql-db-backuper) | Automation for [PostgreSQL](https://www.postgresql.org/) dumps with [NFS](https://en.wikipedia.org/wiki/Network_File_System) & [Telegram](https://telegram.org/) | 🔗 External |
| ![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black) | ![Bash](https://img.shields.io/badge/-Bash-4EAA25?style=flat-square) | [Whois Infrastructure Automator (for ISPs)](https://github.com/andsyrovatko/s4k-billing-whois-automator) | Automation for Whois DB update by billing system | 🔗 External |
| ![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black) | ![Bash](https://img.shields.io/badge/-Bash-4EAA25?style=flat-square) | [IP Manager for ISPs (Billing ↔ IPSET)](https://github.com/andsyrovatko/s4k-ip-manager) |  Automation IP management by billing or external system for ISPs | 🔗 External |
| ![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black) | ![Py](https://img.shields.io/badge/-Python-3776AB?style=flat-square) | [Modbus Relay Control](https://github.com/andsyrovatko/s4k-modbus-relay-controler) | Low-level Python control for [ETH/PoE Modbus relays](https://www.waveshare.com/wiki/Modbus_POE_ETH_Relay?srsltid=AfmBOoqDfhxMpq6XIjLOi5PfurPm9UrAKqPETNzlvKPQ37xGBWnWiX41) | ⏳ Pending |

---

### ⚠️ Disclaimer
> **Use at your own risk!** These scripts are designed for administrative tasks and may perform destructive actions (like killing processes or deleting config files). The author is not responsible for any data loss or system instability. Always test in a sandbox environment first.

---

### ⚖️ License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
