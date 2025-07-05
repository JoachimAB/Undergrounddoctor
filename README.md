# Underground Doctor – FiveM Script

This script adds an underground doctor NPC that can revive dead players for a cash fee, with a 30-minute cooldown and a progress bar. Made for QBCore, supporting `ox_target` and (optionally) `ox_lib`.

---

## 🚀 Installation

1. **Download and extract** the `undergrounddoctor` folder into your `resources` directory.

2. **Install dependencies:**
   - [ox_target](https://github.com/overextended/ox_target)
   - *(Optional but recommended)* [ox_lib](https://github.com/overextended/ox_lib) – for nicer progress bars and notifications.

3. **Add to your `server.cfg`:**
   ```cfg
   ensure ox_target
   ensure ox_lib        # (optional, but recommended for best experience)
   ensure undergrounddoctor
