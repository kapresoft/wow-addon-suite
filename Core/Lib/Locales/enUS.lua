--[[

    Please do NOT edit this file.
    The contents of this file will be generated automatically.
    
]]--
local addonName, ns = ...
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

L['Add-Ons::Desc']            = 'To activate or deactivate an Add-On, check or uncheck its corresponding box. After making your selections, click on "Apply and ReloadUI" to implement the changes to your configuration.'
L['Apply and Reload']         = true
L['Apply and Reload::Desc']   = 'Apply and Reload Immediately with |cfdE64750No Confirmation.|r\n\nTo activate or deactivate an Add-On, check or uncheck its corresponding box. After making your selections, click on this button to implement the changes to your configuration.'
L['Sync with Profile and Reload'] = 'Sync with Profile and Reload'
L['Select Profile']           = true
L['Select Profile::Desc']     = 'Select a profile to activate.  You will be prompted to reload the UI.  Note that these profiles are managed on the Profiles tab.'

L['Global Setting']           = '|cfd6F97FF(Global Setting)'
L['Character Setting']        = '|cfd6F97FF(Character-Specific Setting)|r'

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

L['Sync addon states']               = 'Sync addon states on close'
L['Sync addon states::Desc']         = 'Enable this to ensure your addons align with your profile after closing the settings dialog. You\'ll see a confirmation dialog before reloading, detailing which addons will be enabled or disabled. Remember, |cfdE64750frequent alerts|r might gently nudge you more often than expected.'

L['Include Addon Changes in Reload Confirmation'] = true
L['Include Addon Changes in Reload Confirmation::Desc'] = 'Enable to see which addons will be enabled or disabled listed within the reload confirmation dialog, giving you a clear overview before proceeding.'

L['Confirm Reloads When Switching Profiles']        = 'Confirm Reloads when switching profiles'
L['Confirm Reloads When Switching Profiles::Desc']  = 'Opting for this setting adds a confirmation step before the UI reloads when you switch profiles through a left-click on the minimap menu. It\'s a safeguard to avoid accidental disruptions.'
L['Hide Minimap Icon']               = true
L['Hide Minimap Icon::Desc']         = 'Toggles the visibility of the addon\'s minimap icon, hiding it from view when enabled.'

L['View or switch profiles']         = true
L['Open minimap settings dialog']    = true
L['View available commands']         = true
L['Open settings dialog']            = true
L['Command Lines']                   = true

L['Add to Favorite']                 = true
L['Add to Favorite::Desc']           = "Enable this option to display the current profile in the minimap profile switch menu accessible with a LEFT-click, allowing for easy access. Disable to hide the profile from the menu."
L['Minimap']                         = true
L['Minimap::Desc']                   = "Minimap Options"
L['General Minimap Settings']        = true

L['Favorite Profiles']               = 'Favorite Profiles'
L['Favorite Profiles::Desc']         = 'Select favorite profiles for the minimap menu, accessible with a LEFT-click. This menu lets you quickly switch between profiles to easily manage your addon sets.'

L['Switch Profile']                  = true

L['Reloads UI with confirmation']    = true
L['Reloads UI without confirmation'] = true

L['Select profile to activate']      = 'Select a profile below to activate'
L['without']                         = true
L['with']                            = true
L['confirmation']                    = true
L['No Confirmation']                 = true
L['Profile is out of sync']          = true
L['Click Key To Sync']               = 'Press ALT-LEFT-Click to sync profile and reload'
L['ALT-LEFT-Click']                  = true
L['LEFT-Click']                      = true
L['RIGHT-Click']                     = true
L['SHIFT-RIGHT-Click']               = true
L['Profile Sync Status Indicator']   = true
L['Profile Sync Status Indicator::Desc']   = 'Enable this option to use |cfdE64750color|r coding on the minimap icon, visually indicating when your profile is synced or needs an update. This provides a quick and easy way to check your profile\'s status at a glance.'
