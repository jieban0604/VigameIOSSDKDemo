#pragma once

#include "UserInfo.h"
#include <string>
#include <vector>
#include <unordered_map>

NS_VIGAME_PROTOCOL_BEGIN


typedef std::vector<UserInfo> UserInfoList;

struct PKUserList
{
public:
	std::string online;
	std::string date;
	UserInfoList users;
};

struct PKInfo
{
	std::string pkRank;//玩家的排名
	std::string preRank;//上个结算周期的排名

	PKUserList vsUserList;  //VS对战列表
	PKUserList pkUserList;  //全民PK列表
	PKUserList topUserList; //排行榜
};

typedef std::unordered_map<std::string, int> BonusMap;

struct PKRankResult
{
	std::string area;   //场次id
	std::string rank;   //用户此时在area中的排名
	BonusMap bonusMap;  //奖励的内容（“,”为分隔符，分隔键值对）
};


NS_VIGAME_PROTOCOL_END
