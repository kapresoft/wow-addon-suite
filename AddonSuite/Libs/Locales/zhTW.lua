--[[-----------------------------------------------------------------------------
Namespace
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)

local L = ns:NewLocale("zhTW"); if not L then return end

--[[-----------------------------------------------------------------------------
Locale Entries
-------------------------------------------------------------------------------]]

L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG"]                  = '選項視窗'
L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG_MINIMAP"]          = '選項視窗：小地圖'

L['%s version %s by %s is loaded.']        = '%s 版本 %s（由 %s 製作）已載入。'
L['Type %s or %s for available commands.'] = '輸入 %s 或 %s 以查看可用指令。'

L['Current Profile Color']            = ns.locale.profileNameColor
L['Current Profile Color::OutOfSync'] = ns.locale.profileNameColorOutOfSync
L['Current::Symbol::Options']   = ns.locale.greenIndicator
L['Current::Symbol::Minimap']   = ns.locale.checkMark

L['General']                  = '一般'
L['General::Desc']            = "一般設定"
L['General Configuration']    = '一般設定'

L['General::Enable All::Button']           = ALL
L['General::Enable All::Button::Desc']     = '勾選下方所有外掛程式。'
L['General::Disable All::Button']          = NONE
L['General::Disable All::Button::Desc']    = '取消勾選下方所有外掛程式。'

L['Add-Ons::Desc']            = '要啟用或停用外掛程式，請勾選或取消勾選對應的核取方塊。選擇完成後，點擊 |cdf6F97FF重新載入介面|r 以套用變更。'
L['Reload UI']         = '重新載入介面'
L['Reload UI::Desc']   = '|cfdE64750無需確認|r，立即套用並重新載入。'
L['Sync with Profile and Reload'] = '與設定檔同步並重新載入'
L['Select Profile']           = '選擇設定檔'
L['Select Profile::Desc']     = '選擇要啟用的設定檔。系統會提示你重新載入介面。請注意，這些設定檔會在「設定檔」分頁中管理。'

L['Global Setting']           = '全域設定'
L['Character Setting']        = '角色設定'

L['Debugging']                = '偵錯'
L['Debugging::Desc']          = '用於疑難排解的偵錯設定'
L['Debugging Configuration']  = '偵錯設定'
L['Log Level']                = '記錄等級'
L['Log Level::Desc']          = '記錄等級越高，產生的記錄越多：\n等級：ERROR(5)、WARN(10)、INFO(15)、DEBUG(20)、FINE(25)、FINER(30)、FINEST(35)、TRACE(50)'
L['Categories']               = '分類'
L['Current Profile']          = '目前設定檔'
L['Debugging::Category::Enable All::Button']           = ALL
L['Debugging::Category::Enable All::Button::Desc']     = '勾選下方所有記錄分類。請注意，預設分類（此處未顯示）一律處於啟用狀態。'
L['Debugging::Category::Disable All::Button']          = NONE
L['Debugging::Category::Disable All::Button::Desc']    = '取消勾選下方所有記錄分類。請注意，預設分類（此處未顯示）一律處於啟用狀態。'

L['REQUIRES_RELOAD_PROFILE_CHANGED'] = '你所選設定檔的外掛程式變更需要重新載入介面才能生效。這將啟用已勾選的外掛程式並停用未勾選的外掛程式。\n\n是否立即重新載入？'

L['Prompt me to Reload UI::Desc'] = '啟用此選項後，如果進行了需要啟用或停用外掛程式的變更，在關閉選項視窗時會提示你是否要重新載入介面。'
L['Prompt me to Reload UI']       = '需要時提示我重新載入介面'

L['Include Addon Changes in Reload Confirmation']       = '在重新載入確認中顯示外掛程式變更'
L['Include Addon Changes in Reload Confirmation::Desc'] = '啟用後，可在重新載入確認對話方塊中看到將被啟用或停用的外掛程式清單。'

L['Confirm Reloads When Switching Profiles']       = '切換設定檔時確認重新載入'
L['Confirm Reloads When Switching Profiles::Desc'] = '啟用此設定後，在小地圖選單中按左鍵切換設定檔時，重新載入介面前會多一個確認步驟，以避免意外操作。'

L['Hide']                    = '隱藏'
L['Hide Minimap Icon']       = '隱藏小地圖圖示'
L['Hide Minimap Icon::Desc'] = '切換外掛程式小地圖圖示的顯示狀態。'

L['Hide Minimap Icon TitanPanel']       = '加入 TitanPanel 時隱藏小地圖圖示'
L['Hide Minimap Icon TitanPanel::Desc'] = '當外掛程式加入 TitanPanel 時，隱藏其小地圖圖示。'

L['View or switch profiles']      = '檢視或切換設定檔'
L['Open minimap settings'] = '開啟小地圖設定'
L['View available commands']      = '檢視可用指令'
L['Open settings']                = '開啟選項'
L['Command Lines']                = '指令列'
L['Currently set to switch profiles %s a confirmation prompt.'] = '目前設定檔切換設定為 %s。'

L['Add to Favorite']              = '加入最愛'
L['Add to Favorite::Desc']        = "啟用此選項後，目前設定檔會顯示在小地圖設定檔切換選單（按左鍵）中。停用則會在選單中隱藏該設定檔。"
L['Minimap']                      = '小地圖'
L['Minimap::Desc']                = "小地圖選項"

L['Favorite Profiles']            = '最愛設定檔'
L['Favorite Profiles::Desc']      = '選擇要顯示在小地圖選單（按左鍵）中的最愛設定檔。此選單可讓你快速切換外掛程式組合。'
L['Switch Profile']               = '切換設定檔'

L['Reloads UI with confirmation']    = '需確認後重新載入介面'
L['Reloads UI without confirmation'] = '無需確認即重新載入介面'

L['Select profile to activate'] = '請在下方選擇要啟用的設定檔'
L['without']                    = '無需確認'
L['with']                       = '需要確認'
L['confirmation']               = '確認'
L['No Confirmation']            = '無需確認'
L['Profile is out of sync']     = '設定檔尚未同步，需要重新載入介面。'
L['Click Key To Sync']          = '按 ALT+左鍵 以同步並重新載入'
L['ALT-LEFT-Click']             = 'ALT+左鍵'
L['LEFT-Click']                 = '左鍵'
L['RIGHT-Click']                = '右鍵'
L['SHIFT-RIGHT-Click']          = 'SHIFT+右鍵'

L['Profile Sync Status Indicator']       = '設定檔同步狀態指示器'
L['Profile Sync Status Indicator::Desc'] = '啟用此選項後，會在小地圖圖示上使用|cfdE64750顏色|r標示，直覺顯示設定檔是否已同步或需要更新。'

L['Open debug settings'] = '開啟偵錯設定'

L['Enabled (After Reload)']  = '已啟用（重新載入後）'
L['Disabled (After Reload)'] = '已停用（重新載入後）'

L['Limit Profile Name Characters']       = '限制設定檔名稱字元數……'
L['Limit Profile Name Characters::Desc'] = '設定在 |cdf6F97FFTitan Panel|r 中外掛程式圖示右側顯示的設定檔名稱最大字元數。若名稱超出此限制，將被截斷並以省略號（「...」）結尾。你可將此值調整為 5 到 20 個字元之間。'

L['Show Profile Name']            = '顯示設定檔名稱'
L['Show Profile Name::Desc']      = '啟用此選項後，會在 |cdf6F97FFTitan Panel|r 中圖示右側顯示目前設定檔的名稱。'
L['Titan Panel Settings']         = 'Titan Panel 設定'
L['Show Out of Sync Count']       = '顯示未同步外掛程式數量'
L['Show Out of Sync Count::Desc'] = '啟用此設定後，會在 |cdf6F97FFTitan Panel|r 中顯示目前與啟用設定檔不同步的外掛程式數量。'
L['Lib:']                         = '函式庫：'
L['Load on demand (loaded)']      = '按需載入（已載入）'
L['Load on demand (not loaded)']  = '按需載入（未載入）'
