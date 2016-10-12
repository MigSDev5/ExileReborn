private ["_wrecks","_randWreck","_roadPosition","_position","_wreckVehicle","_invisibleSelections","_randomSmoke","_holder","_holders","_randomSelection","_selection","_item"];

"Generating map wreckages, garbage and objects.." call ExileServer_util_log;

for "_i" from 1 to 300 do 
{
	_wrecks =
	[
		"a3\structures_f\wrecks\wreck_skodovka_f.p3d",
		"a3\structures_f\wrecks\wreck_Car_f.p3d",
		"a3\structures_f\wrecks\Wreck_Ural_F.p3d",
		"a3\structures_f\wrecks\Wreck_Truck_F.p3d",
		"a3\structures_f\wrecks\Wreck_UAZ_F.p3d",
		"a3\structures_f\wrecks\Wreck_BRDM2_F.p3d",
		"a3\structures_f\wrecks\Wreck_Hunter_F.p3d",
		"a3\structures_f\wrecks\Wreck_Offroad_F.p3d",
		"a3\structures_f\wrecks\Wreck_Car2_F.p3d",
		"a3\structures_f\wrecks\Wreck_Car3_F.p3d",
		"a3\structures_f\wrecks\Wreck_Offroad2_F.p3d",
		"a3\structures_f\wrecks\Wreck_Slammer_F_F.p3d",
		"a3\structures_f\wrecks\Wreck_Slammer_hull_F.p3d"
	];

	_randWreck = selectRandom _wrecks;
	_roadPosition = [Event_world_centerPosition,30000] call ExileClient_util_world_findRoadPosition;
	_position = [_roadPosition,10] call ExileClient_util_math_getRandomPositionInCircle;

	_wreckVehicle = createSimpleObject [_randWreck,_position];

	_invisibleSelections = ["zasleh", "zasleh2", "box_nato_grenades_sign_f", "box_nato_ammoord_sign_f", "box_nato_support_sign_f"];
	{
        if ((toLower _x) in _invisibleSelections) then 
        {
            _wreckVehicle hideSelection [_x, true];
        };
    }
    forEach (selectionNames _wreckVehicle);

	_wreckVehicle setDir random 360;
    _wreckVehicle setPosATL [position _wreckVehicle select 0,position _wreckVehicle select 1, 0];
    _wreckVehicle setVectorUp surfaceNormal position _wreckVehicle;

    if (random 1 > 0.8) then
    {	
	    _randomSmoke = "test_EmptyObjectForSmoke" createVehicle _position;  
		_randomSmoke setPosATL (position _wreckVehicle);
	};

	for "_n" from 1 to 2 + floor (random 3) do
	{
		if (random 1 > 0.7) then
		{	

			_holders = ["Box_East_Wps_F","Box_East_WpsSpecial_F","Box_NATO_Support_F","Box_NATO_WpsSpecial_F","Box_NATO_Wps_F","Land_Box_AmmoOld_F"];	
			_holder = createVehicle [(selectRandom _holders),(position _wreckVehicle),[], 10, "NONE"];
			_holder setDir floor (random 360);
			_holder call ExileClient_util_containerCargo_clear;

			for "_j" from 0 to 2 + floor (random 2) do
			{	
				_randomSelection = [1,2,3,4];
				_selection = selectRandom _randomSelection;

				_item = [_selection] call JohnO_fnc_getRandomItems_new;
				[_holder, _item] call ExileClient_util_containerCargo_add;

				if (_selection isEqualTo 2) then
				{	
					_magazines = getArray (configFile >> "CfgWeapons" >> _item >> "magazines");
					_holder addMagazineCargoGlobal [(_magazines select 0), 1 + floor (random 3)];
				};
			};	
		};	
	};	
			
	//_marker = createMarker [ format["HeliCrash%1", diag_tickTime], _position];
	//_marker setMarkerType "hd_dot";	

	uiSleep 0.1;
};

"Finished generating map wreckages,garbage and objects" call ExileServer_util_log;



