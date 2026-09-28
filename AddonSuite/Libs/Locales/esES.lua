--[[-----------------------------------------------------------------------------
Namespace
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)

local L = ns:NewLocale("esES"); if not L then return end

--[[-----------------------------------------------------------------------------
Locale Entries
-------------------------------------------------------------------------------]]

L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG"]                  = 'Ventana de opciones'
L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG_MINIMAP"]          = 'Ventana de opciones: Minimapa'

L['%s version %s by %s is loaded.']        = '%s versión %s de %s se ha cargado.'
L['Type %s or %s for available commands.'] = 'Escribe %s o %s para ver los comandos disponibles.'

L['Current Profile Color']            = ns.locale.profileNameColor
L['Current Profile Color::OutOfSync'] = ns.locale.profileNameColorOutOfSync
L['Current::Symbol::Options']   = ns.locale.greenIndicator
L['Current::Symbol::Minimap']   = ns.locale.checkMark

L['General']                  = 'General'
L['General::Desc']            = "Configuración general"
L['General Configuration']    = 'Configuración general'

L['General::Enable All::Button']           = ALL
L['General::Enable All::Button::Desc']     = 'Activa todos los addons de abajo.'
L['General::Disable All::Button']          = NONE
L['General::Disable All::Button::Desc']    = 'Desactiva todos los addons de abajo.'

L['Add-Ons::Desc']            = 'Para activar o desactivar un addon, marca o desmarca su casilla correspondiente. Después, haz clic en |cdf6F97FFRecargar interfaz|r para aplicar los cambios.'
L['Reload UI']         = 'Recargar interfaz'
L['Reload UI::Desc']   = 'Aplica y recarga inmediatamente |cfdE64750sin confirmación.|r'
L['Sync with Profile and Reload'] = 'Sincronizar con el perfil y recargar'
L['Select Profile']           = 'Seleccionar perfil'
L['Select Profile::Desc']     = 'Selecciona un perfil para activarlo. Se te pedirá recargar la interfaz. Ten en cuenta que estos perfiles se gestionan en la pestaña Perfiles.'

L['Global Setting']           = 'Configuración global'
L['Character Setting']        = 'Configuración del personaje'

L['Debugging']                = 'Depuración'
L['Debugging::Desc']          = 'Ajustes de depuración para solucionar problemas'
L['Debugging Configuration']  = 'Ajustes de depuración'
L['Log Level']                = 'Nivel de registro'
L['Log Level::Desc']          = 'Un nivel de registro más alto genera más entradas:\nNiveles: ERROR(5), WARN(10), INFO(15), DEBUG(20), FINE(25), FINER(30), FINEST(35), TRACE(50)'
L['Categories']               = 'Categorías'
L['Current Profile']          = 'Perfil actual'
L['Debugging::Category::Enable All::Button']           = ALL
L['Debugging::Category::Enable All::Button::Desc']     = 'Activa todas las categorías de registro de abajo. Ten en cuenta que la categoría predeterminada (no mostrada aquí) siempre está activa.'
L['Debugging::Category::Disable All::Button']          = NONE
L['Debugging::Category::Disable All::Button::Desc']    = 'Desactiva todas las categorías de registro de abajo. Ten en cuenta que la categoría predeterminada (no mostrada aquí) siempre está activa.'

L['REQUIRES_RELOAD_PROFILE_CHANGED'] = 'Los cambios de addons de tu perfil seleccionado requieren recargar la interfaz para aplicarse. Esto activará los addons marcados y desactivará los desmarcados.\n\n¿Recargar ahora?'

L['Prompt me to Reload UI::Desc'] = 'Activa esta opción para recibir un aviso preguntando si deseas recargar la interfaz al cerrar la ventana de opciones, si se realizaron cambios que requieren activar o desactivar addons.'
L['Prompt me to Reload UI']       = 'Preguntarme si recargar la interfaz cuando sea necesario'

L['Include Addon Changes in Reload Confirmation']       = 'Incluir cambios de addons en la confirmación de recarga'
L['Include Addon Changes in Reload Confirmation::Desc'] = 'Actívalo para ver la lista de addons que se activarán o desactivarán dentro del cuadro de confirmación de recarga.'

L['Confirm Reloads When Switching Profiles']       = 'Confirmar recargas al cambiar de perfil'
L['Confirm Reloads When Switching Profiles::Desc'] = 'Esta opción añade un paso de confirmación antes de recargar la interfaz al cambiar de perfil mediante clic izquierdo en el menú del minimapa. Es una salvaguarda contra cambios accidentales.'

L['Hide']                    = 'Ocultar'
L['Hide Minimap Icon']       = 'Ocultar icono del minimapa'
L['Hide Minimap Icon::Desc'] = 'Alterna la visibilidad del icono del addon en el minimapa.'

L['Hide Minimap Icon TitanPanel']       = 'Ocultar icono del minimapa al añadirlo a TitanPanel'
L['Hide Minimap Icon TitanPanel::Desc'] = 'Oculta el icono del addon en el minimapa cuando se añade a TitanPanel.'

L['View or switch profiles']      = 'Ver o cambiar de perfil'
L['Open minimap settings'] = 'Abrir ajustes del minimapa'
L['View available commands']      = 'Ver comandos disponibles'
L['Open settings']                = 'Abrir opciones'
L['Command Lines']                = 'Líneas de comandos'
L['Currently set to switch profiles %s a confirmation prompt.'] = 'Actualmente el cambio de perfil se realiza %s.'

L['Add to Favorite']              = 'Añadir a favoritos'
L['Add to Favorite::Desc']        = "Activa esta opción para mostrar el perfil actual en el menú de cambio de perfil del minimapa (clic izquierdo). Desactívala para ocultar el perfil del menú."
L['Minimap']                      = 'Minimapa'
L['Minimap::Desc']                = "Opciones del minimapa"

L['Favorite Profiles']            = 'Perfiles favoritos'
L['Favorite Profiles::Desc']      = 'Selecciona los perfiles favoritos para el menú del minimapa (clic izquierdo). Este menú te permite cambiar rápidamente entre conjuntos de addons.'
L['Switch Profile']               = 'Cambiar perfil'

L['Reloads UI with confirmation']    = 'Recarga la interfaz con confirmación'
L['Reloads UI without confirmation'] = 'Recarga la interfaz sin confirmación'

L['Select profile to activate'] = 'Selecciona abajo un perfil para activarlo'
L['without']                    = 'sin confirmación'
L['with']                       = 'con confirmación'
L['confirmation']               = 'confirmación'
L['No Confirmation']            = 'Sin confirmación'
L['Profile is out of sync']     = 'El perfil no está sincronizado y requiere una recarga de la interfaz.'
L['Click Key To Sync']          = 'Pulsa ALT+clic izquierdo para sincronizar y recargar'
L['ALT-LEFT-Click']             = 'ALT+clic izquierdo'
L['LEFT-Click']                 = 'Clic izquierdo'
L['RIGHT-Click']                = 'Clic derecho'
L['SHIFT-RIGHT-Click']          = 'SHIFT+clic derecho'

L['Profile Sync Status Indicator']       = 'Indicador de estado de sincronización del perfil'
L['Profile Sync Status Indicator::Desc'] = 'Activa esta opción para usar codificación de |cfdE64750color|r en el icono del minimapa, indicando visualmente si tu perfil está sincronizado o necesita actualizarse.'

L['Open debug settings'] = 'Abrir ajustes de depuración'

L['Enabled (After Reload)']  = 'Activado (tras recargar)'
L['Disabled (After Reload)'] = 'Desactivado (tras recargar)'

L['Limit Profile Name Characters']       = 'Limitar caracteres del nombre del perfil...'
L['Limit Profile Name Characters::Desc'] = 'Establece el número máximo de caracteres para mostrar el nombre del perfil a la derecha del icono del addon en |cdf6F97FFTitan Panel|r. Si el nombre supera este límite, se acortará y terminará con puntos suspensivos ("..."). Puedes ajustar este valor entre 5 y 20 caracteres.'

L['Show Profile Name']            = 'Mostrar nombre del perfil'
L['Show Profile Name::Desc']      = 'Activa esta opción para mostrar el nombre del perfil actual justo a la derecha del icono en |cdf6F97FFTitan Panel|r.'
L['Titan Panel Settings']         = 'Ajustes de Titan Panel'
L['Show Out of Sync Count']       = 'Mostrar cantidad de addons desincronizados'
L['Show Out of Sync Count::Desc'] = 'Activa este ajuste para mostrar en |cdf6F97FFTitan Panel|r la cantidad de addons que actualmente no están sincronizados con el perfil activo.'
L['Lib:']                         = 'Bibl.:'
L['Load on demand (loaded)']      = 'Carga bajo demanda (cargado)'
L['Load on demand (not loaded)']  = 'Carga bajo demanda (no cargado)'