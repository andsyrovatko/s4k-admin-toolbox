# 🛠 Directory Comparator

A robust Bash utility for recursive file comparison between two directories. It uses DIR_A as the source of truth for file names and checks for their existence and differences in DIR_B. Perfect for auditing configuration changes or verifying backup integrity.

---

### ⚙️ Prerequisites
* **diff:** Used for generating file differences.
* **find:** Required for recursive file discovery.
* **Bash 4+:** Utilizes modern bash features like `set -euo pipefail`.

### 📊 Parameters Mapping
| Option | Description |
| :--- | :--- |
| -o <file>	| Save the full report to a specific file (default: `./compare-dirs.log`). |
| -q	| Quiet mode: Show only the final summary without full `diff` output. |
| -h	| Show help and usage information. |

### 🏃 Quick Start
```bash
    # Basic comparison (outputs diffs to terminal and compare-dirs.log)
    ./compare-dirs.sh /path/to/dir_a /path/to/dir_b

    # Quiet mode (summary only) with custom log file
    ./compare-dirs.sh -q -o audit_report.log /etc/nginx /backup/nginx
```

### 🛡 Features
* **Safe Discovery:** Uses `-printf '%P\0'` with `find` to safely handle filenames with spaces or special characters.
* **Strict Execution:** Built-in error trapping and strict mode to prevent silent failures.
* **Colorized UI:** Visual feedback for **IDENTICAL**, **DIFFERENT**, and **MISSING** status.
* **Log Rotation Ready:** Outputs to both `STDOUT` and log files simultaneously.

---

### ⚖️ License
MIT [LICENSE](https://github.com/andsyrovatko/s4k-admin-toolbox/blob/main/LICENSE). Free to use and modify.
