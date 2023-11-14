globals
    // User-defined
    string                  udg_empty_string

    // Generated
    trigger                 gg_trg_Nahkampf_Initialisierung = null
    trigger                 gg_trg_StringHashTest      = null
endglobals

function InitGlobals takes nothing returns nothing
    set udg_empty_string = ""
endfunction

//***************************************************************************
//*
//*  Triggers
//*
//***************************************************************************

function weirdfunction takes integer aaa returns string
	// nothing
	local string str =  "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	
	return "abc"
endfunction

function hexadecimalNumber takes nothing returns nothing
	local integer i = 10
// overly long line
//	
	call DisplayTextToForce( GetPlayersAll(), "Hexafunc" )
endfunction

function RandomStuff takes nothing returns nothing
	call DisplayTextToForce( GetPlayersAll(), "Hello!" )

	call hexadecimalNumber()
endfunction

//===========================================================================
// Trigger: Nahkampf-Initialisierung
//
// Vorgegebene Nahkampf-Spielinitialisierung für alle Spieler
//===========================================================================
function Trig_Nahkampf_Initialisierung_Actions takes nothing returns nothing
    call MeleeStartingVisibility(  )
    call MeleeStartingHeroLimit(  )
    call MeleeGrantHeroItems(  )
    call MeleeStartingResources(  )
    call MeleeClearExcessUnits(  )
    call MeleeStartingUnits(  )
    call MeleeStartingAI(  )
endfunction

//===========================================================================
function InitTrig_Nahkampf_Initialisierung takes nothing returns nothing
    set gg_trg_Nahkampf_Initialisierung = CreateTrigger(  )
    call TriggerAddAction( gg_trg_Nahkampf_Initialisierung, function Trig_Nahkampf_Initialisierung_Actions )
endfunction

//===========================================================================
// Trigger: StringHashTest
//===========================================================================
function Trig_StringHashTest_Actions takes nothing returns nothing
    call DisplayTextToForce( GetPlayersAll(), "Jass Syntax Test" )
    call RandomStuff()

endfunction

//===========================================================================
function InitTrig_StringHashTest takes nothing returns nothing
    set gg_trg_StringHashTest = CreateTrigger(  )
    call TriggerRegisterTimerEventSingle( gg_trg_StringHashTest, 1.00 )
    call TriggerAddAction( gg_trg_StringHashTest, function Trig_StringHashTest_Actions )
endfunction

//===========================================================================
function InitCustomTriggers takes nothing returns nothing
    call InitTrig_Nahkampf_Initialisierung(  )
    call InitTrig_StringHashTest(  )
endfunction

//===========================================================================
function RunInitializationTriggers takes nothing returns nothing
    call ConditionalTriggerExecute( gg_trg_Nahkampf_Initialisierung )
endfunction

//***************************************************************************
//*
//*  Players
//*
//***************************************************************************

function InitCustomPlayerSlots takes nothing returns nothing

    // Player 0
    call SetPlayerStartLocation( Player(0), 0 )
    call SetPlayerColor( Player(0), ConvertPlayerColor(0) )
    call SetPlayerRacePreference( Player(0), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(0), true )
    call SetPlayerController( Player(0), MAP_CONTROL_USER )

endfunction

function InitCustomTeams takes nothing returns nothing
    // Force: TRIGSTR_008
    call SetPlayerTeam( Player(0), 0 )

endfunction

//***************************************************************************
//*
//*  Main Initialization
//*
//***************************************************************************

//===========================================================================
function main takes nothing returns nothing
    call SetCameraBounds( -3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM) )
    call SetDayNightModels( "Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl" )
    call NewSoundEnvironment( "Default" )
    call SetAmbientDaySound( "LordaeronSummerDay" )
    call SetAmbientNightSound( "LordaeronSummerNight" )
    call SetMapMusic( "Music", true, 0 )
    call InitBlizzard(  )
    call InitGlobals(  )
    call InitCustomTriggers(  )
    call RunInitializationTriggers(  )

endfunction

//***************************************************************************
//*
//*  Map Configuration
//*
//***************************************************************************

function config takes nothing returns nothing
    call SetMapName( "TRIGSTR_001" )
    call SetMapDescription( "TRIGSTR_003" )
    call SetPlayers( 1 )
    call SetTeams( 1 )
    call SetGamePlacement( MAP_PLACEMENT_USE_MAP_SETTINGS )

    call DefineStartLocation( 0, 0.0, 192.0 )

    // Player setup
    call InitCustomPlayerSlots(  )
    call SetPlayerSlotAvailable( Player(0), MAP_CONTROL_USER )
    call InitGenericPlayerSlots(  )
endfunction

