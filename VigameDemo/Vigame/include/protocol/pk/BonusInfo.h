#pragma once

#include <string>
#include <vector>
#include <unordered_map>

typedef std::unordered_map<std::string, int> BonusMap;
typedef std::unordered_map<std::string, int> BonusTimesMap;

struct BonusInfo
{
	BonusMap bonusMap;
	BonusTimesMap bonusTimesMap;
	std::string wx;
};
