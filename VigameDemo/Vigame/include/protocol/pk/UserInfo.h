#pragma once

#include "protocol/macros.h"
#include <string>

NS_VIGAME_PROTOCOL_BEGIN

struct UserInfo
{
	std::string userid;   //用户ID（LSN）
	std::string username; //用户名称
	std::string hiscore;  //历史最高分
	std::string hilevel;  //历史关数
	std::string vsrate;   //单挑胜率
	std::string vswins;   //单挑获胜次数
	std::string pkwins;   //全民PK冠军数
	std::string vip;      //VIP等级
	std::string avatar;   //头像
	std::string ticket;   //兑换券（奖券、金豆、红包券）
	std::string coin;     //钻石
	std::string chip;     //筹码、入场费
};

NS_VIGAME_PROTOCOL_END