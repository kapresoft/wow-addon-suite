--[[-----------------------------------------------------------------------------
Namespace
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)

local L = ns:NewLocale("deDE"); if not L then return end

--[[-----------------------------------------------------------------------------
Locale Entries
-------------------------------------------------------------------------------]]

L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG"]                  = 'Optionsfenster'
L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG_MINIMAP"]          = 'Optionsfenster: Minikarte'

L['%s version %s by %s is loaded.']        = '%s Version %s von %s wurde geladen.'
L['Type %s or %s for available commands.'] = 'Gib %s oder %s ein, um verfügbare Befehle anzuzeigen.'

L['Current Profile Color']            = ns.locale.profileNameColor
L['Current Profile Color::OutOfSync'] = ns.locale.profileNameColorOutOfSync
L['Current::Symbol::Options']   = ns.locale.greenIndicator
L['Current::Symbol::Minimap']   = ns.locale.checkMark

L['General']                  = 'Allgemein'
L['General::Desc']            = "Allgemeine Einstellungen"
L['General Configuration']    = 'Allgemeine Einstellungen'

L['General::Enable All::Button']           = ALL
L['General::Enable All::Button::Desc']     = 'Aktiviert alle Add-Ons unten.'
L['General::Disable All::Button']          = NONE
L['General::Disable All::Button::Desc']    = 'Deaktiviert alle Add-Ons unten.'

L['Add-Ons::Desc']            = 'Um ein Add-On zu aktivieren oder zu deaktivieren, setze oder entferne das entsprechende Häkchen. Klicke danach auf |cdf6F97FFUI neu laden|r, um die Änderungen zu übernehmen.'
L['Reload UI']         = 'UI neu laden'
L['Reload UI::Desc']   = 'Sofort übernehmen und neu laden |cfdE64750ohne Bestätigung.|r'
L['Sync with Profile and Reload'] = 'Mit Profil synchronisieren und neu laden'
L['Select Profile']           = 'Profil auswählen'
L['Select Profile::Desc']     = 'Wähle ein Profil zur Aktivierung aus. Du wirst aufgefordert, die UI neu zu laden. Diese Profile werden im Reiter "Profile" verwaltet.'

L['Global Setting']           = 'Globale Einstellung'
L['Character Setting']        = 'Charaktereinstellung'

L['Debugging']                = 'Fehlersuche'
L['Debugging::Desc']          = 'Debug-Einstellungen zur Fehlerbehebung'
L['Debugging Configuration']  = 'Debug-Einstellungen'
L['Log Level']                = 'Log-Stufe'
L['Log Level::Desc']          = 'Eine höhere Log-Stufe erzeugt mehr Einträge:\nStufen: ERROR(5), WARN(10), INFO(15), DEBUG(20), FINE(25), FINER(30), FINEST(35), TRACE(50)'
L['Categories']               = 'Kategorien'
L['Current Profile']          = 'Aktuelles Profil'
L['Debugging::Category::Enable All::Button']           = ALL
L['Debugging::Category::Enable All::Button::Desc']     = 'Aktiviert alle Log-Kategorien unten. Die Standardkategorie (hier nicht angezeigt) ist immer aktiv.'
L['Debugging::Category::Disable All::Button']          = NONE
L['Debugging::Category::Disable All::Button::Desc']    = 'Deaktiviert alle Log-Kategorien unten. Die Standardkategorie (hier nicht angezeigt) ist immer aktiv.'

L['REQUIRES_RELOAD_PROFILE_CHANGED'] = 'Die Add-On-Änderungen deines gewählten Profils erfordern einen UI-Neustart, um wirksam zu werden. Dabei werden markierte Add-Ons aktiviert und nicht markierte deaktiviert.\n\nJetzt neu laden?'

L['Prompt me to Reload UI::Desc'] = 'Aktiviere diese Option, um beim Schließen des Optionsfensters gefragt zu werden, ob die UI neu geladen werden soll, wenn Änderungen an der Aktivierung/Deaktivierung von Add-Ons vorgenommen wurden.'
L['Prompt me to Reload UI']       = 'Bei Bedarf zum Neuladen der UI auffordern'

L['Include Addon Changes in Reload Confirmation']       = 'Add-On-Änderungen in Neustart-Bestätigung anzeigen'
L['Include Addon Changes in Reload Confirmation::Desc'] = 'Aktivieren, um im Bestätigungsdialog eine Liste der Add-Ons zu sehen, die aktiviert oder deaktiviert werden.'

L['Confirm Reloads When Switching Profiles']       = 'Neustart beim Profilwechsel bestätigen'
L['Confirm Reloads When Switching Profiles::Desc'] = 'Diese Einstellung fügt einen Bestätigungsschritt hinzu, bevor die UI beim Profilwechsel per Linksklick auf das Minikarten-Menü neu geladen wird. Ein Schutz vor versehentlichen Änderungen.'

L['Hide']                    = 'Verbergen'
L['Hide Minimap Icon']       = 'Minikarten-Symbol verbergen'
L['Hide Minimap Icon::Desc'] = 'Blendet das Minikarten-Symbol des Add-Ons ein oder aus.'

L['Hide Minimap Icon TitanPanel']       = 'Minikarten-Symbol bei TitanPanel-Integration verbergen'
L['Hide Minimap Icon TitanPanel::Desc'] = 'Verbirgt das Minikarten-Symbol des Add-Ons, wenn es zu TitanPanel hinzugefügt wurde.'

L['View or switch profiles']      = 'Profile anzeigen oder wechseln'
L['Open minimap settings'] = 'Minikarten-Einstellungen öffnen'
L['View available commands']      = 'Verfügbare Befehle anzeigen'
L['Open settings']                = 'Einstellungen öffnen'
L['Command Lines']                = 'Befehlszeilen'
L['Currently set to switch profiles %s a confirmation prompt.'] = 'Profilwechsel erfolgt derzeit %s.'

L['Add to Favorite']              = 'Zu Favoriten hinzufügen'
L['Add to Favorite::Desc']        = "Aktiviere diese Option, damit das aktuelle Profil im Minikarten-Profilwechselmenü (Linksklick) angezeigt wird. Deaktivieren, um das Profil aus dem Menü auszublenden."
L['Minimap']                      = 'Minikarte'
L['Minimap::Desc']                = "Minikarten-Einstellungen"

L['Favorite Profiles']            = 'Favoritenprofile'
L['Favorite Profiles::Desc']      = 'Wähle Favoritenprofile für das Minikarten-Menü (Linksklick) aus. Über dieses Menü kannst du schnell zwischen Add-On-Sets wechseln.'
L['Switch Profile']               = 'Profil wechseln'

L['Reloads UI with confirmation']    = 'Lädt die UI mit Bestätigung neu'
L['Reloads UI without confirmation'] = 'Lädt die UI ohne Bestätigung neu'

L['Select profile to activate'] = 'Wähle unten ein Profil zur Aktivierung aus'
L['without']                    = 'ohne Bestätigung'
L['with']                       = 'mit Bestätigung'
L['confirmation']               = 'Bestätigung'
L['No Confirmation']            = 'Keine Bestätigung'
L['Profile is out of sync']     = 'Profil ist nicht synchron und erfordert einen UI-Neustart.'
L['Click Key To Sync']          = 'ALT+Linksklick, um zu synchronisieren und neu zu laden'
L['ALT-LEFT-Click']             = 'ALT+Linksklick'
L['LEFT-Click']                 = 'Linksklick'
L['RIGHT-Click']                = 'Rechtsklick'
L['SHIFT-RIGHT-Click']          = 'SHIFT+Rechtsklick'

L['Profile Sync Status Indicator']       = 'Profil-Synchronisationsanzeige'
L['Profile Sync Status Indicator::Desc'] = 'Aktiviere diese Option, um |cfdE64750farbliche|r Kennzeichnung am Minikarten-Symbol zu verwenden, die anzeigt, ob dein Profil synchron ist oder eine Aktualisierung benötigt.'

L['Open debug settings'] = 'Debug-Einstellungen öffnen'

L['Enabled (After Reload)']  = 'Aktiviert (nach Neustart)'
L['Disabled (After Reload)'] = 'Deaktiviert (nach Neustart)'

L['Limit Profile Name Characters']       = 'Zeichenanzahl des Profilnamens begrenzen...'
L['Limit Profile Name Characters::Desc'] = 'Lege die maximale Zeichenanzahl für die Anzeige des Profilnamens rechts neben dem Add-On-Symbol in |cdf6F97FFTitan Panel|r fest. Überschreitet der Name diese Grenze, wird er gekürzt und mit Auslassungspunkten ("...") beendet. Bereich: 5 bis 20 Zeichen.'

L['Show Profile Name']            = 'Profilname anzeigen'
L['Show Profile Name::Desc']      = 'Aktiviere diese Option, um den Namen des aktuellen Profils rechts neben dem Symbol in |cdf6F97FFTitan Panel|r anzuzeigen.'
L['Titan Panel Settings']         = 'Titan-Panel-Einstellungen'
L['Show Out of Sync Count']       = 'Anzahl nicht synchroner Add-Ons anzeigen'
L['Show Out of Sync Count::Desc'] = 'Aktiviere diese Einstellung, um in |cdf6F97FFTitan Panel|r die Anzahl der Add-Ons anzuzeigen, die derzeit nicht mit dem aktiven Profil synchron sind.'
L['Lib:']                         = 'Bibl.:'