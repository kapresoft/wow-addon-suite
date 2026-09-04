--[[-----------------------------------------------------------------------------
Namespace
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)

local L = ns:NewLocale("frFR"); if not L then return end

--[[-----------------------------------------------------------------------------
Locale Entries
-------------------------------------------------------------------------------]]

L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG"]                  = 'Fenêtre d\'options'
L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG_MINIMAP"]          = 'Fenêtre d\'options : Minicarte'

L['%s version %s by %s is loaded.']        = '%s version %s par %s est chargé.'
L['Type %s or %s for available commands.'] = 'Tapez %s ou %s pour voir les commandes disponibles.'

L['Current Profile Color']            = ns.locale.profileNameColor
L['Current Profile Color::OutOfSync'] = ns.locale.profileNameColorOutOfSync
L['Current::Symbol::Options']   = ns.locale.greenIndicator
L['Current::Symbol::Minimap']   = ns.locale.checkMark

L['General']                  = 'Général'
L['General::Desc']            = "Paramètres généraux"
L['General Configuration']    = 'Paramètres généraux'

L['General::Enable All::Button']           = ALL
L['General::Enable All::Button::Desc']     = 'Coche tous les addons ci-dessous.'
L['General::Disable All::Button']          = NONE
L['General::Disable All::Button::Desc']    = 'Décoche tous les addons ci-dessous.'

L['Add-Ons::Desc']            = 'Pour activer ou désactiver un addon, cochez ou décochez la case correspondante. Cliquez ensuite sur |cdf6F97FFRecharger l\'interface|r pour appliquer les modifications.'
L['Reload UI']         = 'Recharger l\'interface'
L['Reload UI::Desc']   = 'Applique et recharge immédiatement |cfdE64750sans confirmation.|r'
L['Sync with Profile and Reload'] = 'Synchroniser avec le profil et recharger'
L['Select Profile']           = 'Sélectionner un profil'
L['Select Profile::Desc']     = 'Sélectionnez un profil à activer. Il vous sera demandé de recharger l\'interface. Notez que ces profils sont gérés dans l\'onglet Profils.'

L['Global Setting']           = 'Paramètre global'
L['Character Setting']        = 'Paramètre du personnage'

L['Debugging']                = 'Débogage'
L['Debugging::Desc']          = 'Paramètres de débogage pour le dépannage'
L['Debugging Configuration']  = 'Paramètres de débogage'
L['Log Level']                = 'Niveau de journalisation'
L['Log Level::Desc']          = 'Un niveau de journalisation plus élevé génère plus d\'entrées :\nNiveaux : ERROR(5), WARN(10), INFO(15), DEBUG(20), FINE(25), FINER(30), FINEST(35), TRACE(50)'
L['Categories']               = 'Catégories'
L['Current Profile']          = 'Profil actuel'
L['Debugging::Category::Enable All::Button']           = ALL
L['Debugging::Category::Enable All::Button::Desc']     = 'Coche toutes les catégories de journalisation ci-dessous. Notez que la catégorie par défaut (non affichée ici) est toujours active.'
L['Debugging::Category::Disable All::Button']          = NONE
L['Debugging::Category::Disable All::Button::Desc']    = 'Décoche toutes les catégories de journalisation ci-dessous. Notez que la catégorie par défaut (non affichée ici) est toujours active.'

L['REQUIRES_RELOAD_PROFILE_CHANGED'] = 'Les modifications d\'addons de votre profil sélectionné nécessitent un rechargement de l\'interface pour prendre effet. Cela activera les addons cochés et désactivera ceux décochés.\n\nRecharger maintenant ?'

L['Prompt me to Reload UI::Desc'] = 'Activez cette option pour recevoir une invite demandant de recharger l\'interface à la fermeture de la fenêtre d\'options, si des modifications nécessitant l\'activation ou la désactivation d\'addons ont été apportées.'
L['Prompt me to Reload UI']       = 'Me demander de recharger l\'interface si nécessaire'

L['Include Addon Changes in Reload Confirmation']       = 'Inclure les modifications d\'addons dans la confirmation de rechargement'
L['Include Addon Changes in Reload Confirmation::Desc'] = 'Activez pour voir la liste des addons qui seront activés ou désactivés dans la boîte de dialogue de confirmation de rechargement.'

L['Confirm Reloads When Switching Profiles']       = 'Confirmer les rechargements lors du changement de profil'
L['Confirm Reloads When Switching Profiles::Desc'] = 'Ce paramètre ajoute une étape de confirmation avant le rechargement de l\'interface lors d\'un changement de profil via un clic gauche sur le menu de la minicarte. Une protection contre les changements accidentels.'

L['Hide']                    = 'Masquer'
L['Hide Minimap Icon']       = 'Masquer l\'icône de la minicarte'
L['Hide Minimap Icon::Desc'] = 'Bascule la visibilité de l\'icône de l\'addon sur la minicarte.'

L['Hide Minimap Icon TitanPanel']       = 'Masquer l\'icône de la minicarte lors de l\'ajout à TitanPanel'
L['Hide Minimap Icon TitanPanel::Desc'] = 'Masque l\'icône de l\'addon sur la minicarte lorsqu\'elle est ajoutée à TitanPanel.'

L['View or switch profiles']      = 'Voir ou changer de profil'
L['Open minimap settings'] = 'Ouvrir les paramètres de la minicarte'
L['View available commands']      = 'Voir les commandes disponibles'
L['Open settings']                = 'Ouvrir les options'
L['Command Lines']                = 'Lignes de commande'
L['Currently set to switch profiles %s a confirmation prompt.'] = 'Le changement de profil se fait actuellement %s.'

L['Add to Favorite']              = 'Ajouter aux favoris'
L['Add to Favorite::Desc']        = "Activez cette option pour afficher le profil actuel dans le menu de changement de profil de la minicarte (clic gauche). Désactivez pour masquer le profil du menu."
L['Minimap']                      = 'Minicarte'
L['Minimap::Desc']                = "Options de la minicarte"

L['Favorite Profiles']            = 'Profils favoris'
L['Favorite Profiles::Desc']      = 'Sélectionnez les profils favoris pour le menu de la minicarte (clic gauche). Ce menu permet de basculer rapidement entre les ensembles d\'addons.'
L['Switch Profile']               = 'Changer de profil'

L['Reloads UI with confirmation']    = 'Recharge l\'interface avec confirmation'
L['Reloads UI without confirmation'] = 'Recharge l\'interface sans confirmation'

L['Select profile to activate'] = 'Sélectionnez ci-dessous un profil à activer'
L['without']                    = 'sans confirmation'
L['with']                       = 'avec confirmation'
L['confirmation']               = 'confirmation'
L['No Confirmation']            = 'Sans confirmation'
L['Profile is out of sync']     = 'Le profil n\'est pas synchronisé et nécessite un rechargement de l\'interface.'
L['Click Key To Sync']          = 'Appuyez sur ALT+clic gauche pour synchroniser et recharger'
L['ALT-LEFT-Click']             = 'ALT+clic gauche'
L['LEFT-Click']                 = 'Clic gauche'
L['RIGHT-Click']                = 'Clic droit'
L['SHIFT-RIGHT-Click']          = 'MAJ+clic droit'

L['Profile Sync Status Indicator']       = 'Indicateur d\'état de synchronisation du profil'
L['Profile Sync Status Indicator::Desc'] = 'Activez cette option pour utiliser un code |cfdE64750couleur|r sur l\'icône de la minicarte, indiquant visuellement si votre profil est synchronisé ou nécessite une mise à jour.'

L['Open debug settings'] = 'Ouvrir les paramètres de débogage'

L['Enabled (After Reload)']  = 'Activé (après rechargement)'
L['Disabled (After Reload)'] = 'Désactivé (après rechargement)'

L['Limit Profile Name Characters']       = 'Limiter les caractères du nom de profil...'
L['Limit Profile Name Characters::Desc'] = 'Définit le nombre maximum de caractères pour l\'affichage du nom de profil à droite de l\'icône de l\'addon dans |cdf6F97FFTitan Panel|r. Si le nom dépasse cette limite, il sera raccourci et se terminera par des points de suspension ("..."). Vous pouvez régler cette valeur entre 5 et 20 caractères.'

L['Show Profile Name']            = 'Afficher le nom du profil'
L['Show Profile Name::Desc']      = 'Activez cette option pour afficher le nom du profil actuel juste à droite de l\'icône dans |cdf6F97FFTitan Panel|r.'
L['Titan Panel Settings']         = 'Paramètres Titan Panel'
L['Show Out of Sync Count']       = 'Afficher le nombre d\'addons désynchronisés'
L['Show Out of Sync Count::Desc'] = 'Activez ce paramètre pour afficher dans |cdf6F97FFTitan Panel|r le nombre d\'addons actuellement désynchronisés par rapport au profil actif.'
L['Lib:']                         = 'Bibl. :'