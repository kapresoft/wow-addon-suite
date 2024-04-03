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
local libName = 'EventToMessageRelay'
--- @class EventToMessageRelay
local L = ns:NewLibWithEvent(libName)
local p = ns:CreateDefaultLogger(libName)
local pt = ns:LC().MESSAGE_TRACE:NewLogger(libName)
--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local CreateFrame, FrameUtil = CreateFrame, FrameUtil
local RegisterFrameForEvents, RegisterFrameForUnitEvents = FrameUtil.RegisterFrameForEvents, FrameUtil.RegisterFrameForUnitEvents

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o EventToMessageRelay | AceEvent
local function PropsAndMethods(o)

    function o.OnLoad(frame, event, ...)
        frame:SetScript(E.OnEvent, function(self, evt, ...) L:OnMessageTransmitter(evt, ...) end)
        --- @see GlobalConstants#M (Messages)
        RegisterFrameForEvents(frame, {
            E.PLAYER_ENTERING_WORLD,
        })
    end

    --- @param event string
    function o:OnMessageTransmitter(event, ...)
        pt:t(function() return "Relaying event[%s] to message[%s]", event, GC.toMsg(event) end)
        self:SendMessage(toMsg(event), ns.name, ...)
    end

    ns.EventToMessageRelay_OnLoad = o.OnLoad

end; PropsAndMethods(L)




