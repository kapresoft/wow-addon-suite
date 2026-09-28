# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AddonSuite is a World of Warcraft addon manager: players toggle groups of other addons on/off per Ace3 profile, so different addon sets can be swapped in for different gameplay (raiding, questing, etc.), with a minimap icon for quick profile switching. It supports every WoW client (Retail, Classic Era, TBC, Wrath, Cata, Mists).

## Build & Release

See "Build & Release (WoW addons)" in the global `~/.claude/CLAUDE.md`.

## Architecture

### Load order

The addon lives in the `AddonSuite/` subfolder. A single `AddonSuite.toc` lists every client in its `## Interface:` line and loads `ThirdParty\ThirdParty.xml`, then `Libs\_Libs.xml`. `_Libs.xml` loads, in order: `_Core.lua`, `Global/`, dev-only `DeveloperSetup.lua`, `API/`, `Locales/`, `Modules/`, dev-only `Developer.lua`, and finally `AddonSuite.lua` (the entry point: `AceAddon:NewAddon`, `OnInitialize`). Add new files to `_Libs.xml`. Client differences are handled inside the shared Lua.

Embedded libs (Ace3, LibDataBroker/LibDBIcon, LibPrettyPrint, LibTraceKit, Kapresoft-LibUtil modules) load from `ThirdParty/ThirdParty.xml`.

### Namespace & module registry

`Libs/Global/Namespace.lua` defines the central `ns` object; `NamespaceModules.lua` registers the Kapresoft-LibUtil modules (via `Kapresoft-ModuleUtil-2-0`). Modules register into `ns.O` and are accessed via `ns.O.ModuleName`. Global constants live on `ns.GC` (`GlobalConstants.lua`), with `ns.GC.C` and `ns.GC.M` (message names) groups; same convention as DevSuite.

### Key files (`AddonSuite/Libs/`)

| File | Role |
|---|---|
| `Global/DefaultAddOnDatabase.lua` | Default AceDB shape for addon-group state |
| `Global/EventMessagesMixin.lua` | Message/event helpers |
| `API/API.lua`, `API/AddOnDependencyUtil.lua` | Public API and addon dependency helpers |
| `Modules/SynchronizedAddOns.lua` | Tracks/syncs which addons belong to which managed group |
| `Modules/AddOnStateController.lua` | Enable/disable state control for managed addons |
| `Modules/MainController.lua` | Top-level wiring |
| `Modules/Options*Mixin.lua`, `OptionsUtilMixin.lua` | Options dialog panels (addon list, minimap icon, general) |
| `Modules/MinimapIconControllerMixin.lua` | Minimap icon (LibDataBroker/LibDBIcon) |
| `Modules/ConfigDialogController.lua`, `AceConfigDialogUtil.lua` | AceConfig dialog wiring |
| `Modules/AceDbInitializerMixin.lua` | AceDB setup/init |
| `Developer/` | Dev-only utilities (see below) |

### Dev-only code

Wrap dev-only Lua/XML includes in `--@do-not-package@` / `--@end-do-not-package@` (see the `Developer` includes in `Libs/_Libs.xml`), same as DebugChatFrame and DevSuite. The packager strips these blocks in release builds.

## Key conventions

- **Mixin-based OOP:** composition via `Mixin()`/`CreateFromMixins()`, not inheritance chains. Keep mixins focused on a single concern.
- **Testing in game:** `/fstack` to inspect frames, `/dump` to inspect values.
- **SavedVariables:** `ADDON_SUITE_DB` (account), `ADDON_SUITE_CHARACTER_DB` (per-character), `ADDON_SUITE_LOG_LEVEL`/`ADDON_SUITE_DEBUG_MODE`/`ADDON_SUITE_DEBUG_ENABLED_CATEGORIES` (debug state); see `AddonSuite.toc`.
- **OptionalDeps:** `Ace3, DevSuite`. Ace3 is embedded, so it's always available; DevSuite may be absent.
- **Addon management is the core domain:** changes to `SynchronizedAddOns.lua`/`AddOnStateController.lua` change the real enable/disable state of the user's other addons. Treat these paths with the care due to anything that mutates state outside this addon.

## Code style

Formatting is enforced by `stylua.toml`: 100-column width, 2-space indent, Unix line endings, prefer single quotes, keep parens on function calls, collapse simple statements onto one line. Match this on touched lines; don't reformat whole files as a side effect of an unrelated change.
