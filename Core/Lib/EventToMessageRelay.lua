--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local CreateFrame, FrameUtil = CreateFrame, FrameUtil
local RegisterFrameForEvents, UnregisterFrameForEvents = FrameUtil.RegisterFrameForEvents, FrameUtil.UnregisterFrameForEvents

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local GC = ns.GC
local E, toMsg, MSG = GC.E, GC.toMsg, ns.GC.M

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = ns.M.EventToMessageRelay()

--- @class EventToMessageRelay
local S = ns:NewLibWithEvent(libName)
local p = ns:CreateDefaultLogger(libName)
local pt = ns:LC().MESSAGE_TRACE:NewLogger(libName)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @type EventToMessageRelay | AceEventInterface
local o = S

function o.OnLoad(frame, event, ...)
    frame:SetScript(E.OnEvent, function(self, evt, ...) S:OnMessageTransmitter(self, evt, ...) end)
    --- @see GlobalConstants#M (Messages)
    RegisterFrameForEvents(frame, {
        E.PLAYER_ENTERING_WORLD,
    })
end

--- @param event string
function o:OnMessageTransmitter(frame, event, ...)
    pt:t(function() return "Relaying event[%s] to message[%s]", event, GC.toMsg(event) end)
    self:SendMessage(toMsg(event), ns.name, ...)

    -- Unregister one-time events
    local unregisterEvents = { E.PLAYER_ENTERING_WORLD }
    UnregisterFrameForEvents(frame, unregisterEvents)
end

ns.EventToMessageRelay_OnLoad = o.OnLoad
