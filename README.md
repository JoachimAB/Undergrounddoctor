# Underground Doctor – FiveM Script

Dette scriptet gir deg en undergrunns-doktor NPC som kan "revive" døde spillere mot betaling i kontanter, med 30 minutters cooldown og progressbar. Laget for QBCore, med støtte for både `ox_target` og (valgfritt) `ox_lib`.

---

## 🚀 Installasjon

1. **Last ned og pakk ut** mappen `undergrounddoctor` til din `resources`-mappe.

2. **Installer dependencies:**
   - [ox_target](https://github.com/overextended/ox_target)
   - *(Valgfritt men anbefalt)* [ox_lib](https://github.com/overextended/ox_lib) – for finere progressbar og notifikasjoner.

3. **Legg til i server.cfg:**
   ```cfg
   ensure ox_target
   ensure ox_lib        # (valgfritt, men anbefales for best opplevelse)
   ensure undergrounddoctor
