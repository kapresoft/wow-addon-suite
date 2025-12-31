--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local K, O, GC = ns:K(), ns.O, ns.GC
local MSG = GC.M
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'AceConfigDialogUtil'
--- @class AceConfigDialogUtil
local S = {}; ns:AceEvent(S); ns:Register(libName, S)
local p = ns:LC().OPTIONS:NewLogger(libName)

--- @type AceConfigDialog
local ACD       = ns:AceConfigDialog()
local aceBucket = ns:AceBucket()

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
--- @param addonName Name
--- @return Frame
local function GetAceFrame(addonName)
    assert(addonName, "GetAceFrame():: Addon name is required.")
    local openFrames = ACD.OpenFrames
    local aceFrameObj = openFrames and ACD.OpenFrames[addonName]
    return aceFrameObj and aceFrameObj.frame
end

--[[-----------------------------------------------------------------------------
Mixin Methods
-------------------------------------------------------------------------------]]
--- @type AceConfigDialogUtil | AceEvent
local o = S

--- @alias AceConfigHookCallbackFn fun(acd:AceConfigDialog, appName:string, container:Frame, ...) | "function(acd, appName, container, ...) end"
--- Hooks AceConfigDialog lifecycle events for a specific addon.
--- Internally maps Open/Close to the underlying Blizzard frame's OnShow/OnHide.
---
--- @param addonName string The AceConfig app name (must match RegisterOptionsTable name)
--- @param onOpenHandlerFn AceConfigHookCallbackFn Callback invoked when the dialog opens
--- @param onCloseHandlerFn AceConfigHookCallbackFn|nil Callback invoked when the dialog closes
function o:OnOpenAndClose(addonName, onOpenHandlerFn, onCloseHandlerFn)

    local onShowMessage = addonName .. '.OptionsDialogOnShow'
    local onHideMessage = addonName .. '.OptionsDialogOnHide'

    assert(type(addonName) == "string", "OnOpenAndClose:: addonName must be a string")
    assert(type(onOpenHandlerFn) == "function", "OnOpenAndClose:: Open handler must be a function")

    local isHooked = '__aceConfigHooked_' .. addonName

    hooksecurefunc(ACD, 'Open', function(aceConfigDlg, appName)
        local f = GetAceFrame(addonName); if not f or f[isHooked] then return end

        aceBucket:RegisterBucketMessage(onShowMessage, 0.1, function()
            local f1 = GetAceFrame(addonName)
            return f1 and onOpenHandlerFn(onShowMessage, addonName, f)
        end)
        if onCloseHandlerFn then
            aceBucket:RegisterBucketMessage(onHideMessage, 0.1, function()
                return onCloseHandlerFn(onHideMessage, addonName)
            end)
        end

        local onHideHookEnabled
        hooksecurefunc(f, 'Show', function()
            local f1 = GetAceFrame(addonName); if not f1 then return end
            onHideHookEnabled = true
            hooksecurefunc(f, 'Hide', function()
                if onHideHookEnabled then
                    onHideHookEnabled = false
                    S:SendMessage(onHideMessage)
                end
            end)
            S:SendMessage(onShowMessage)
        end)

        f[isHooked] = true
    end)

end


