--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)

--[[-----------------------------------------------------------------------------
Type: Minimap
-------------------------------------------------------------------------------]]
--- @class Minimap
--- @field hide boolean
--- @field minimapPos Number Position on the minimap. This is managed by EasyMenu/DataBroker

--[[-----------------------------------------------------------------------------
Type: Profile_Global_Config
-------------------------------------------------------------------------------]]
--- @class Profile_Global_Config : AceDB_Global
--- @field minimap Minimap
local DefaultGlobal = {
    sync_addon_states = false,
    include_addon_changes_in_reload_confirmation = false,
    minimap = {
        hide = false,
        confirm_reloads = true
    },
}

--[[-----------------------------------------------------------------------------
Type: Character_Config
-------------------------------------------------------------------------------]]
--- @class Character_Config
--- @field showInQuickProfileMenu table<string, boolean> A list of enabled addons, key=addonName val=boolean
local DefaultCharacterSettings = {
    showInQuickProfileMenu = {
        ['@city'] = true,
        ['@questing'] = true,
        ['@dev'] = true,
        ['@dev'] = true,
        ['@dev-boxer'] = true,
        ['@dev-mountplus'] = true,
        ['@dev-addontemplate'] = true,
        ['@dev-consumablebar'] = true,
        ['@dev-abp'] = true,
        ['@dev-abp-m6'] = true,
        ['@dev-addonsuite'] = true,
        ['@dev-devsuite'] = true,
    }
}

--[[-----------------------------------------------------------------------------
Type: AceDB_Profile
-------------------------------------------------------------------------------]]
--- @class Profile_Config : AceDB_Profile
--- @field enable boolean This is reserved AceConfig property, don't use.
--- @field showInQuickProfileMenu boolean Enables showing of this profile in the Quick-Switch menu. Defaults to true.
--- @field enabledAddons table<string,boolean> Enabled Addons
local DefaultProfileSettings = {
    enable = true,
    enabledAddons = {
        ['Ace3'] = true,
        ['Auctionator'] = true,
        ['TomTom'] = true,
        ['BagBrother'] = true,
        ['Bagnon'] = true,
        ['Scrap'] = true,
        ["Def's Camera Zoom"] = true,
    }
}

--[[-----------------------------------------------------------------------------
Type: Profile_DB_ProfileKeys
-------------------------------------------------------------------------------]]
--- @class Profile_DB_ProfileKeys : table<string, string>

--[[-----------------------------------------------------------------------------
Type: AddOn_DB (DefaultAddOnDatabase)
-------------------------------------------------------------------------------]]
--- @class AddOn_DB : AceDB
--- @field global Profile_Global_Config
--- @field profile Profile_Config
--- @field char Character_Config
--- @field profileKeys Profile_DB_ProfileKeys
--- @field profiles table<string, Profile_Config>
--- @see AceDbInitializerMixin#InitDbDefaults()
local DefaultAddOnDatabase = {

    global = DefaultGlobal,
    profile = DefaultProfileSettings,
    char = DefaultCharacterSettings,

}
--[[-----------------------------------------------------------------------------
Namespace Var
-------------------------------------------------------------------------------]]
ns.DefaultAddOnDatabase = DefaultAddOnDatabase
