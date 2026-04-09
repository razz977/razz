Config = {}

Config.Debug = false -- Set to true for testing and debug prints; false for production.
Config.Locale = 'ro' -- Active locale key used for player-facing notifications.
Config.UseOxTarget = true -- Set true to enable ox_target interaction on dispatcher NPC.

Config.Npc = {
    Model = 'U_M_M_RHDTrainStationWorker_01', -- NPC model used for the transport dispatcher.
    Coords = vector4(-183.01, 626.61, 113.09, 68.75), -- NPC location and heading.
    Name = 'Dispecer Transport', -- NPC display name shown to players.
    InteractionDistance = 2.0, -- Maximum interaction distance in meters for npc checks.
    TargetName = 'transport_dispatcher_target', -- Unique ox_target option name for this NPC.
    TargetLabel = 'Ia cursa de transport', -- ox_target interaction label.
    TargetIcon = 'fa-solid fa-cart-flatbed' -- ox_target icon.
}

Config.Blip = {
    Enabled = true, -- Set to true to show NPC and destination blips.
    NpcSprite = 408396114, -- Blip sprite hash used for dispatcher location.
    NpcScale = 0.2, -- Blip scale for dispatcher.
    NpcLabel = 'Transporturi', -- Dispatcher blip label.
    DestinationSprite = 784218150, -- Blip sprite hash used for delivery destination.
    DestinationScale = 0.2, -- Blip scale for destination.
    DestinationLabel = 'Destinatie transport' -- Destination blip label.
}

Config.Wagon = {
    Model = 'WAGON02X', -- Wagon model spawned when transport run starts.
    SpawnForwardOffset = 4.0, -- Forward spawn offset in meters from player position.
    Props = {
        {
            Model = 'p_crate03x', -- Cargo prop model attached to wagon.
            Offset = vector3(0.15, -1.20, 0.65), -- Local position offset on wagon.
            Rotation = vector3(0.0, 0.0, 0.0) -- Local rotation on wagon.
        },
        {
            Model = 'p_crate04x', -- Cargo prop model attached to wagon.
            Offset = vector3(-0.20, -0.85, 0.70), -- Local position offset on wagon.
            Rotation = vector3(0.0, 0.0, 15.0) -- Local rotation on wagon.
        },
        {
            Model = 'p_barrel03x', -- Cargo prop model attached to wagon.
            Offset = vector3(0.35, -0.55, 0.60), -- Local position offset on wagon.
            Rotation = vector3(0.0, 0.0, -8.0) -- Local rotation on wagon.
        }
    }
}

Config.TransportRun = {
    CooldownSeconds = 15, -- Cooldown in seconds between accepted transport runs.
    CompleteDistance = 10.0, -- Distance in meters to complete delivery at destination.
    AllowedJobs = { -- Jobs allowed to accept transport runs.
        ['unemployed'] = true, -- Civilian job allowed for test usage.
        ['vallaw'] = true -- Example additional job allowed.
    },
    Reward = {
        MoneyType = 'cash', -- Reward money type (cash, valbank, rhobank, blkbank, armbank, bloodmoney).
        Min = 18, -- Minimum random payout.
        Max = 35 -- Maximum random payout.
    },
    Destinations = {
        {
            Name = 'Valentine Grajduri', -- Destination display name.
            Coords = vector3(-365.96, 789.42, 115.15) -- Destination world coordinates.
        },
        {
            Name = 'Rhodes Piata', -- Destination display name.
            Coords = vector3(1238.18, -1305.82, 76.86) -- Destination world coordinates.
        },
        {
            Name = 'Blackwater Docuri', -- Destination display name.
            Coords = vector3(-877.44, -1333.58, 43.97) -- Destination world coordinates.
        }
    }
}
