// Super Tanks++: Medic Ability
char g_sMedicHealth[ST_MAXTYPES + 1][36];
char g_sMedicHealth2[ST_MAXTYPES + 1][36];
char g_sMedicMaxHealth[ST_MAXTYPES + 1][36];
char g_sMedicMaxHealth2[ST_MAXTYPES + 1][36];
float g_flMedicRange[ST_MAXTYPES + 1];
float g_flMedicRange2[ST_MAXTYPES + 1];
int g_iMedicAbility[ST_MAXTYPES + 1];
int g_iMedicAbility2[ST_MAXTYPES + 1];
int g_iMedicChance[ST_MAXTYPES + 1];
int g_iMedicChance2[ST_MAXTYPES + 1];

void vMedicConfigs(KeyValues keyvalues, int index, bool main)
{
	main ? (g_iMedicAbility[index] = keyvalues.GetNum("Medic Ability/Ability Enabled", 0)) : (g_iMedicAbility2[index] = keyvalues.GetNum("Medic Ability/Ability Enabled", g_iMedicAbility[index]));
	main ? (g_iMedicAbility[index] = iSetCellLimit(g_iMedicAbility[index], 0, 1)) : (g_iMedicAbility2[index] = iSetCellLimit(g_iMedicAbility2[index], 0, 1));
	main ? (g_iMedicChance[index] = keyvalues.GetNum("Medic Ability/Medic Chance", 4)) : (g_iMedicChance2[index] = keyvalues.GetNum("Medic Ability/Medic Chance", g_iMedicChance[index]));
	main ? (g_iMedicChance[index] = iSetCellLimit(g_iMedicChance[index], 1, 9999999999)) : (g_iMedicChance2[index] = iSetCellLimit(g_iMedicChance2[index], 1, 9999999999));
	main ? (keyvalues.GetString("Medic Ability/Medic Health", g_sMedicHealth[index], sizeof(g_sMedicHealth[]), "25,25,25,25,25,25")) : (keyvalues.GetString("Medic Ability/Medic Health", g_sMedicHealth2[index], sizeof(g_sMedicHealth2[]), g_sMedicHealth[index]));
	main ? (keyvalues.GetString("Medic Ability/Medic Max Health", g_sMedicMaxHealth[index], sizeof(g_sMedicMaxHealth[]), "250,50,250,100,325,600")) : (keyvalues.GetString("Medic Ability/Medic Max Health", g_sMedicMaxHealth2[index], sizeof(g_sMedicMaxHealth2[]), g_sMedicMaxHealth[index]));
	main ? (g_flMedicRange[index] = keyvalues.GetFloat("Medic Ability/Medic Range", 500.0)) : (g_flMedicRange2[index] = keyvalues.GetFloat("Medic Ability/Medic Range", g_flMedicRange[index]));
	main ? (g_flMedicRange[index] = flSetFloatLimit(g_flMedicRange[index], 1.0, 9999999999.0)) : (g_flMedicRange2[index] = flSetFloatLimit(g_flMedicRange2[index], 1.0, 9999999999.0));
}

void vMedic(int client, int health, int extrahealth, int maxhealth)
{
	maxhealth = iSetCellLimit(maxhealth, 1, ST_MAXHEALTH);
	int iExtraHealth = (extrahealth > maxhealth) ? maxhealth : extrahealth;
	int iExtraHealth2 = (extrahealth < health) ? 1 : extrahealth;
	int iRealHealth = (extrahealth >= 0) ? iExtraHealth : iExtraHealth2;
	SetEntityHealth(client, iRealHealth);
}

void vMedicDeath(int client)
{
	int iMedicAbility = !g_bTankConfig[g_iTankType[client]] ? g_iMedicAbility[g_iTankType[client]] : g_iMedicAbility2[g_iTankType[client]];
	int iMedicChance = !g_bTankConfig[g_iTankType[client]] ? g_iMedicChance[g_iTankType[client]] : g_iMedicChance2[g_iTankType[client]];
	if (iMedicAbility == 1 && GetRandomInt(1, iMedicChance) == 1)
	{
		float flMedicRange = !g_bTankConfig[g_iTankType[client]] ? g_flMedicRange[g_iTankType[client]] : g_flMedicRange2[g_iTankType[client]];
		float flTankPos[3];
		GetClientAbsOrigin(client, flTankPos);
		for (int iInfected = 1; iInfected <= MaxClients; iInfected++)
		{
			if (bIsSpecialInfected(iInfected))
			{
				float flInfectedPos[3];
				GetClientAbsOrigin(iInfected, flInfectedPos);
				float flDistance = GetVectorDistance(flTankPos, flInfectedPos);
				if (flDistance <= flMedicRange)
				{
					char sHealth[6][6];
					char sMedicHealth[36];
					sMedicHealth = !g_bTankConfig[g_iTankType[client]] ? g_sMedicHealth[g_iTankType[client]] : g_sMedicHealth2[g_iTankType[client]];
					TrimString(sMedicHealth);
					ExplodeString(sMedicHealth, ",", sHealth, sizeof(sHealth), sizeof(sHealth[]));
					char sMaxHealth[6][6];
					char sMedicMaxHealth[36];
					sMedicMaxHealth = !g_bTankConfig[g_iTankType[client]] ? g_sMedicMaxHealth[g_iTankType[client]] : g_sMedicMaxHealth2[g_iTankType[client]];
					TrimString(sMedicMaxHealth);
					ExplodeString(sMedicMaxHealth, ",", sMaxHealth, sizeof(sMaxHealth), sizeof(sMaxHealth[]));
					int iHealth = GetClientHealth(iInfected);
					int iSmokerHealth = (sHealth[0][0] != '\0') ? StringToInt(sHealth[0]) : 25;
					iSmokerHealth = iSetCellLimit(iSmokerHealth, ST_MAX_HEALTH_REDUCTION, ST_MAXHEALTH);
					int iSmokerMaxHealth = (sMaxHealth[0][0] != '\0') ? StringToInt(sMaxHealth[0]) : 250;
					int iBoomerHealth = (sHealth[1][0] != '\0') ? StringToInt(sHealth[1]) : 25;
					iBoomerHealth = iSetCellLimit(iBoomerHealth, ST_MAX_HEALTH_REDUCTION, ST_MAXHEALTH);
					int iBoomerMaxHealth = (sMaxHealth[1][0] != '\0') ? StringToInt(sMaxHealth[1]) : 50;
					int iHunterHealth = (sHealth[2][0] != '\0') ? StringToInt(sHealth[2]) : 25;
					iHunterHealth = iSetCellLimit(iHunterHealth, ST_MAX_HEALTH_REDUCTION, ST_MAXHEALTH);
					int iHunterMaxHealth = (sMaxHealth[2][0] != '\0') ? StringToInt(sMaxHealth[2]) : 250;
					int iSpitterHealth = (sHealth[3][0] != '\0') ? StringToInt(sHealth[3]) : 25;
					iSpitterHealth = iSetCellLimit(iSpitterHealth, ST_MAX_HEALTH_REDUCTION, ST_MAXHEALTH);
					int iSpitterMaxHealth = (sMaxHealth[3][0] != '\0') ? StringToInt(sMaxHealth[3]) : 100;
					int iJockeyHealth = (sHealth[4][0] != '\0') ? StringToInt(sHealth[4]) : 25;
					iJockeyHealth = iSetCellLimit(iJockeyHealth, ST_MAX_HEALTH_REDUCTION, ST_MAXHEALTH);
					int iJockeyMaxHealth = (sMaxHealth[4][0] != '\0') ? StringToInt(sMaxHealth[4]) : 325;
					int iChargerHealth = (sHealth[5][0] != '\0') ? StringToInt(sHealth[5]) : 25;
					iChargerHealth = iSetCellLimit(iChargerHealth, ST_MAX_HEALTH_REDUCTION, ST_MAXHEALTH);
					int iChargerMaxHealth = (sMaxHealth[5][0] != '\0') ? StringToInt(sMaxHealth[5]) : 600;
					if (bIsSmoker(iInfected))
					{
						vMedic(iInfected, iHealth, iHealth + iSmokerHealth, iSmokerMaxHealth);
					}
					else if (bIsBoomer(iInfected))
					{
						vMedic(iInfected, iHealth, iHealth + iBoomerHealth, iBoomerMaxHealth);
					}
					else if (bIsHunter(iInfected))
					{
						vMedic(iInfected, iHealth, iHealth + iHunterHealth, iHunterMaxHealth);
					}
					else if (bIsSpitter(iInfected))
					{
						vMedic(iInfected, iHealth, iHealth + iSpitterHealth, iSpitterMaxHealth);
					}
					else if (bIsJockey(iInfected))
					{
						vMedic(iInfected, iHealth, iHealth + iJockeyHealth, iJockeyMaxHealth);
					}
					else if (bIsCharger(iInfected))
					{
						vMedic(iInfected, iHealth, iHealth + iChargerHealth, iChargerMaxHealth);
					}
				}
			}
		}
	}
}