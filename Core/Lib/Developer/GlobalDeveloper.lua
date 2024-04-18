--- @type string
local addon
--- @type Namespace | Kapresoft_Base_Namespace
local ns
addon, ns = ...

--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat = string.format
local c1 = CreateColor(0.9, 0.2, 0.2, 1.0)
local c2 = WHITE_FONT_COLOR

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
local prefix = sformat('{{%s::%s}}:', c1:WrapTextInColorCode(addon), c2:WrapTextInColorCode('GlobalDeveloper'))
local function log(...) print(prefix, ...) end

--[[-----------------------------------------------------------------------------
Main Code
-------------------------------------------------------------------------------]]
local flag = ns.debug.flag
flag.developer = true
log('developer:', ns.debug:IsDeveloper())

