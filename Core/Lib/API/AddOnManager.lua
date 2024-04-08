--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local GetAddOnDependencies = C_AddOns.GetAddOnDependencies or GetAddOnDependencies

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M, L = ns.O, ns.GC, ns.M, ns:AceLocale()

local String = ns:KO().String
local EqualsIgnoreCase = String.EqualsIgnoreCase

local NAME_REQUIRED_MSG = "AddOnManager:New(name):: The addOn [index or name] is required val="
local ADDON_INFO_NOT_FOUND_MSG = "AddOnManager:New(name):: AddOn info not found for [index or name] val="

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'AddOnManager'
--- @class AddOnManager
--- @field missing Boolean
local S = ns:NewLib(libName)
local p = ns:CreateDefaultLogger(libName)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o AddOnManager
local function AddonInfoPropsAndMethods(o)

    local c_dep = ORANGE_FONT_COLOR
    local c_dis = RED_FONT_COLOR
    local c_label = YELLOW_FONT_COLOR

    --- @param indexOrName IndexOrName The AddOn Index or Name
    local function assertIndexOrName(indexOrName)
        assert(type(indexOrName) == 'string' or type(indexOrName) == 'number', NAME_REQUIRED_MSG .. indexOrName)
    end

    --- @public
    --- @param indexOrName IndexOrName The AddOn Index or Name
    --- @return AddOnManager
    function o:New(indexOrName)
        assertIndexOrName(indexOrName)

        local addOnInfo = self.GetAddOnInfo(indexOrName)
        assert(type(addOnInfo) == 'table', ADDON_INFO_NOT_FOUND_MSG .. indexOrName)

        return ns:K():CreateAndInitFromMixin(o, addOnInfo)
    end

    --- @private
    --- @param addOnInfo AddOnInfo
    function o:Init(addOnInfo)
        self.api = O.API

        --- @deprecated addOnInfo
        self.addOnInfo = addOnInfo

        self.name = addOnInfo.name
        self.notes = addOnInfo.notes or ''
        self.loadable = addOnInfo.loadable
        self.reason = addOnInfo.reason or ''

        --self.loadOnDemand = EqualsIgnoreCase(self.reason, 'DEMAND_LOADED')
        self.dependencies = { GetAddOnDependencies(self.name) }
        self.loadOnDemand = self.api:IsAddOnLoadOnDemand(self.name)
        self.dependencyEnabled = self.api:AreAllDependencyEnabled(self.dependencies)
        self.enabled = self.api:IsAddOnEnabled(self.name)
        self.missing = EqualsIgnoreCase(self.reason, 'MISSING')
        self.canBeEnabled = self.api:IsAddOnDisabled(self.name)

    end

    --- @public
    --- @param indexOrName IndexOrName The index from 1 to GetNumAddOns() or The name of the addon (as in TOC/folder filename), case insensitive.
    --- @return AddOnManager
    function o.GetAddOnInfo(indexOrName)
        assertIndexOrName(indexOrName)
        local name, title, notes, loadable, reason, security = GetAddOnInfo(indexOrName)
        local index
        if type(indexOrName) == 'number' then index = indexOrName end

        --- @class AddOnInfo
        --- @field index Index
        --- @field name AddOnName
        --- @field title AddOnTitle
        --- @field notes Notes
        --- @field loadable Boolean
        --- @field reason AddOnIsNotLoadableReason
        --- @field security AddOnSecurity
        --- @field newVersion Boolean Unused
        local info = {
            name = name, title = title, loadable = loadable, notes = notes,
            reason = reason, security = security,
            index = index
        }
        return info
    end

    --- @private
    function o:GetDependenciesLabel()
        if not self:HasDependencies() then return '' end
        local deps = {}
        p:f3(function() return '%s: deps=%s', self.name, self.dependencies end)
        for _, n in ipairs(self.dependencies) do
            p:f3(function() return '%s: enabled-deps[%s]=%s',
                        self.name, n, self.api:IsAddOnEnabled(n) end)
            if self.api:IsAddOnDisabled(n) then
                table.insert(deps, c_dep:WrapTextInColorCode(n))
            else table.insert(deps, n) end
        end

        return c_label:WrapTextInColorCode(ADDON_DEPENDENCIES) .. table.concat(deps, ", ")
    end

    --- @return Name, Description The name and description for the addon
    function o:GetNameAndDesc()
        local name = self.name
        local desc = self.notes
        local label = ''
        local bullets = {}

        label = label .. '\n\n' .. self:GetDependenciesLabel()

        if self.loadOnDemand then table.insert(bullets, ADDON_DEMAND_LOADED) end

        local isChecked = self:IsEnabledInProfile()
        if isChecked and not self.dependencyEnabled then
            name = RED_FONT_COLOR:WrapTextInColorCode(self.name)
            table.insert(bullets, ORANGE_FONT_COLOR:WrapTextInColorCode(ADDON_DEP_DISABLED))
        end

        if #bullets > 0 then
            for _, txt in ipairs(bullets) do label = label .. '\n  • ' .. txt end
        end

        desc = desc .. label
        return name, desc
    end

    function o:HasDependencies() return self.dependencies and #self.dependencies > 0 end
    function o:IsEnabledInProfile() return ns:profile().enabledAddons[self.name] == true end

end; AddonInfoPropsAndMethods(S)
