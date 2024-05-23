--[[-----------------------------------------------------------------------------
Type: LocaleInfo
-------------------------------------------------------------------------------]]
--- @class LocaleInfo
--- @field greenIndicator string
--- @field checkMark string
--- @field xSymbol string
--- @field lineSeparator1 string
--- @field profileNameColor string
--- @field profileNameColorOutOfSync string

--[[-----------------------------------------------------------------------------
Namespace
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local addonName = ns.addon

local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "enUS", true);

ns.locale.greenIndicator   = '|TInterface\\Common\\Indicator-Green:16:16:0:-1|t'
ns.locale.checkMark        = '|TInterface\\Buttons\\UI-CheckBox-Check:21:21:0:-1|t'
ns.locale.xSymbol          = '|TInterface\\Glues\\Login\\Glues-CheckBox-Check:14:14:0:0|t'
ns.locale.lineSeparator1   = '|TInterface\\RaidFrame\\Raid-HSeparator:5:320:0:0|t'
--- This is the hex color of the current profile
ns.locale.profileNameColor = '12E600'
ns.locale.profileNameColorOutOfSync = 'E64750'

-- red-ish: E64750 Ex: |cfdE64750 Red-ish |r
-- blue: 6F97FF  Ex: |cdf6F97FF Hello |r
-- example
--[[-----------------------------------------------------------------------------
Locale Entries
-------------------------------------------------------------------------------]]

L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG"]                  = 'Options Dialog'
L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG_MINIMAP"]          = 'Options Dialog : Minimap'

L['%s version %s by %s is loaded.']        = true
L['Type %s or %s for available commands.'] = true

L['Current Profile Color']            = ns.locale.profileNameColor
L['Current Profile Color::OutOfSync'] = ns.locale.profileNameColorOutOfSync
L['Current::Symbol::Options']   = ns.locale.greenIndicator
L['Current::Symbol::Minimap']   = ns.locale.checkMark

L['General']                  = true
L['General::Desc']            = "General Settings"
L['General Configuration']    = true

L['General::Enable All::Button']           = 'All'
L['General::Enable All::Button::Desc']     = 'Checks all add-ons below.'
L['General::Disable All::Button']          = 'None'
L['General::Disable All::Button::Desc']    = 'Unchecks all add-ons below.'

L['Add-Ons::Desc']            = 'To activate or deactivate an addon, check or uncheck its corresponding box. After making your selections, click on |cdf6F97FFReloadUI|r to implement the changes to your configuration.'
L['Reload UI']         = true
L['Reload UI::Desc']   = 'Apply and Reload Immediately with |cfdE64750No Confirmation.|r'
L['Sync with Profile and Reload'] = 'Sync with Profile and Reload'
L['Select Profile']           = true
L['Select Profile::Desc']     = 'Select a profile to activate.  You will be prompted to reload the UI.  Note that these profiles are managed on the Profiles tab.'

L['Global Setting']           = 'Global Setting'
L['Character Setting']        = 'Character Setting'

L['Debugging']                = true
L['Debugging::Desc']          = 'Debug Settings for troubleshooting'
L['Debugging Configuration']  = true
L['Log Level']                = true
L['Log Level::Desc']          = 'Higher log levels generate more logs:\nLog Levels: ERROR(5), WARN(10), INFO(15), DEBUG(20), FINE(25), FINER(30), FINEST(35), TRACE(50)'
L['Categories']               = true
L['Current Profile']          = true
L['Debugging::Category::Enable All::Button']           = 'All'
L['Debugging::Category::Enable All::Button::Desc']     = 'Checks all log categories below. Note that the default category (not shown here) will always be active.'
L['Debugging::Category::Disable All::Button']          = 'None'
L['Debugging::Category::Disable All::Button::Desc']    = 'Unchecks all log categories below. Note that the default category (not shown here) will always be active.'

L['REQUIRES_RELOAD_PROFILE_CHANGED'] = 'Your selected profile\'s addon changes require a UI reload to take effect. This will enable checked addons and disable unchecked ones.\n\nReload now?'

L['Prompt me to Reload UI::Desc'] = 'Enable this option to receive a prompt asking to reload the UI when closing the settings dialog, if changes requiring activation or deactivation of addons were made.'
L['Prompt me to Reload UI']       = 'Prompt me to Reload UI on close as needed'

L['Include Addon Changes in Reload Confirmation']       = true
L['Include Addon Changes in Reload Confirmation::Desc'] = 'Enable to see which addons will be enabled or disabled listed within the reload confirmation dialog, giving you a clear overview before proceeding.'

L['Confirm Reloads When Switching Profiles']       = 'Confirm Reloads when switching profiles'
L['Confirm Reloads When Switching Profiles::Desc'] = 'Opting for this setting adds a confirmation step before the UI reloads when you switch profiles through a left-click on the minimap menu. It\'s a safeguard to avoid accidental disruptions.'

L['Hide']                    = true
L['Hide Minimap Icon']       = true
L['Hide Minimap Icon::Desc'] = 'Toggles the visibility of the addon\'s minimap icon, hiding it from view when enabled.'

L['Hide Minimap Icon TitanPanel']       = 'Hide Minimap Icon When Added to TitanPanel'
L['Hide Minimap Icon TitanPanel::Desc'] = 'Toggles the visibility of the addon\'s minimap icon when added to a TitanPanel, hiding it from view when enabled.'

L['View or switch profiles']      = true
L['Open minimap settings dialog'] = true
L['View available commands']      = true
L['Open settings dialog']         = true
L['Command Lines']                = true

L['Add to Favorite']              = true
L['Add to Favorite::Desc']        = "Enable this option to display the current profile in the minimap profile switch menu accessible with a LEFT-click, allowing for easy access. Disable to hide the profile from the menu."
L['Minimap']                      = true
L['Minimap::Desc']                = "Minimap Options"

L['Favorite Profiles']            = 'Favorite Profiles'
L['Favorite Profiles::Desc']      = 'Select favorite profiles for the minimap menu, accessible with a LEFT-click. This menu lets you quickly switch between profiles to easily manage your addon sets.'
L['Switch Profile']               = true

L['Reloads UI with confirmation']    = true
L['Reloads UI without confirmation'] = true

L['Select profile to activate'] = 'Select a profile below to activate'
L['without']                    = true
L['with']                       = true
L['confirmation']               = true
L['No Confirmation']            = true
L['Profile is out of sync']     = 'Profile is out of sync and requires a UI Reload.'
L['Click Key To Sync']          = 'Press ALT-LEFT-Click to sync profile and reload'
L['ALT-LEFT-Click']             = true
L['LEFT-Click']                 = true
L['RIGHT-Click']                = true
L['SHIFT-RIGHT-Click']          = true

L['Profile Sync Status Indicator']       = true
L['Profile Sync Status Indicator::Desc'] = 'Enable this option to use |cfdE64750color|r coding on the minimap icon, visually indicating when your profile is synced or needs an update. This provides a quick and easy way to check your profile\'s status at a glance.'

L['Enabled (After Reload)']  = true
L['Disabled (After Reload)'] = true

L['Limit Profile Name Characters']       = 'Limit Profile Name Characters...'
L['Limit Profile Name Characters::Desc'] = 'Set the maximum number of characters for displaying player profile names displayed to the right of the addon icon in |cdf6F97FFTitan Panel|r. If a name exceeds this limit, it will be shortened and end with an ellipsis ("..."). You can adjust this setting to anywhere between 5 and 20 characters.'

L['Show Profile Name']            = true
L['Show Profile Name::Desc']      = 'Enable this option to display the current profile name directly to the right of the icon in |cdf6F97FFTitan Panel|r. When selected, it allows you to quickly see which profile is active.'
L['Titan Panel Settings']         = true
L['Show Out of Sync Count']       = true
L['Show Out of Sync Count::Desc'] = 'Enable this setting to display the number of addons in |cdf6F97FFTitan Panel|r that are currently out of sync with the active profile.'
L['Lib:']                         = true
