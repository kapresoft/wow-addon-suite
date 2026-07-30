# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AddonSuite is a World of Warcraft addon manager: it lets players toggle groups of other addons on/off per Ace3 profile, so different addon sets can be swapped in for different gameplay scenarios (raiding, questing, etc.), with a minimap icon for quick profile switching. It supports all WoW versions (Retail, Classic, TBC, Wrath).

## Build & Release

### Pull external library dependencies

```shell
cd <project-dir>
w-sync-libs
```

### Deployment to local WoW installs

#### One-time deploy
```shell
w-deployer -c ./dev/deployer-config.lua
```

#### Continuous Deploy with 'quiet' -q and 'watch' -w mode

```shell
w-deployer -c ./dev/deployer-config.lua -qw
```

### Release process
1. Create pull requests
2. Create tag to publish--an automated github action will push any tag created
3. Verify CurseForge build is green, then publish the GitHub draft release

There are no automated tests. Validation is done in-game.

## Architecture

### Load order

`AddonSuite.toc` loads `Core\_Core.xml`, which in turn includes (in order): `_ExtLib.xml` (Ace3/LibDataBroker), `_Core.lua`, dev-only `Lib\Developer\_DeveloperComponents.xml`, `Global\_Global.xml`, `Lib\_Lib.xml`, dev-only `Lib\Developer\_Developer.xml`, then `Core\AddonSuite.lua` (the addon entry point/`OnInitialize`-equivalent, registered via `LibStub:NewAddon`). Per-flavor folders (`Retail/`, `TBC/`, `Vanilla/`, `Wrath/`) each hold a thin `_<Flavor>.xml` that just re-includes `Core\AddonSuite.lua` -- flavor branching happens inside the shared Lua, not via separate per-flavor Lua files (contrast with DebugChatFrame's `ns.gameVersion`-per-file pattern).

### Namespace & module registry

`Core/Global/Namespace.lua` defines the central `ns` object; modules register into `ns.O`, accessed anywhere via `ns.O.ModuleName`. Global constants live on `ns.GC` (and `ns.GC.C` for a nested constants group) -- same `ns.O`/`ns.GC` convention as DevSuite.

### Key modules (`Core/Lib/` and `Core/Global/`)

| File | Role |
|---|---|
| `Global/SynchronizedAddOns.lua` | Tracks/syncs which addons belong to which managed group |
| `Global/DefaultAddOnDatabase.lua` | Default AceDB shape for addon-group state |
| `Global/CategoryLoggerMixin.lua` | Per-category logger mixin |
| `Global/EventMessagesMixin.lua` | Message/event constants and helpers |
| `Lib/AddOnStateController.lua` | Enable/disable state control for managed addons |
| `Lib/MainController.lua` | Top-level wiring |
| `Lib/OptionsAddonsMixin.lua` / `OptionsMinimapMixin.lua` / `OptionsMixin.lua` | Options dialog panels (addon list, minimap icon, general) |
| `Lib/MinimapIconControllerMixin.lua` | Minimap icon (LibDataBroker-based) |
| `Lib/ConfigDialogController.lua` / `AceConfigDialogUtil.lua` | AceConfig dialog wiring |
| `Lib/AceDbInitializerMixin.lua` | AceDB setup/init |
| `Lib/Developer/` | Dev-only utilities -- excluded from packaging (see below) |

### Dev-only code

Wrap dev-only Lua/XML with `--@do-not-package@` / `--@end-do-not-package@` tokens (see `Core/_Core.xml`'s `Lib\Developer\_DeveloperComponents.xml`/`_Developer.xml` includes) -- same convention as AddonSuite's sibling repos DebugChatFrame and DevSuite. The BigWigsMods packager strips these blocks in release builds.

## Key conventions

- **Mixin-based OOP** -- composition via `Mixin()`/`CreateFromMixins()`, not inheritance chains. Keep mixins focused on a single concern.
- **No unit test framework** -- test in-game. Use `/fstack` to inspect frames, `/dump` to inspect values.
- **EmmyLua annotations** -- the codebase uses EmmyLua (`---@param`, `---@return`, `---@class`) for IDE type checking. Maintain these on public APIs.
- **SavedVariables**: `ADDON_SUITE_DB` (account), `ADDON_SUITE_CHARACTER_DB` (per-character), `ADDON_SUITE_LOG_LEVEL`/`ADDON_SUITE_DEBUG_MODE`/`ADDON_SUITE_DEBUG_ENABLED_CATEGORIES` (debug state) -- see `AddonSuite.toc`.
- **OptionalDeps, not RequiredDeps**: only `Ace3` is declared, and even that is optional -- guard accordingly rather than assuming Ace3 libs are always present.
- **Addon-management is the core domain** -- changes to `SynchronizedAddOns.lua`/`AddOnStateController.lua` affect real enable/disable state of the user's other addons; treat these paths with the same care as anything else that mutates state outside this addon's own scope.

## Code style

Formatting is enforced by `stylua.toml`: 100-column width, 2-space indent, Unix line endings, prefer single quotes, keep parens on function calls, collapse simple statements onto one line. Match this on touched lines; don't reformat whole files as a side effect of an unrelated change.