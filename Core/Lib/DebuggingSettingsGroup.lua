--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat = string.format

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, M = ns.O, ns.M
local dbgSeq = ns:CreateSequence()

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = M.DebuggingSettingsGroup()
--- @class DebuggingSettingsGroup
local S = ns:NewLib(libName)
local p = ns:CreateDefaultLogger(libName)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @type DebuggingSettingsGroup
local o = S

--- spacer
local sp = '                                                                   '
local L = ns:AceLocale()

--- @return AceConfigOption
function o:CreateDebuggingGroup()

    --- @type AceConfigOption
    local debugConf = {
        type = 'group',
        name = L['Debugging'],
        desc = L['Debugging::Desc'],
        -- Place right before Profiles
        order = 101, -- so it is after Profiles

        args = {
            log_level = {
                type = 'range',
                order = dbgSeq:next(),
                step = 5,
                min = 0,
                max = 50,
                width = 1.5,
                name = L['Log Level'],
                desc = L['Log Level::Desc'],
                get = function(_) return ns:GetLogLevel() end,
                set = function(_, v) ns:SetLogLevel(v) end,
            },
            spacer1b = { type="description", name=sp, width="full", order = dbgSeq:next() },
        },
    }

    local a = debugConf.args
    a.off = {
        name = 'off',
        type = "execute", order = dbgSeq:next(), width = 'half',
        desc = "Turn Off Logging",
        func = function()
            a.log_level.set({}, 0)
        end,
    }
    a.info = {
        name = 'info',
        type = "execute", order = dbgSeq:next(), width = 'half',
        desc = "Info Log Level (15)",
        func = function()
            a.log_level.set({}, 15)
        end,
    }
    a.debugBtn = {
        name = 'debug',
        type = "execute", order = dbgSeq:next(), width = 'half',
        desc = "Debug Log Level (20)",
        func = function()
            a.log_level.set({}, 20)
        end,
    }
    a.fineBtn = {
        name = 'fine',
        type = "execute", order = dbgSeq:next(), width = 'half',
        desc = "Fine Log Level (25)",
        func = function()
            a.log_level.set({}, 25)
        end,
    }
    a.finerBtn = {
        name = 'finer',
        type = "execute", order = dbgSeq:next(), width = 'half',
        desc = "Finer Log Level (30)",
        func = function()
            a.log_level.set({}, 30)
        end,
    }
    a.finestBtn = {
        name = 'finest',
        type = "execute", order = dbgSeq:next(), width = 'half',
        desc = "Finest Log Level (35)",
        func = function()
            a.log_level.set({}, 35)
        end,
    }
    a.traceBtn = {
        name = 'trace',
        type = "execute", order = dbgSeq:next(), width = 'half',
        desc = "Trace Log Level (50)",
        func = function()
            a.log_level.set({}, 50)
        end,
    }
    a.desc_cat = { name = ' ' .. L['Categories'] .. ' ', type = "header", order = dbgSeq:next() }
    a.spacer1c = { type="description", name=sp, width="full", order = dbgSeq:next() }

    self:AddCategories(debugConf)
    return debugConf;
end

---@param conf AceConfigOption
function o:AddCategories(conf)

    local lc = ns:LC()
    local desc = {
        [lc.ADDON.name]         = 'Enable AddonSuite logs',
        [lc.API.name]           = 'Enable API logs',
        [lc.DEPENDENCY.name]    = 'Enable dependencies logs (AddOnManager)',
        [lc.MESSAGE_TRACE.name] = 'Enable AceEvent message trace logs.',
        [lc.TRACE.name]         = 'Enable general purpose trace logs.',
    }

    conf.args.enable_all = {
        name = L['Debugging::Category::Enable All::Button'], desc = L['Debugging::Category::Enable All::Button::Desc'],
        type = "execute", order = dbgSeq:next(), width = 'half',
        func = function()
            for _, option in pairs(conf.args) do
                if option.type == 'toggle' then option.set({}, true) end
            end
        end }
    conf.args.spacer1a = { type="description", name='', width=0.1, order = dbgSeq:next() }
    conf.args.disable_all = {
        name = L['Debugging::Category::Disable All::Button'], desc = L['Debugging::Category::Disable All::Button::Desc'],
        type="execute", order=dbgSeq:next(), width = 'half',
        func = function()
            for _, option in pairs(conf.args) do
                if option.type == 'toggle' then option.set({}, false) end
            end
        end }
    conf.args.spacer2 = { type="description", name=sp, width="full", order = dbgSeq:next() },

    ns.CategoryLogger():ForEachCategory(function(cat)
        local elem = {
            type = 'toggle', name=cat.labelFn(), order=dbgSeq:next(), width=1.2,
            get = function() return ns:IsLogCategoryEnabled(cat.name) end,
            set = function(_, val) ns:SetLogCategory(cat.name, val) end
        }
        local descText = desc[cat.name]
        if descText then elem.desc = descText end
        conf.args[cat.name] = elem
    end)
end


