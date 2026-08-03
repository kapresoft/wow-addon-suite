--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)
local MSG = ns.GC.M
local ACD, aceBucket = ns:AceConfigDialog(), ns:AceBucket()

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'AceConfigDialogUtil'
--- @class AceConfigDialogUtil : AceEvent-3.0
local o = ns:Register(libName, ns:NewAceEvent())
local p, t = ns:log(libName)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
--- @param addonName Name
--- @return Frame
local function GetAceFrame(addonName)
  assert(type(addonName) == 'string', 'GetAceFrame():: Addon name is required.')
  local openFrames = ACD.OpenFrames
  local aceFrameObj = openFrames and ACD.OpenFrames[addonName]
  return aceFrameObj and aceFrameObj.frame
end

--[[-----------------------------------------------------------------------------
Mixin Methods
-------------------------------------------------------------------------------]]

--- @alias AceConfigHookCallbackFn fun(acd:AceConfigDialog-3.0, appName:string, container:Frame, ...) | "function(acd, appName, container, ...) end"

--- Hooks AceConfigDialog lifecycle events for a specific addon.
--- Internally maps Open/Close to the underlying Blizzard frame's OnShow/OnHide.
---
--- @param addonName string The AceConfig app name (must match RegisterOptionsTable name)
--- @param onOpenHandlerFn AceConfigHookCallbackFn Callback invoked when the dialog opens
--- @param onCloseHandlerFn AceConfigHookCallbackFn|nil Callback invoked when the dialog closes
function o:OnOpenAndClose(addonName, onOpenHandlerFn, onCloseHandlerFn)
  local onShowMessage = addonName .. '.OptionsDialogOnShow'
  local onHideMessage = addonName .. '.OptionsDialogOnHide'

  assert(type(addonName) == 'string', 'OnOpenAndClose:: addonName must be a string')
  assert(type(onOpenHandlerFn) == 'function', 'OnOpenAndClose:: Open handler must be a function')

  local isHooked = '__aceConfigHooked_' .. addonName

  hooksecurefunc(ACD, 'Open', function(aceConfigDlg, appName)
    local f = GetAceFrame(addonName); if not f or f[isHooked] then return end

    aceBucket:RegisterBucketMessage(onShowMessage, 0.1, function()
      local f1 = GetAceFrame(addonName)
      return f1 and onOpenHandlerFn(onShowMessage, addonName, f)
    end)
    if onCloseHandlerFn then
      aceBucket:RegisterBucketMessage(
        onHideMessage,
        0.1,
        function() return onCloseHandlerFn(onHideMessage, addonName) end
      )
    end

    local onHideHookEnabled
    hooksecurefunc(f, 'Show', function()
      local f1 = GetAceFrame(addonName); if not f1 then return end
      onHideHookEnabled = true
      hooksecurefunc(f, 'Hide', function()
        if onHideHookEnabled then
          onHideHookEnabled = false
          o:SendMessage(onHideMessage)
        end
      end)
      o:SendMessage(onShowMessage)
    end)

    f[isHooked] = true
  end)
end
