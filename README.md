# ReMi
ReMi: remake your phone. A skill that removes ads and bloatware and customizes your Android using only official adb, no root, no third-party tools. Per-brand profiles (starting with Xiaomi/HyperOS), reversible changes, and confirmation before every command.

---

## Español

**ReMi ("rehaz tu móvil")** es una skill para Claude que limpia y personaliza tu Android con
el `adb` oficial de Google. Sin root, sin programas de terceros, y todo se puede deshacer.

### Qué hace
1. Detecta tu móvil (marca, modelo, versión de Android y de la capa: HyperOS, One UI…).
2. Guarda una copia de la lista de apps y de tus ajustes antes de tocar nada.
3. Carga el perfil de tu marca y te propone quitar **solo** la publicidad y el bloatware
   que ese perfil conoce y que de verdad están en tu móvil.
4. Te pregunta solo lo que es cuestión de gusto: launcher, tamaño de pantalla y texto,
   animaciones, iconos de la barra de estado, gestos o botones.
5. Te enseña los comandos de cada bloque y espera tu "sí".
6. Te deja `remi-apply.sh` (para repetirlo tras una actualización) y `remi-restore.sh`
   (para deshacerlo todo).

### Marcas soportadas
| Marca / capa | Perfil | Estado |
|---|---|---|
| Xiaomi / Redmi / POCO — HyperOS (Redmi Note 13 Pro 4G y 5G) | `remi/profiles/xiaomi-hyperos.md` | comunidad (pendiente de prueba en móvil real) |
| Samsung, Oppo/Realme/OnePlus, Vivo, Motorola, Pixel, Android TV | — | ¡Aporta el tuyo! |

### Instalación (2 minutos)
**Necesitas:** Claude Code en tu ordenador y el móvil con cable USB.

1. Instala Claude Code: https://claude.com/claude-code
2. Copia la carpeta `remi/` a tu carpeta de skills:
   - Windows: `%USERPROFILE%\.claude\skills\remi\`
   - macOS / Linux: `~/.claude/skills/remi/`

   (En la app de Claude también puedes abrir `remi.skill` y pulsar **Guardar skill**.)
3. Conecta el móvil y escribe a Claude: *"Quiero quitarle la publicidad a mi móvil"*.
   Si no tienes `adb`, ReMi te guía para instalar las Platform-Tools oficiales y activar
   la depuración USB.

### Deshacer
```
adb push remi-restore.sh /data/local/tmp/
adb shell sh /data/local/tmp/remi-restore.sh
```
Los scripts están en la carpeta `remi/<móvil>-<fecha>/` que ReMi crea donde lo ejecutaste.

### Aportar una marca
Copia `remi/profiles/_TEMPLATE.md`, sigue `remi/references/profile-guide.md` y abre un
Pull Request. Todo perfil nuevo empieza como "sin probar" y pasa una revisión antes de
publicarse.

### Aviso
Quitar apps del sistema siempre conlleva algún riesgo. ReMi usa `pm uninstall -k --user 0`
(reversible), bloquea los paquetes críticos y te avisa de lo que no está probado. Úsalo bajo
tu responsabilidad.

---

## English

**ReMi** is a Claude skill that debloats and personalizes Android phones using only Google's
official `adb`. It detects the phone, backs up packages and settings, loads the brand
profile, proposes removing only profile-listed ads/bloat that are actually installed,
asks you only about look-and-feel choices, confirms each block of commands, and leaves
re-apply and restore scripts.

**Install:** copy `remi/` to `~/.claude/skills/remi/` (Windows:
`%USERPROFILE%\.claude\skills\remi\`), or open `remi.skill` in the Claude app and click
**Save skill**. Then connect your phone and ask Claude to clean it.

**Contribute a brand:** copy `remi/profiles/_TEMPLATE.md`, follow
`remi/references/profile-guide.md`, open a PR. New profiles start as `untested`.
