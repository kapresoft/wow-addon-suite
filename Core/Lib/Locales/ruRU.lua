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
Translator ZamestoTV
-------------------------------------------------------------------------------]]

--[[-----------------------------------------------------------------------------
Namespace
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local addonName = ns.addon

local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "ruRU");

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

L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG"]                  = 'Окно настроек'
L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG_MINIMAP"]          = 'Окно настроек : Миникарта'

L['%s version %s by %s is loaded.']        = '%s версия %s от %s загружен.'
L['Type %s or %s for available commands.'] = 'Введите %s или %s для списка команд.'

L['Current Profile Color']            = ns.locale.profileNameColor
L['Current Profile Color::OutOfSync'] = ns.locale.profileNameColorOutOfSync
L['Current::Symbol::Options']   = ns.locale.greenIndicator
L['Current::Symbol::Minimap']   = ns.locale.checkMark

L['General']                  = 'Общие'
L['General::Desc']            = "Общие настройки"
L['General Configuration']    = 'Общие настройки'

L['General::Enable All::Button']           = 'Все'
L['General::Enable All::Button::Desc']     = 'Отметить все аддоны ниже.'
L['General::Disable All::Button']          = 'Ничего'
L['General::Disable All::Button::Desc']    = 'Снять отметку со всех аддонов ниже.'

L['Add-Ons::Desc']            = 'Чтобы включить или выключить аддон, отметьте или снимите галочку напротив него. После выбора нажмите |cdf6F97FFПерезагрузить|r, чтобы изменения вступили в силу.'
L['Reload UI']         = 'Перезагрузить интерфейс'
L['Reload UI::Desc']   = 'Применить и перезагрузить немедленно |cfdE64750без подтверждения.|r'
L['Sync with Profile and Reload'] = 'Синхронизировать с профилем и перезагрузить'
L['Select Profile']           = 'Выбрать профиль'
L['Select Profile::Desc']     = 'Выберите профиль для активации. Вам будет предложено перезагрузить интерфейс. Обратите внимание, что профили управляются на вкладке «Профили».'

L['Global Setting']           = 'Глобальная настройка'
L['Character Setting']        = 'Настройка персонажа'

L['Debugging']                = 'Отладка'
L['Debugging::Desc']          = 'Настройки отладки для устранения неполадок'
L['Debugging Configuration']  = 'Настройки отладки'
L['Log Level']                = 'Уровень логов'
L['Log Level::Desc']          = 'Более высокий уровень логов создаёт больше записей:\nУровни: ERROR(5), WARN(10), INFO(15), DEBUG(20), FINE(25), FINER(30), FINEST(35), TRACE(50)'
L['Categories']               = 'Категории'
L['Current Profile']          = 'Текущий профиль'
L['Debugging::Category::Enable All::Button']           = 'Все'
L['Debugging::Category::Enable All::Button::Desc']     = 'Отметить все категории логов ниже. Обратите внимание, что категория по умолчанию (не показана здесь) всегда активна.'
L['Debugging::Category::Disable All::Button']          = 'Ничего'
L['Debugging::Category::Disable All::Button::Desc']    = 'Снять отметку со всех категорий логов ниже. Обратите внимание, что категория по умолчанию (не показана здесь) всегда активна.'

L['REQUIRES_RELOAD_PROFILE_CHANGED'] = 'Изменения выбранного профиля требуют пере”перезагрузки интерфейса. Это включит отмеченные аддоны и отключит снятые.\n\nПерезагрузить сейчас?'

L['Prompt me to Reload UI::Desc'] = 'Включите эту опцию, чтобы получать запрос на перезагрузку интерфейса при закрытии окна настроек, если были внесены изменения, требующие включения/отключения аддонов.'
L['Prompt me to Reload UI']       = 'Спрашивать о перезагрузке при необходимости'

L['Include Addon Changes in Reload Confirmation']       = 'Показывать изменения аддонов в окне подтверждения перезагрузки'
L['Include Addon Changes in Reload Confirmation::Desc'] = 'Включите, чтобы видеть список аддонов, которые будут включены или отключены, в окне подтверждения перезагрузки.'

L['Confirm Reloads When Switching Profiles']       = 'Подтверждать перезагрузку при смене профиля'
L['Confirm Reloads When Switching Profiles::Desc'] = 'Эта настройка добавляет шаг подтверждения перед перезагрузкой интерфейса при смене профиля через левый клик по меню миникарты. Защита от случайных действий.'

L['Hide']                    = 'Скрыть'
L['Hide Minimap Icon']       = 'Скрыть иконку у миникарты'
L['Hide Minimap Icon::Desc'] = 'Показывать/скрывать иконку аддона у миникарты.'

L['Hide Minimap Icon TitanPanel']       = 'Скрывать иконку миникарты при добавлении в TitanPanel'
L['Hide Minimap Icon TitanPanel::Desc'] = 'Скрывать иконку аддона у миникарты, когда она добавлена в TitanPanel.'

L['View or switch profiles']      = 'Просмотр или смена профилей'
L['Open minimap settings'] = 'Открыть настройки миникарты'
L['View available commands']      = 'Просмотр доступных команд'
L['Open settings']                = 'Открыть настройки'
L['Command Lines']                = 'Командные строки'
L['Currently set to switch profiles %s a confirmation prompt.'] = 'Сейчас смена профилей происходит %s подтверждения.'

L['Add to Favorite']              = 'Добавить в избранное'
L['Add to Favorite::Desc']        = "Включите, чтобы текущий профиль отображался в меню смены профилей миникарты (левый клик). Отключите, чтобы скрыть профиль из меню."
L['Minimap']                      = 'Миникарта'
L['Minimap::Desc']                = "Настройки миникарты"

L['Favorite Profiles']            = 'Избранные профили'
L['Favorite Profiles::Desc']      = 'Выберите избранные профили для меню миникарты (левый клик). Это меню позволяет быстро переключаться между наборами аддонов.'
L['Switch Profile']               = 'Сменить профиль'

L['Reloads UI with confirmation']    = 'Перезагружает интерфейс с подтверждением'
L['Reloads UI without confirmation'] = 'Перезагружает интерфейс без подтверждения'

L['Select profile to activate'] = 'Выберите профиль для активации'
L['without']                    = 'без'
L['with']                       = 'с'
L['confirmation']               = 'подтверждения'
L['No Confirmation']            = 'Без подтверждения'
L['Profile is out of sync']     = 'Профиль не синхронизирован, требуется перезагрузка.'
L['Click Key To Sync']          = 'Нажмите ALT+ЛКМ для синхронизации и перезагрузки'
L['ALT-LEFT-Click']             = 'ALT+ЛКМ'
L['LEFT-Click']                 = 'ЛКМ'
L['RIGHT-Click']                = 'ПКМ'
L['SHIFT-RIGHT-Click']          = 'SHIFT+ПКМ'

L['Profile Sync Status Indicator']       = 'Индикатор состояния синхронизации профиля'
L['Profile Sync Status Indicator::Desc'] = 'Включите, чтобы использовать |cfdE64750цветовую|r индикацию на иконке миникарты, показывающую, синхронизирован ли профиль или требует обновления.'

L['Open debug settings'] = 'Открыть настройки отладки'

L['Enabled (After Reload)']  = 'Включён (после перезагрузки)'
L['Disabled (After Reload)'] = 'Отключён (после перезагрузки)'

L['Limit Profile Name Characters']       = 'Ограничить длину имени профиля...'
L['Limit Profile Name Characters::Desc'] = 'Установите максимальное количество символов для отображения имени профиля справа от иконки в |cdf6F97FFTitan Panel|r. Если имя длиннее, оно будет обрезано и завершится многоточием («...»)). Диапазон: 5–20 символов.'

L['Show Profile Name']            = 'Показывать имя профиля'
L['Show Profile Name::Desc']      = 'Включите, чтобы имя текущего профиля отображалось справа от иконки в |cdf6F97FFTitan Panel|r.'
L['Titan Panel Settings']         = 'Настройки Titan Panel'
L['Show Out of Sync Count']       = 'Показывать количество рассинхронизированных аддонов'
L['Show Out of Sync Count::Desc'] = 'Включите, чтобы в |cdf6F97FFTitan Panel|r отображалось количество аддонов, которые сейчас не синхронизированы с активным профилем.'
L['Lib:']                         = 'Библ.:'
