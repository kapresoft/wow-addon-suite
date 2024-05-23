--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns      = select(2, ...)

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'CategoryLoggerMixin'
--- @class CategoryLoggerMixin
--- @field LogCategories LogCategories
local S       = {}; ns.O[libName] = S

--[[-----------------------------------------------------------------------------
Type: Log Categories
-------------------------------------------------------------------------------]]
--- @class LogCategories
local LogCategories = {
    --- @type Kapresoft_LogCategory
    DEFAULT = 'DEFAULT',
    --- @type Kapresoft_LogCategory
    ADDON = 'AD',
    --- @type Kapresoft_LogCategory
    API = "AP",
    --- @type Kapresoft_LogCategory
    OPTIONS = "OP",
    --- @type Kapresoft_LogCategory
    EVENT = "EV",
    --- @type Kapresoft_LogCategory
    FRAME = "FR",
    --- @type Kapresoft_LogCategory
    MINIMAP = "MM",
    --- @type Kapresoft_LogCategory
    MESSAGE = "MS",
    --- @type Kapresoft_LogCategory
    MESSAGE_TRACE = "MT",
    --- @type Kapresoft_LogCategory
    SYNC = "SY",
    --- @type Kapresoft_LogCategory
    STATE = "ST",
    --- @type Kapresoft_LogCategory
    TRACE = "TR",
    --- @type Kapresoft_LogCategory
    PROFILE = "PR",
    --- @type Kapresoft_LogCategory
    DB = "DB",
    --- @type Kapresoft_LogCategory
    DEPENDENCY = "DP",
    --- @type Kapresoft_LogCategory
    DEV = "DV",
}

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
--- @param val EnabledInt|boolean|nil
--- @param key string|nil Category name
--- @return table<string, string>
local function __GetCategories(key, val)
    if key then ADDON_SUITE_DEBUG_ENABLED_CATEGORIES[key] = val end
    return ADDON_SUITE_DEBUG_ENABLED_CATEGORIES or {}
end

--- @param key string The category key
--- @return Enabled
local function __IsEnabledCategory(key)
    ADDON_SUITE_DEBUG_ENABLED_CATEGORIES = ADDON_SUITE_DEBUG_ENABLED_CATEGORIES or {}
    return ADDON_SUITE_DEBUG_ENABLED_CATEGORIES[key]
end

--- @param val number|nil Optional log level to set
--- @return number The new log level passed back
local function __GetLogLevel(val)
    if val then ADDON_SUITE_LOG_LEVEL = val end
    return ADDON_SUITE_LOG_LEVEL or 0
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local o = S; do

    --- @param nSpace __Namespace
    function o:Configure(nSpace)
        nSpace.LogCategories = function() return LogCategories end
        local CategoryLogger = nSpace:KO().CategoryMixin:New()
        CategoryLogger:Configure(nSpace.addonLogName, LogCategories, {
            consoleColors = nSpace.consoleColors,
            levelSupplierFn = function() return __GetLogLevel() end,
            enabledCategoriesSupplierFn = function() return __GetCategories() end,
            printerFn = nSpace.print,
            enabled = nSpace:IsDev(),
        })
        nSpace.CategoryLogger = function() return CategoryLogger end
        nSpace:K():Mixin(nSpace, o)
        nSpace.Mixin = nil
    end

    --- @return number
    function o:GetLogLevel() return __GetLogLevel() end
    --- @param level number
    function o:SetLogLevel(level) __GetLogLevel(level) end

    --- @param name string | "'ADDON'" | "'BAG'" | "'BUTTON'" | "'DRAG_AND_DROP'" | "'EVENT'" | "'FRAME'" | "'ITEM'" | "'MESSAGE'" | "'MOUNT'" | "'PET'" | "'PROFILE'" | "'SPELL'"
    --- @param v boolean|number | "1" | "0" | "true" | "false"
    function o:SetLogCategory(name, val)
        assert(name, 'Debug category name is missing.')
        ---@param v boolean|nil
        local function normalizeVal(v) if v == 1 or v == true then return 1 end; return 0 end
        __GetCategories(name, normalizeVal(val))
    end
    --- @return boolean
    function o:IsLogCategoryEnabled(name)
        assert(name, 'Debug category name is missing.')
        local val = __IsEnabledCategory(name)
        return val == 1 or val == true
    end
    --- @return LogCategories
    function o:LC() return self.LogCategories() end
    --- @return Kapresoft_CategoryLoggerMixin
    function o:CreateDefaultLogger(moduleName) return self:LC().DEFAULT:NewLogger(moduleName) end

end;
