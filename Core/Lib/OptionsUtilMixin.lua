--[[-----------------------------------------------------------------------------
Type: OptionsUtil
-------------------------------------------------------------------------------]]
--- @class OptionsUtil

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local libName = ns.M.OptionsUtil()

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class OptionsUtilMixin : BaseLibraryObject_WithAceEvent
--- @field optionsMixin OptionsMixin
local S = ns:NewLibWithEvent(libName)
local p = ns:CreateDefaultLogger(libName)

--[[-----------------------------------------------------------------------------
Lib Methods
-------------------------------------------------------------------------------]]
--- @type OptionsUtil | AceEventInterface
local LIB = S

--- @public
--- @param optionsMixin OptionsMixin
--- @return OptionsUtil
function LIB:New(optionsMixin) return ns:K():CreateAndInitFromMixin(S, optionsMixin) end

--[[-----------------------------------------------------------------------------
Instance Methods
-------------------------------------------------------------------------------]]
--- @type OptionsUtil | AceEventInterface
local o = S

--- Called Automatically by CreateAndInitFromMixin
--- @private
--- @param optionsMixin OptionsMixin
function o:Init(optionsMixin)
    self.optionsMixin = optionsMixin
end

--- @see GlobalConstants#M for Message names
--- @param optionalVal any|nil
function o:SendEventMessage(addOnMessage, optionalVal)
    self:SendMessage(addOnMessage, libName, optionalVal)
end

--- @param propKey string
--- @param defVal any
function o:GetGlobalValue(propKey, defVal) return ns:db().global[propKey] or defVal end

--- @param propKey string
--- @param val any
function o:SetGlobalValue(propKey, val) ns:db().global[propKey] = val end

--- @param propKey string
--- @param defVal any
function o:GetValue(propKey, defVal)
    local val = ns:db().profile[propKey]
    if val == nil then val = defVal end
    return val
end

--- @param propKey string
--- @param val any
function o:SetValue(propKey, val) ns:db().profile[propKey] = val end

--- @param propKey string
--- @param defVal any
function o:GetCharacterValue(propKey, defVal)
    local val = ns:db().char[propKey]
    -- print('charVal:', val)
    if val == nil then val = defVal end
    return val
end

--- @param propKey string
--- @param val any
function o:SetCharacterValue(propKey, val) ns:db().char[propKey] = val end

--[[-------------------------------------------------------
Get/Set: Function Handlers
----------------------------------------------------------]]

--- #### Example:
--- `set=this:ProfileGet('configname')`
--- @param fallback any The fallback value
--- @param key string The key value
--- @return function The Profile Get Function
function o:ProfileGet(key, fallback)
    return function(_)
        return self:GetValue(key, fallback)
    end
end

--- #### Example:
--- `set=this:ProfileSet('configName')`
--- @param key string The key value
--- @return function The Profile Set Function
function o:ProfileSet(key, eventMessageToFire)
    return function(_, v)
        self:SetValue(key, v)
        if 'string' == type(eventMessageToFire) then
            self:SendEventMessage(eventMessageToFire, v)
        end
    end
end

--- #### Example:
--- `set=this:ProfileGet('configname')`
--- @param fallback any The fallback value
--- @param key string The key value
--- @return function The Profile Get Function
function o:CharacterGet(key, fallback)
    return function(_)
        return self:GetCharacterValue(key, fallback)
    end
end


--- #### Example:
--- `set=this:ProfileSet('configName')`
--- @param key string The key value
--- @return function The Profile Set Function
function o:CharacterSet(key, eventMessageToFire)
    return function(_, v)
        self:SetCharacterValue(key, v)
        if 'string' == type(eventMessageToFire) then
            self:SendEventMessage(eventMessageToFire, v)
        end
    end
end

--- @return fun(info:any) : any Return the Character showInQuickProfileMenu Get Function
function o:QuickProfileMenuGet()
    return function(_)
        local current = ns:db():GetCurrentProfile()
        local quickProfile = ns:db().char.showInQuickProfileMenu
        return quickProfile[current]
    end
end

--- @return fun(info:any, v:any) The Character showInQuickProfileMenu  Set Function
function o:QuickProfileMenuSet()
    return function(_, v)
        local current = ns:db():GetCurrentProfile()
        local quickProfile = ns:db().char.showInQuickProfileMenu
        quickProfile[current] = v == true
        self:SendEventMessage(ns.GC.M.OnToggleShowInQuickProfileMenu, v)
    end
end

--- @param name string
--- @return fun(info:any) : any Return the Character showInQuickProfileMenu Get Function
function o:ProfileMenuCheckboxGetFn(name)
    assert(name, 'Profile name is missing.')
    return function(_)
        local current = ns:db():GetCurrentProfile()
        local quickProfile = ns:db().char.showInQuickProfileMenu
        -- print(name .. ':', pformat(quickProfile[name]))
        return quickProfile and quickProfile[name] == true
    end
end

--- @param name string
--- @return fun(info:any, v:any) The Character showInQuickProfileMenu  Set Function
function o:ProfileMenuCheckboxSetFn(name)
    assert(name, 'Profile name is missing.')
    return function(_, v)
        local quickProfile = ns:db().char.showInQuickProfileMenu
        -- print('name:', name, 'qp:', pformat(quickProfile))
        quickProfile[name] = v == true
        self:SendEventMessage(ns.GC.M.OnToggleShowInQuickProfileMenu, v)
    end
end

--- #### Example:
--- `set=this:GlobalGet('configName')`
--- @param fallback any The fallback value
--- @param key string The key value
--- @return function The Global Profile Get Function
function o:GlobalGet(key, fallback)
    return function(_)
        return self:GetGlobalValue(key, fallback)
    end
end
--- `set=this:GlobalSet('configName')`
--- @param key string The key value
--- @return function The Global Profile Set Function
function o:GlobalSet(key, eventMessageToFire)
    return function(_, v)
        self:SetGlobalValue(key, v)
        if 'string' == type(eventMessageToFire) then
            self:SendEventMessage(eventMessageToFire, v)
        end
    end
end
