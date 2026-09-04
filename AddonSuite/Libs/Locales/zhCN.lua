--[[-----------------------------------------------------------------------------
Namespace
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)

local L = ns:NewLocale("zhCN"); if not L then return end

--[[-----------------------------------------------------------------------------
Locale Entries
-------------------------------------------------------------------------------]]

L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG"]                  = '选项窗口'
L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG_MINIMAP"]          = '选项窗口：小地图'

L['%s version %s by %s is loaded.']        = '%s 版本 %s（由 %s 制作）已加载。'
L['Type %s or %s for available commands.'] = '输入 %s 或 %s 查看可用命令。'

L['Current Profile Color']            = ns.locale.profileNameColor
L['Current Profile Color::OutOfSync'] = ns.locale.profileNameColorOutOfSync
L['Current::Symbol::Options']   = ns.locale.greenIndicator
L['Current::Symbol::Minimap']   = ns.locale.checkMark

L['General']                  = '常规'
L['General::Desc']            = "常规设置"
L['General Configuration']    = '常规设置'

L['General::Enable All::Button']           = ALL
L['General::Enable All::Button::Desc']     = '勾选下方所有插件。'
L['General::Disable All::Button']          = NONE
L['General::Disable All::Button::Desc']    = '取消勾选下方所有插件。'

L['Add-Ons::Desc']            = '要启用或禁用插件，请勾选或取消勾选对应的复选框。选择完成后，点击 |cdf6F97FF重新加载界面|r 以应用更改。'
L['Reload UI']         = '重新加载界面'
L['Reload UI::Desc']   = '|cfdE64750无需确认|r，立即应用并重新加载。'
L['Sync with Profile and Reload'] = '与配置文件同步并重新加载'
L['Select Profile']           = '选择配置文件'
L['Select Profile::Desc']     = '选择要激活的配置文件。系统会提示你重新加载界面。请注意，这些配置文件在“配置文件”选项卡中管理。'

L['Global Setting']           = '全局设置'
L['Character Setting']        = '角色设置'

L['Debugging']                = '调试'
L['Debugging::Desc']          = '用于排查问题的调试设置'
L['Debugging Configuration']  = '调试设置'
L['Log Level']                = '日志级别'
L['Log Level::Desc']          = '日志级别越高，生成的日志越多：\n级别：ERROR(5)、WARN(10)、INFO(15)、DEBUG(20)、FINE(25)、FINER(30)、FINEST(35)、TRACE(50)'
L['Categories']               = '类别'
L['Current Profile']          = '当前配置文件'
L['Debugging::Category::Enable All::Button']           = ALL
L['Debugging::Category::Enable All::Button::Desc']     = '勾选下方所有日志类别。请注意，默认类别（此处未显示）始终处于启用状态。'
L['Debugging::Category::Disable All::Button']          = NONE
L['Debugging::Category::Disable All::Button::Desc']    = '取消勾选下方所有日志类别。请注意，默认类别（此处未显示）始终处于启用状态。'

L['REQUIRES_RELOAD_PROFILE_CHANGED'] = '你所选配置文件的插件更改需要重新加载界面才能生效。这将启用已勾选的插件并禁用未勾选的插件。\n\n是否立即重新加载？'

L['Prompt me to Reload UI::Desc'] = '启用此选项后，如果进行了需要启用或禁用插件的更改，在关闭选项窗口时会提示你是否重新加载界面。'
L['Prompt me to Reload UI']       = '需要时提示我重新加载界面'

L['Include Addon Changes in Reload Confirmation']       = '在重新加载确认中显示插件更改'
L['Include Addon Changes in Reload Confirmation::Desc'] = '启用后，可在重新加载确认对话框中看到将被启用或禁用的插件列表。'

L['Confirm Reloads When Switching Profiles']       = '切换配置文件时确认重新加载'
L['Confirm Reloads When Switching Profiles::Desc'] = '启用此设置后，在小地图菜单中左键单击切换配置文件时，重新加载界面前会增加一个确认步骤，以防止意外操作。'

L['Hide']                    = '隐藏'
L['Hide Minimap Icon']       = '隐藏小地图图标'
L['Hide Minimap Icon::Desc'] = '切换插件小地图图标的可见性。'

L['Hide Minimap Icon TitanPanel']       = '添加到 TitanPanel 时隐藏小地图图标'
L['Hide Minimap Icon TitanPanel::Desc'] = '当插件被添加到 TitanPanel 时，隐藏其小地图图标。'

L['View or switch profiles']      = '查看或切换配置文件'
L['Open minimap settings'] = '打开小地图设置'
L['View available commands']      = '查看可用命令'
L['Open settings']                = '打开选项'
L['Command Lines']                = '命令行'
L['Currently set to switch profiles %s a confirmation prompt.'] = '当前配置文件切换设置为 %s。'

L['Add to Favorite']              = '添加到收藏'
L['Add to Favorite::Desc']        = "启用此选项后，当前配置文件将显示在小地图配置文件切换菜单（左键单击）中。禁用则会在菜单中隐藏该配置文件。"
L['Minimap']                      = '小地图'
L['Minimap::Desc']                = "小地图选项"

L['Favorite Profiles']            = '收藏的配置文件'
L['Favorite Profiles::Desc']      = '选择要显示在小地图菜单（左键单击）中的收藏配置文件。此菜单可让你快速切换插件组合。'
L['Switch Profile']               = '切换配置文件'

L['Reloads UI with confirmation']    = '需要确认后重新加载界面'
L['Reloads UI without confirmation'] = '无需确认即重新加载界面'

L['Select profile to activate'] = '在下方选择要激活的配置文件'
L['without']                    = '无需确认'
L['with']                       = '需要确认'
L['confirmation']               = '确认'
L['No Confirmation']            = '无需确认'
L['Profile is out of sync']     = '配置文件未同步，需要重新加载界面。'
L['Click Key To Sync']          = '按 ALT+左键 以同步并重新加载'
L['ALT-LEFT-Click']             = 'ALT+左键'
L['LEFT-Click']                 = '左键'
L['RIGHT-Click']                = '右键'
L['SHIFT-RIGHT-Click']          = 'SHIFT+右键'

L['Profile Sync Status Indicator']       = '配置文件同步状态指示器'
L['Profile Sync Status Indicator::Desc'] = '启用此选项后，会在小地图图标上使用|cfdE64750颜色|r标识，直观显示配置文件是否已同步或需要更新。'

L['Open debug settings'] = '打开调试设置'

L['Enabled (After Reload)']  = '已启用（重新加载后）'
L['Disabled (After Reload)'] = '已禁用（重新加载后）'

L['Limit Profile Name Characters']       = '限制配置文件名称字符数……'
L['Limit Profile Name Characters::Desc'] = '设置在 |cdf6F97FFTitan Panel|r 中插件图标右侧显示的配置文件名称的最大字符数。若名称超出此限制，将被截断并以省略号（“...”）结尾。你可以将此值调整为 5 到 20 个字符之间。'

L['Show Profile Name']            = '显示配置文件名称'
L['Show Profile Name::Desc']      = '启用此选项后，会在 |cdf6F97FFTitan Panel|r 中图标右侧显示当前配置文件的名称。'
L['Titan Panel Settings']         = 'Titan Panel 设置'
L['Show Out of Sync Count']       = '显示未同步插件数量'
L['Show Out of Sync Count::Desc'] = '启用此设置后，会在 |cdf6F97FFTitan Panel|r 中显示当前与激活配置文件不同步的插件数量。'
L['Lib:']                         = '库：'
