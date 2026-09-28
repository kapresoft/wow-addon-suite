--[[-----------------------------------------------------------------------------
Namespace
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)

local L = ns:NewLocale("koKR"); if not L then return end

--[[-----------------------------------------------------------------------------
Locale Entries
-------------------------------------------------------------------------------]]

L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG"]                  = '설정 창'
L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG_MINIMAP"]          = '설정 창 : 미니맵'

L['%s version %s by %s is loaded.']        = '%s 버전 %s (%s 제작)이(가) 로드되었습니다.'
L['Type %s or %s for available commands.'] = '사용 가능한 명령어를 보려면 %s 또는 %s 를 입력하세요.'

L['Current Profile Color']            = ns.locale.profileNameColor
L['Current Profile Color::OutOfSync'] = ns.locale.profileNameColorOutOfSync
L['Current::Symbol::Options']   = ns.locale.greenIndicator
L['Current::Symbol::Minimap']   = ns.locale.checkMark

L['General']                  = '일반'
L['General::Desc']            = "일반 설정"
L['General Configuration']    = '일반 설정'

L['General::Enable All::Button']           = ALL
L['General::Enable All::Button::Desc']     = '아래의 모든 애드온을 체크합니다.'
L['General::Disable All::Button']          = NONE
L['General::Disable All::Button::Desc']    = '아래의 모든 애드온 체크를 해제합니다.'

L['Add-Ons::Desc']            = '애드온을 활성화하거나 비활성화하려면 해당 확인란을 선택하거나 해제하세요. 선택 후 |cdf6F97FFUI 새로고침|r을 클릭하면 변경 사항이 적용됩니다.'
L['Reload UI']         = 'UI 새로고침'
L['Reload UI::Desc']   = '|cfdE64750확인 없이|r 즉시 적용하고 새로고침합니다.'
L['Sync with Profile and Reload'] = '프로필과 동기화 후 새로고침'
L['Select Profile']           = '프로필 선택'
L['Select Profile::Desc']     = '활성화할 프로필을 선택하세요. UI를 새로고침하라는 메시지가 표시됩니다. 이 프로필들은 프로필 탭에서 관리됩니다.'

L['Global Setting']           = '전역 설정'
L['Character Setting']        = '캐릭터 설정'

L['Debugging']                = '디버깅'
L['Debugging::Desc']          = '문제 해결을 위한 디버그 설정'
L['Debugging Configuration']  = '디버그 설정'
L['Log Level']                = '로그 레벨'
L['Log Level::Desc']          = '로그 레벨이 높을수록 더 많은 항목이 생성됩니다:\n레벨: ERROR(5), WARN(10), INFO(15), DEBUG(20), FINE(25), FINER(30), FINEST(35), TRACE(50)'
L['Categories']               = '카테고리'
L['Current Profile']          = '현재 프로필'
L['Debugging::Category::Enable All::Button']           = ALL
L['Debugging::Category::Enable All::Button::Desc']     = '아래의 모든 로그 카테고리를 체크합니다. 기본 카테고리(여기에는 표시되지 않음)는 항상 활성화되어 있습니다.'
L['Debugging::Category::Disable All::Button']          = NONE
L['Debugging::Category::Disable All::Button::Desc']    = '아래의 모든 로그 카테고리 체크를 해제합니다. 기본 카테고리(여기에는 표시되지 않음)는 항상 활성화되어 있습니다.'

L['REQUIRES_RELOAD_PROFILE_CHANGED'] = '선택한 프로필의 애드온 변경 사항을 적용하려면 UI 새로고침이 필요합니다. 이 작업은 체크된 애드온을 활성화하고 체크 해제된 애드온을 비활성화합니다.\n\n지금 새로고침하시겠습니까?'

L['Prompt me to Reload UI::Desc'] = '애드온을 활성화 또는 비활성화하는 변경 사항이 있을 경우, 설정 창을 닫을 때 UI 새로고침 여부를 묻는 메시지를 받으려면 이 옵션을 활성화하세요.'
L['Prompt me to Reload UI']       = '필요할 때 UI 새로고침 여부 묻기'

L['Include Addon Changes in Reload Confirmation']       = '새로고침 확인 창에 애드온 변경 사항 포함'
L['Include Addon Changes in Reload Confirmation::Desc'] = '새로고침 확인 대화 상자에서 활성화 또는 비활성화될 애드온 목록을 보려면 활성화하세요.'

L['Confirm Reloads When Switching Profiles']       = '프로필 전환 시 새로고침 확인'
L['Confirm Reloads When Switching Profiles::Desc'] = '이 설정은 미니맵 메뉴에서 좌클릭으로 프로필을 전환할 때 UI가 새로고침되기 전에 확인 단계를 추가합니다. 실수로 인한 변경을 방지하기 위한 보호 장치입니다.'

L['Hide']                    = '숨기기'
L['Hide Minimap Icon']       = '미니맵 아이콘 숨기기'
L['Hide Minimap Icon::Desc'] = '미니맵에 표시되는 애드온 아이콘의 표시 여부를 전환합니다.'

L['Hide Minimap Icon TitanPanel']       = 'TitanPanel에 추가 시 미니맵 아이콘 숨기기'
L['Hide Minimap Icon TitanPanel::Desc'] = 'TitanPanel에 추가되었을 때 미니맵에 표시되는 애드온 아이콘을 숨깁니다.'

L['View or switch profiles']      = '프로필 보기 또는 전환'
L['Open minimap settings'] = '미니맵 설정 열기'
L['View available commands']      = '사용 가능한 명령어 보기'
L['Open settings']                = '설정 열기'
L['Command Lines']                = '명령줄'
L['Currently set to switch profiles %s a confirmation prompt.'] = '현재 프로필 전환은 %s로 설정되어 있습니다.'

L['Add to Favorite']              = '즐겨찾기에 추가'
L['Add to Favorite::Desc']        = "이 옵션을 활성화하면 좌클릭으로 여는 미니맵 프로필 전환 메뉴에 현재 프로필이 표시됩니다. 비활성화하면 메뉴에서 프로필이 숨겨집니다."
L['Minimap']                      = '미니맵'
L['Minimap::Desc']                = "미니맵 옵션"

L['Favorite Profiles']            = '즐겨찾는 프로필'
L['Favorite Profiles::Desc']      = '좌클릭으로 여는 미니맵 메뉴에 표시할 즐겨찾는 프로필을 선택하세요. 이 메뉴를 통해 애드온 세트 간에 빠르게 전환할 수 있습니다.'
L['Switch Profile']               = '프로필 전환'

L['Reloads UI with confirmation']    = '확인 후 UI 새로고침'
L['Reloads UI without confirmation'] = '확인 없이 UI 새로고침'

L['Select profile to activate'] = '아래에서 활성화할 프로필을 선택하세요'
L['without']                    = '확인 없이'
L['with']                       = '확인 후'
L['confirmation']               = '확인'
L['No Confirmation']            = '확인 없음'
L['Profile is out of sync']     = '프로필이 동기화되지 않았으며 UI 새로고침이 필요합니다.'
L['Click Key To Sync']          = 'ALT+좌클릭을 눌러 동기화 후 새로고침하세요'
L['ALT-LEFT-Click']             = 'ALT+좌클릭'
L['LEFT-Click']                 = '좌클릭'
L['RIGHT-Click']                = '우클릭'
L['SHIFT-RIGHT-Click']          = 'SHIFT+우클릭'

L['Profile Sync Status Indicator']       = '프로필 동기화 상태 표시기'
L['Profile Sync Status Indicator::Desc'] = '이 옵션을 활성화하면 미니맵 아이콘에 |cfdE64750색상|r 코드를 사용하여 프로필이 동기화되었는지 또는 업데이트가 필요한지를 시각적으로 표시합니다.'

L['Open debug settings'] = '디버그 설정 열기'

L['Enabled (After Reload)']  = '활성화됨 (새로고침 후)'
L['Disabled (After Reload)'] = '비활성화됨 (새로고침 후)'

L['Limit Profile Name Characters']       = '프로필 이름 글자 수 제한...'
L['Limit Profile Name Characters::Desc'] = '|cdf6F97FFTitan Panel|r에서 애드온 아이콘 오른쪽에 표시되는 프로필 이름의 최대 글자 수를 설정합니다. 이름이 이 한도를 초과하면 줄임표("...")로 줄여서 표시됩니다. 5자에서 20자 사이로 조정할 수 있습니다.'

L['Show Profile Name']            = '프로필 이름 표시'
L['Show Profile Name::Desc']      = '이 옵션을 활성화하면 |cdf6F97FFTitan Panel|r의 아이콘 바로 오른쪽에 현재 프로필 이름이 표시됩니다.'
L['Titan Panel Settings']         = 'Titan Panel 설정'
L['Show Out of Sync Count']       = '동기화되지 않은 애드온 수 표시'
L['Show Out of Sync Count::Desc'] = '이 설정을 활성화하면 |cdf6F97FFTitan Panel|r에 현재 활성 프로필과 동기화되지 않은 애드온 수가 표시됩니다.'
L['Lib:']                         = '라이브러리:'
L['Load on demand (loaded)']      = '필요 시 로드 (로드됨)'
L['Load on demand (not loaded)']  = '필요 시 로드 (로드되지 않음)'
