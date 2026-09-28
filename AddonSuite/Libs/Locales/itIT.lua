--[[-----------------------------------------------------------------------------
Namespace
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)

local L = ns:NewLocale("itIT"); if not L then return end

--[[-----------------------------------------------------------------------------
Locale Entries
-------------------------------------------------------------------------------]]

L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG"]                  = 'Finestra delle opzioni'
L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG_MINIMAP"]          = 'Finestra delle opzioni: Minimappa'

L['%s version %s by %s is loaded.']        = '%s versione %s di %s è stato caricato.'
L['Type %s or %s for available commands.'] = 'Digita %s o %s per i comandi disponibili.'

L['Current Profile Color']            = ns.locale.profileNameColor
L['Current Profile Color::OutOfSync'] = ns.locale.profileNameColorOutOfSync
L['Current::Symbol::Options']   = ns.locale.greenIndicator
L['Current::Symbol::Minimap']   = ns.locale.checkMark

L['General']                  = 'Generale'
L['General::Desc']            = "Impostazioni generali"
L['General Configuration']    = 'Impostazioni generali'

L['General::Enable All::Button']           = ALL
L['General::Enable All::Button::Desc']     = 'Seleziona tutti gli addon sottostanti.'
L['General::Disable All::Button']          = NONE
L['General::Disable All::Button::Desc']    = 'Deseleziona tutti gli addon sottostanti.'

L['Add-Ons::Desc']            = 'Per attivare o disattivare un addon, seleziona o deseleziona la relativa casella. Successivamente, fai clic su |cdf6F97FFRicarica interfaccia|r per applicare le modifiche.'
L['Reload UI']         = 'Ricarica interfaccia'
L['Reload UI::Desc']   = 'Applica e ricarica immediatamente |cfdE64750senza conferma.|r'
L['Sync with Profile and Reload'] = 'Sincronizza con il profilo e ricarica'
L['Select Profile']           = 'Seleziona profilo'
L['Select Profile::Desc']     = 'Seleziona un profilo da attivare. Ti verrà chiesto di ricaricare l\'interfaccia. Questi profili vengono gestiti nella scheda Profili.'

L['Global Setting']           = 'Impostazione globale'
L['Character Setting']        = 'Impostazione del personaggio'

L['Debugging']                = 'Debug'
L['Debugging::Desc']          = 'Impostazioni di debug per la risoluzione dei problemi'
L['Debugging Configuration']  = 'Impostazioni di debug'
L['Log Level']                = 'Livello di log'
L['Log Level::Desc']          = 'Un livello di log più alto genera più voci:\nLivelli: ERROR(5), WARN(10), INFO(15), DEBUG(20), FINE(25), FINER(30), FINEST(35), TRACE(50)'
L['Categories']               = 'Categorie'
L['Current Profile']          = 'Profilo attuale'
L['Debugging::Category::Enable All::Button']           = ALL
L['Debugging::Category::Enable All::Button::Desc']     = 'Seleziona tutte le categorie di log sottostanti. La categoria predefinita (non mostrata qui) è sempre attiva.'
L['Debugging::Category::Disable All::Button']          = NONE
L['Debugging::Category::Disable All::Button::Desc']    = 'Deseleziona tutte le categorie di log sottostanti. La categoria predefinita (non mostrata qui) è sempre attiva.'

L['REQUIRES_RELOAD_PROFILE_CHANGED'] = 'Le modifiche agli addon del profilo selezionato richiedono un ricaricamento dell\'interfaccia per avere effetto. Questo attiverà gli addon selezionati e disattiverà quelli deselezionati.\n\nRicaricare ora?'

L['Prompt me to Reload UI::Desc'] = 'Attiva questa opzione per ricevere una richiesta di ricaricare l\'interfaccia alla chiusura della finestra delle opzioni, se sono state apportate modifiche che richiedono l\'attivazione o disattivazione di addon.'
L['Prompt me to Reload UI']       = 'Chiedimi di ricaricare l\'interfaccia quando necessario'

L['Include Addon Changes in Reload Confirmation']       = 'Includi le modifiche agli addon nella conferma di ricaricamento'
L['Include Addon Changes in Reload Confirmation::Desc'] = 'Attiva per vedere l\'elenco degli addon che verranno attivati o disattivati all\'interno della finestra di conferma del ricaricamento.'

L['Confirm Reloads When Switching Profiles']       = 'Conferma i ricaricamenti al cambio di profilo'
L['Confirm Reloads When Switching Profiles::Desc'] = 'Questa impostazione aggiunge un passaggio di conferma prima del ricaricamento dell\'interfaccia quando cambi profilo tramite clic sinistro sul menu della minimappa. Una protezione contro le modifiche accidentali.'

L['Hide']                    = 'Nascondi'
L['Hide Minimap Icon']       = 'Nascondi icona minimappa'
L['Hide Minimap Icon::Desc'] = 'Attiva/disattiva la visibilità dell\'icona dell\'addon sulla minimappa.'

L['Hide Minimap Icon TitanPanel']       = 'Nascondi icona minimappa quando aggiunta a TitanPanel'
L['Hide Minimap Icon TitanPanel::Desc'] = 'Nasconde l\'icona dell\'addon sulla minimappa quando viene aggiunta a TitanPanel.'

L['View or switch profiles']      = 'Visualizza o cambia profilo'
L['Open minimap settings'] = 'Apri le impostazioni della minimappa'
L['View available commands']      = 'Visualizza i comandi disponibili'
L['Open settings']                = 'Apri le opzioni'
L['Command Lines']                = 'Righe di comando'
L['Currently set to switch profiles %s a confirmation prompt.'] = 'Il cambio di profilo attualmente avviene %s.'

L['Add to Favorite']              = 'Aggiungi ai preferiti'
L['Add to Favorite::Desc']        = "Attiva questa opzione per mostrare il profilo attuale nel menu di cambio profilo della minimappa (clic sinistro). Disattiva per nascondere il profilo dal menu."
L['Minimap']                      = 'Minimappa'
L['Minimap::Desc']                = "Opzioni della minimappa"

L['Favorite Profiles']            = 'Profili preferiti'
L['Favorite Profiles::Desc']      = 'Seleziona i profili preferiti per il menu della minimappa (clic sinistro). Questo menu consente di passare rapidamente tra set di addon.'
L['Switch Profile']               = 'Cambia profilo'

L['Reloads UI with confirmation']    = 'Ricarica l\'interfaccia con conferma'
L['Reloads UI without confirmation'] = 'Ricarica l\'interfaccia senza conferma'

L['Select profile to activate'] = 'Seleziona di seguito un profilo da attivare'
L['without']                    = 'senza conferma'
L['with']                       = 'con conferma'
L['confirmation']               = 'conferma'
L['No Confirmation']            = 'Nessuna conferma'
L['Profile is out of sync']     = 'Il profilo non è sincronizzato e richiede un ricaricamento dell\'interfaccia.'
L['Click Key To Sync']          = 'Premi ALT+clic sinistro per sincronizzare e ricaricare'
L['ALT-LEFT-Click']             = 'ALT+clic sinistro'
L['LEFT-Click']                 = 'Clic sinistro'
L['RIGHT-Click']                = 'Clic destro'
L['SHIFT-RIGHT-Click']          = 'MAIUSC+clic destro'

L['Profile Sync Status Indicator']       = 'Indicatore di stato di sincronizzazione del profilo'
L['Profile Sync Status Indicator::Desc'] = 'Attiva questa opzione per usare una codifica a |cfdE64750colori|r sull\'icona della minimappa, che indica visivamente se il profilo è sincronizzato o necessita di un aggiornamento.'

L['Open debug settings'] = 'Apri le impostazioni di debug'

L['Enabled (After Reload)']  = 'Attivato (dopo il ricaricamento)'
L['Disabled (After Reload)'] = 'Disattivato (dopo il ricaricamento)'

L['Limit Profile Name Characters']       = 'Limita i caratteri del nome profilo...'
L['Limit Profile Name Characters::Desc'] = 'Imposta il numero massimo di caratteri per la visualizzazione del nome del profilo a destra dell\'icona dell\'addon in |cdf6F97FFTitan Panel|r. Se il nome supera questo limite, verrà troncato e terminerà con dei puntini di sospensione ("..."). Puoi impostare questo valore tra 5 e 20 caratteri.'

L['Show Profile Name']            = 'Mostra il nome del profilo'
L['Show Profile Name::Desc']      = 'Attiva questa opzione per mostrare il nome del profilo attuale subito a destra dell\'icona in |cdf6F97FFTitan Panel|r.'
L['Titan Panel Settings']         = 'Impostazioni Titan Panel'
L['Show Out of Sync Count']       = 'Mostra il conteggio degli addon non sincronizzati'
L['Show Out of Sync Count::Desc'] = 'Attiva questa impostazione per mostrare in |cdf6F97FFTitan Panel|r il numero di addon attualmente non sincronizzati con il profilo attivo.'
L['Lib:']                         = 'Libr.:'
L['Load on demand (loaded)']      = 'Caricamento su richiesta (caricato)'
L['Load on demand (not loaded)']  = 'Caricamento su richiesta (non caricato)'