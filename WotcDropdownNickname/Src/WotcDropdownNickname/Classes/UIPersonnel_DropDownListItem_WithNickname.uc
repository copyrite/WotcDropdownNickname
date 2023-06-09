class UIPersonnel_DropDownListItem_WithNickname extends UIPersonnel_DropDownListItem;

simulated function UpdateData()
{
	local XComGameStateHistory History;
	local XComGameState_Unit Unit, PairUnit;
	local string UnitName, UnitStatus, UnitTypeImage;
	local EUIPersonnelType UnitPersonnelType; 
	local EStaffStatus StafferStatus;
	local int StatusState;

	bSizeRealized = false;
	
	History = `XCOMHISTORY;
	Unit = XComGameState_Unit(History.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));
	PairUnit = XComGameState_Unit(History.GetGameStateForObjectID(UnitInfo.PairUnitRef.ObjectID));
	if(Unit != none) //May be none of the slots are being cleared
	{
		StafferStatus = class'X2StrategyGameRulesetDataStructures'.static.GetStafferStatus(UnitInfo, , , StatusState);
		UnitStatus = class'UIUtilities_Text'.static.GetColoredText(class'UIUtilities_Strategy'.default.m_strStaffStatus[StafferStatus], StatusState);
		UnitName = Caps(Unit.GetFullName());
		
		if(Unit.IsSoldier())
		{
			UnitName = Caps(Unit.GetName(eNameType_FullNick));
			UnitPersonnelType = eUIPersonnel_Soldiers;
			if (PairUnit != none && PairUnit.IsSoldier())
			{
				UnitName @= class'UIUtilities_Text'.default.m_strAmpersand @ Caps(PairUnit.GetName(eNameType_FullNick));
				UnitTypeImage = "";
			}
			else
			{
				UnitTypeImage = class'UIUtilities_Image'.static.GetRankIcon(Unit.GetRank(), Unit.GetSoldierClassTemplateName());
			}
		}
		else if(Unit.IsEngineer())
		{
			if(UnitInfo.bGhostUnit) // If the unit is a ghost, replace Eng name with the Ghost name
				UnitName = Caps(Repl(Unit.GetStaffSlot().GetMyTemplate().GhostName, "%UNITNAME", UnitName));
			UnitPersonnelType = eUIPersonnel_Engineers;
			UnitTypeImage = class'UIUtilities_Image'.const.EventQueue_Engineer;
		}
		else if(Unit.IsScientist())
		{
			UnitPersonnelType = eUIPersonnel_Scientists;
			UnitTypeImage = class'UIUtilities_Image'.const.EventQueue_Science;
		}
		else // Passed in an empty ref
		{
			UnitName = class'UIUtilities_Strategy'.default.m_strEmptyStaff;
			UnitStatus = " "; // send a space specifically to clear out this field. 
			UnitPersonnelType = -1;
			UnitTypeImage = "";
		}
	}
	else // Passed in an empty ref
	{
		UnitName = class'UIUtilities_Strategy'.default.m_strEmptyStaff;
		UnitStatus = " "; // send a space specifically to clear out this field. 
		UnitPersonnelType = -1;
		UnitTypeImage = "";
	}

	AS_UpdateData(
		UnitName,
		"0", //string(Unit.GetSkillLevel()),
		UnitStatus,
		UnitPersonnelType,
		UnitTypeImage);
}
