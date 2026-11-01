# ReMi
**Español** · [English](#english)

**ReMi ("rehaz tu móvil")** es una skill para Claude que quita la publicidad y las apps
basura de tu Android y lo personaliza a tu gusto. Usa solo el `adb` oficial de Google:
sin root, sin programas de terceros, y todo se puede deshacer con un comando.

Tú hablas con Claude en lenguaje normal. ReMi hace la parte técnica y solo te pregunta dos
tipos de cosas: **cómo quieres que quede** (launcher, tamaño, animaciones, gestos…) y
**"¿aplico este bloque?"** antes de tocar nada.

### Marcas soportadas

| Marca / capa | Perfil | Estado |
|---|---|---|
| Xiaomi / Redmi / POCO — HyperOS (Redmi Note 13 Pro 4G y 5G) | `remi/profiles/xiaomi-hyperos.md` | comunidad: aún no probado en un móvil real |
| Samsung, Oppo/Realme/OnePlus, Vivo, Motorola, Pixel, Android TV | — | ¡Aporta el tuyo! |

Si tu marca no está, ReMi no quita nada: solo te ofrece la parte de personalización
(ajustes estándar de Android).

---

## Guía de uso paso a paso

### 1. Lo que necesitas
- Un ordenador (Windows, Mac o Linux) con **Claude Code** instalado: https://claude.com/claude-code
- El móvil y un **cable USB de datos** (algunos cables solo cargan).
- 15–20 minutos la primera vez.

No hace falta instalar `adb` antes: si no lo tienes, ReMi te guía para instalar las
**Platform-Tools oficiales de Google**.

### 2. Instala la skill
Copia la carpeta `remi/` de este repositorio en tu carpeta de skills:

- Windows: `%USERPROFILE%\.claude\skills\remi\`
- macOS / Linux: `~/.claude/skills/remi/`

En la app de Claude también puedes abrir `remi.skill` y pulsar **Guardar skill**.

### 3. Prepara el móvil (Xiaomi)
1. **Ajustes → Sobre el teléfono →** toca **Versión de OS** 7 veces hasta que diga que
   eres desarrollador.
2. **Ajustes → Ajustes adicionales → Opciones de desarrollador →** activa:
   - **Depuración USB** (obligatorio).
   - **Depuración USB (ajustes de seguridad)**: necesario para algunos ajustes de publicidad
     y privacidad. Requiere tener la cuenta Xiaomi iniciada (a veces también una SIM).
   - **Instalar vía USB**: solo si vas a instalar un launcher desde un APK.
3. Conecta el cable, desbloquea el móvil y acepta **"¿Permitir depuración USB?"**
   marcando **"Permitir siempre desde este ordenador"**.
4. Recomendado: haz una copia de seguridad normal antes (Google o Xiaomi Cloud). No debería
   hacer falta, pero da tranquilidad.

### 4. Pídeselo a Claude
Abre Claude Code en **una carpeta que no sea este repositorio** (por ejemplo
`Documentos\ReMi-sesiones`), porque ahí se guardará tu copia de seguridad. Luego escribe,
por ejemplo:

> Tengo mi Redmi Note 13 Pro conectado por USB. Quiero quitarle toda la publicidad y las
> apps que no sirven y dejarlo más fluido. Me gustan las animaciones rápidas, que quepa algo
> más en pantalla y navegación por gestos sin la rayita de abajo. El launcher de Xiaomi me
> vale. No quites Spotify ni Netflix, que los uso.

Otras formas de pedirlo:

| Quieres… | Escribe algo como… |
|---|---|
| Solo quitar publicidad, sin tocar el aspecto | *"Quítale los anuncios a mi Xiaomi, el resto déjalo como está."* |
| Ir con calma | *"Limpia mi móvil, pero de momento solo el bloque de publicidad y rastreo."* |
| Repetir tras una actualización | *"Se me ha actualizado el móvil y han vuelto los anuncios, déjalo como lo dejó ReMi."* |
| Deshacer todo | *"Deshaz todo lo que hizo ReMi en mi móvil."* |
| Deshacer una sola app | *"Devuélveme Mi Música, que la echo de menos."* |
| Cambiar solo el aspecto | *"Pon un launcher tipo Pixel y la letra un poco más grande."* |

### 5. Qué va a pasar
1. ReMi detecta tu móvil y te dice qué ha encontrado (modelo, versión, región).
2. Guarda una **copia de seguridad** de tus apps y ajustes en tu ordenador.
3. Te enseña **bloques** de cambios (publicidad, apps de terceros, apps de Xiaomi con
   anuncios…). Cada bloque muestra qué es cada app, los comandos exactos y si está probado.
   Respondes **"sí"**, **"no"** o **"sí, pero deja X"**.
4. Te pregunta por el aspecto, mostrándote siempre el valor actual y la opción
   "dejar como está".
5. Te da una lista corta de interruptores que hay que apagar a mano (cosas que `adb` no
   puede cambiar).
6. Deja en tu ordenador una carpeta `remi/<móvil>-<fecha>/` con:
   - `RESUMEN.md`: qué se cambió y qué no.
   - `remi-apply.sh`: para repetirlo tras una actualización.
   - `remi-restore.sh`: para deshacerlo todo.
   - la copia de seguridad de tus apps y ajustes.

### 6. Al terminar (importante)
En **Opciones de desarrollador**:
1. Toca **Revocar autorizaciones de depuración USB**.
2. Desactiva **Depuración USB** y **Depuración USB (ajustes de seguridad)**.
3. Desactiva las **Opciones de desarrollador**.

Así ningún ordenador puede controlar el móvil y las apps del banco que lo comprueban
funcionarán con normalidad. Vuelve a activarlas solo cuando quieras repetir ReMi.

---

## Por qué es seguro

| Principio | Qué significa para ti |
|---|---|
| **Solo herramientas oficiales** | `adb` de Google y comandos que ya trae Android. Nada descargado de foros ni de terceros. |
| **Sin root ni desbloqueo** | El sistema no se modifica. El móvil sigue "de fábrica" a ojos de bancos, Google Wallet y apps de pago. |
| **ReMi no decide qué quitar** | Solo propone apps que están en el perfil revisado de tu marca **y** que de verdad tienes. Si pides quitar otra, te avisa de que no está revisada y la pone en un bloque aparte. |
| **Lista de "no tocar"** | Las piezas críticas (cuentas, seguridad, Google Play, launcher del sistema, componentes del procesador…) están bloqueadas aunque lo pidas. |
| **Todo es reversible** | Las apps no se borran del sistema: se ocultan para tu usuario (`pm uninstall -k --user 0`) conservando sus datos, y vuelven con `cmd package install-existing`. Cada ajuste guarda su valor anterior. |
| **Nada sin tu "sí"** | Ves los comandos exactos de cada bloque antes de aplicarlos. |
| **Transparente** | ReMi y los perfiles son archivos de texto que cualquiera puede leer y revisar. |
| **Honesto con lo no probado** | Cada app y ajuste lleva su estado (probado / comunidad / sin probar) y ReMi te avisa antes de aplicar lo que no está probado. |

---

## Preguntas frecuentes

### ¿Me va a cerrar sesión en mis cuentas?
No. ReMi nunca toca tu cuenta de Google, tu cuenta Xiaomi, Google Play ni Servicios de
Google Play: están en la lista de "no tocar". Las apps que instalaste tú (WhatsApp, bancos,
redes sociales…) no están en ningún perfil, así que nunca se proponen.

### ¿Voy a perder mis notas, fotos, música o conversaciones?
No.
- Tus fotos, vídeos, música y descargas son archivos en la memoria del móvil, no están
  "dentro" de las apps. Quitar Mi Video no borra ningún vídeo.
- Notas, Galería, Tiempo o Copia de seguridad son "avanzadas": no se quitan salvo que lo
  pidas. Y aunque lo pidas, `-k` conserva sus datos.
- WhatsApp y tus apps nunca se tocan.

### ¿Qué apps se quitan? ¿Puedo elegir?
Por defecto: el servicio de anuncios de Xiaomi, analítica, la pantalla de la izquierda con
noticias, el carrusel de fondos de la pantalla de bloqueo, GetApps, Mi Video, Mi Música,
Limpiador, Tienda/Comunidad Xiaomi y las apps de terceros preinstaladas (Facebook, Booking,
juegos…). Tú decides en cada bloque: *"sí, pero deja Facebook"*.

Si usas una app preinstalada (Facebook, Netflix, Spotify, Amazon…), dilo para que no se
quite. Si se quita por error, se recupera con un comando o desde Play Store.

### ¿Cómo vuelvo a como estaba? ¿Me cerrará sesión?
Con un comando:
```
adb push remi-restore.sh /data/local/tmp/
adb shell sh /data/local/tmp/remi-restore.sh
```
O pídeselo a Claude: *"deshaz todo lo que hizo ReMi"*. Devuelve todas las apps y pone cada
ajuste en su valor anterior. **No cierra sesión**: tus cuentas nunca se tocaron, y las apps
vuelven normalmente con sus datos. Como mucho, alguna app restaurada (por ejemplo Facebook)
podría pedirte iniciar sesión otra vez dentro de esa app. Si una actualización del sistema
borró una app del sistema, esa en concreto se reinstala desde Play Store.

### ¿Funcionarán mis apps del banco?
Sí. ReMi no rootea ni desbloquea nada, que es lo que hace que los bancos bloqueen un móvil.
Lo que necesitan (Servicios de Google Play, componentes de seguridad, el navegador interno)
está protegido.

Algunas apps de banco **no abren mientras la depuración USB está activada**. Por eso, al
terminar, sigue el paso 6 de la guía: revocar autorizaciones y desactivar la depuración USB
y las Opciones de desarrollador.

### ¿Puede ReMi o Claude ver mis datos del banco o mis contraseñas?
No. Android encierra los datos de cada app (sesiones, contraseñas, claves) en un espacio
privado al que `adb` no puede acceder sin root, y ReMi nunca hace root. ReMi solo lee la
**lista** de apps instaladas y ajustes del sistema como la velocidad de animación o la
densidad de pantalla.

### ¿Qué se instala en mi ordenador y en mi móvil?
- **Ordenador:** solo las Platform-Tools oficiales de Google (`adb`) y la skill, que son
  archivos de texto.
- **Móvil:** nada, salvo el launcher que tú elijas, que viene de Play Store o de la web
  oficial de su desarrollador. ReMi solo oculta apps y cambia ajustes.

### ¿Pierdo la garantía?
ReMi no rootea, no desbloquea el bootloader y no modifica el sistema, que es lo que suele
afectar a la garantía. Ocultar apps con `adb` es una función estándar de Android. Aun así, no
podemos garantizar la política de cada fabricante o tienda.

### ¿Y si algo sale mal?
- Si una función de Xiaomi deja de ir bien, ejecuta `remi-restore.sh` o pide a Claude que
  devuelva esa app concreta.
- Si un comando falla, ReMi no lo reintenta a ciegas: lo anota, sigue con el resto y te lo
  cuenta al final.
- Caso extremo (muy improbable gracias a la lista de "no tocar"): si el móvil no arrancara,
  un restablecimiento de fábrica devuelve todas las apps, porque nunca se borraron del
  sistema. Por eso se recomienda una copia de seguridad antes de empezar.

### ¿Está probado?
El perfil de Xiaomi/HyperOS se ha construido a partir de fuentes públicas y se ha probado con
un móvil simulado, pero **todavía no en un Redmi Note 13 Pro real**. Por eso todas sus
entradas están marcadas como "comunidad" y ReMi te lo recuerda en cada bloque. Si quieres ir
con calma, aplica primero solo el bloque de publicidad y usa el móvil un día.

### ¿Qué pasa cuando se actualice el móvil?
Las actualizaciones de HyperOS a veces reinstalan apps quitadas. Dile a Claude *"se me ha
actualizado el móvil"*: ReMi compara con tu sesión anterior, te dice qué ha vuelto y lo
reaplica con `remi-apply.sh`.

### ¿Qué es eso del "DNS privado" que me ofrece?
Es un ajuste opcional, desactivado por defecto, que bloquea anuncios también dentro de apps
y webs usando el DNS público de AdGuard. AdGuard vería qué webs visitas, aunque no su
contenido: el tráfico del banco va cifrado. Algunas Wi-Fi de hoteles o aeropuertos fallan
con él. Si no te convence, di que no.

### ¿Mi copia de seguridad es privada?
Se queda solo en tu ordenador, en la carpeta donde ejecutaste ReMi. Contiene la lista de tus
apps (por ejemplo, qué banco usas), así que no la compartas y **no ejecutes ReMi dentro de
este repositorio**, para no subirla a GitHub por error.

### ¿Necesito saber programar?
No. Hablas con Claude normalmente. Lo único "técnico" es activar la depuración USB, y ReMi
te guía paso a paso.

---

## Aportar una marca
Copia `remi/profiles/_TEMPLATE.md`, sigue `remi/references/profile-guide.md` y abre un
Pull Request. Todo perfil nuevo empieza como "sin probar" y pasa una revisión (lista de
"no tocar", estados honestos, informe de prueba) antes de publicarse.

## Aviso
Quitar apps del sistema siempre conlleva algún riesgo. ReMi lo reduce al mínimo (lista de
"no tocar", cambios reversibles, confirmación por bloques, avisos de lo no probado), pero lo
usas bajo tu responsabilidad.

---

<a id="english"></a>
## English

**ReMi** is a Claude skill that removes ads and bloatware from Android phones and
personalizes them, using only Google's official `adb`: no root, no third-party tools, and
everything can be undone.

### How to use
1. Install **Claude Code** (https://claude.com/claude-code). Copy `remi/` to
   `~/.claude/skills/remi/` (Windows: `%USERPROFILE%\.claude\skills\remi\`), or open
   `remi.skill` in the Claude app and click **Save skill**.
2. On the phone, enable Developer options → **USB debugging** (Xiaomi: also **USB debugging
   (Security settings)**), connect the cable and accept the prompt.
3. Open Claude Code in a folder **outside this repo** and ask, for example:
   > My Redmi Note 13 Pro is connected over USB. Remove all the ads and junk apps and make it
   > snappier: fast animations, a bit more on screen, gestures without the bottom bar. Keep
   > Spotify, I use it.
4. Confirm each block. ReMi saves a backup, `remi-apply.sh` (re-apply after updates) and
   `remi-restore.sh` (undo everything).
5. When done, revoke USB debugging authorizations and turn off USB debugging and Developer
   options. Some banking apps won't open while debugging is on.

### Common questions
- **Will I be logged out?** No. Google and Xiaomi accounts and Play Services are on the
  do-not-touch list, and apps you installed are never proposed.
- **Will I lose notes, photos or chats?** No. Files live in storage, not inside apps; Notes
  and Gallery are only removed on request; `-k` keeps app data.
- **How do I undo it? Will that log me out?** Run `remi-restore.sh` or ask Claude. It doesn't
  log you out; at most a restored app may ask you to sign in to that one app again.
- **Banking apps?** They keep working: no root, no unlock. Turn USB debugging off afterwards.
- **Can ReMi see my banking data?** No. Android sandboxes app data and `adb` can't read it
  without root. ReMi only reads the app list and system settings.
- **What gets installed?** Only Google's Platform-Tools on the PC; nothing on the phone
  except a launcher you choose.
- **Is it tested?** The Xiaomi profile is marked `community`: built from public sources and
  tested on a simulated phone, not yet on a real one. ReMi warns before applying it.
- **Is my backup private?** It stays on your computer and lists your apps, so don't share it
  or run ReMi inside this repo.

### Contribute a brand
Copy `remi/profiles/_TEMPLATE.md`, follow `remi/references/profile-guide.md` and open a PR.
New profiles start as `untested`.
