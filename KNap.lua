-- WoW passes the addon name (defined in the .toc) and an addon-unique table
-- to every lua script referenced in the .toc. We don't really need the addon
-- name for anything, so we set assign it to a dummy variable and store the
-- addon namespace table.
local _, ns = ...

-- Initialize each module

-- The Debug table is used to store useful functions for displaying information
-- about the addon's elements while developing new features.
ns.Debug = {}

-- The EventHandler table is used to store functions that correspond to the
-- different events the addon's parent frame are subscribed to.
ns.EventHandler = {}

-- The Core table is used to store all of the variables/functions that are used
-- in the core logic for the addon, such as keeping track of the player's group.
ns.Core = {}

-- The Macros table is used to store all of the variables/functions that are
-- used in the macro-specific core logic for the addon.
ns.Macros = {}

-- The Dialogs table is to store the static dialogs used by the addon to specify
-- targets when there are multiple options.
ns.Dialogs = {}

-- The Cmd table is used to store the functions associated with interpreting
-- and responding to slash commands. Everything the addon's frames can achieve
-- will be possible using only slash commands as well.
ns.Cmd = {}

SLASH_KNAP1 = "/knap"

SlashCmdList["KNAP"] = function(str)
	ns.Cmd:RunCommand(str)
end

-- This is our addon's sleep function.
KNAP_wait(delay, func [, param [,param [,...]]])