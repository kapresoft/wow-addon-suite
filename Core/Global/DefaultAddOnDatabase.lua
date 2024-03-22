--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @see AceDbInitializerMixin#InitDbDefaults()
--- @type AddOn_DB
local DefaultAddOnDatabase = {
    global = {
        confirm_reloads = true,
        minimap = { hide = false },
    },
    profile = {
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
    },
    --- @type Character_Config
    char = {
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
    },
}
ns.DefaultAddOnDatabase = DefaultAddOnDatabase
