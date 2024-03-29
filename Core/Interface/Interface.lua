--[[-----------------------------------------------------------------------------
Callback Functions
-------------------------------------------------------------------------------]]
--- @alias AddOnCallbackFn fun(addOn:AddOnInfo) | "function(addOn) print('addOn:', pformat(addOn)) end"
--- @alias ProfilePredicateFn fun(name:Name, profile:Profile_Config) : boolean
--- @alias ProfileCallbackFn fun(name:Name, profile:Profile_Config) : void

--[[-----------------------------------------------------------------------------
BaseLibraryObject
-------------------------------------------------------------------------------]]
--- @class BaseLibraryObject A base library object class definition.
--- @field mt table The metatable for objects of this class, including a custom `__tostring` function for debugging or logging purposes.
--- @field name string Retrieves the module's name. This is an instance method that should be implemented to return the name of the module.
--- @field major string Retrieves the major version of the module. i.e., <LibName>-1.0
--- @field minor string Retrieves the minor version of the module. i.e., <LibName>-1.0

--[[-----------------------------------------------------------------------------
BaseLibraryObject_WithAceEvent
-------------------------------------------------------------------------------]]
--- @class BaseLibraryObject_WithAceEvent : AceEvent A base library object that includes AceEvent functionality.
--- @field mt table The metatable for objects of this class, including a custom `__tostring` function for debugging or logging purposes.
--- @field name string Retrieves the module's name. This is an instance method that should be implemented to return the name of the module.
--- @field major string Retrieves the major version of the module. i.e., <LibName>-1.0
--- @field minor string Retrieves the minor version of the module. i.e., <LibName>-1.0

--[[-----------------------------------------------------------------------------
AddOn_DB
-------------------------------------------------------------------------------]]
--- @class Profile_DB_ProfileKeys : table<string, string>

--- @class Minimap
--- @field hide boolean

--- @class Profile_Config : AceDB_Profile
--- @field enable boolean This is reserved AceConfig property, don't use.
--- @field showInQuickProfileMenu boolean Enables showing of this profile in the Quick-Switch menu. Defaults to true.
--- @field enabledAddons table<string,boolean> Enabled Addons

--- @class Character_Config
--- @field showInQuickProfileMenu table<string, boolean> A list of enabled addons, key=addonName val=boolean

--- @class Profile_Global_Config : AceDB_Global
--- @field confirm_reloads boolean Enabling "Confirm Reloads" prompts for user confirmation before any UI reload, preventing unintended disruptions.
--- @field minimap Minimap

--- @class AddOn_DB : AceDB
--- @field global Profile_Global_Config
--- @field profile Profile_Config
--- @field char Character_Config
--- @field profileKeys Profile_DB_ProfileKeys
--- @field profiles table<string, Profile_Config>

--[[-----------------------------------------------------------------------------
Type: AddOnInfo
-------------------------------------------------------------------------------]]
--- @class AddOnInfo
--- @field name AddOnName
--- @field title AddOnTitle
--- @field notes Notes
--- @field loadable Boolean
--- @field reason AddOnIsNotLoadableReason
--- @field security AddOnSecurity
--- @field newVersion Boolean Unused
