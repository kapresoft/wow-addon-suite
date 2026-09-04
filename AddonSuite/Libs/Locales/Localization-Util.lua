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
--- @type ADS_Namespace
local ns = select(2, ...)

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
