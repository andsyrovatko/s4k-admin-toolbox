# 🛠 Juniper Network Toggle Too

This script automates the activate / deactivate operations on Juniper JunOS devices via SSH. It intelligently distinguishes between interface addresses and static routes.

---

### 🚀 Key Features
* **Dual Mode:** Detects if the target is an interface (`address`) or a static route (`route`).
* **Dynamic CIDR:** Supports masks from `/24` up to `/32`.
* **Safety First:** Runs in Bash Strict Mode (`set -uo pipefail`).
* **Dry Run Ready:** Includes a debug echo of the command before execution.

### ⚙️ Prerequisites
* **Packages:** `ipcalc`, `openssh-client`.
* **Access:** Passwordless SSH access to the Juniper host.
* **Config:** A `juniper-net-manager.conf` file defining `JUNIPER_USER`.

### 🏃 Quick Start
```bash
    # Deactivate a network (Interface)
    ./juniper-net-toggle.sh 10.10.1.1 192.168.50.0/30 OFF

    # Activate a static route
    ./juniper-net-toggle.sh core-router-01 185.65.200.0/24 ON
```

### 🔧 Parameters
| Argument | Description |
| :--- | :--- |
| `HOSTNAME` | Target Juniper IP or FQDN. |
| `NETWORK` |	Network with CIDR (e.g., 1.1.1.0/24). |
| `ACTION` |	ON (activate) or OFF (deactivate). |

### ⚠️ Troubleshooting
* **Error: Not found:** Ensure the IP and Mask match the Juniper configuration exactly as seen in show configuration.
* **Unbound variable:** Ensure all 3 arguments are provided.

---

### ⚖️ License
MIT [LICENSE](https://github.com/andsyrovatko/s4k-admin-toolbox/blob/main/LICENSE). Free to use and modify.
