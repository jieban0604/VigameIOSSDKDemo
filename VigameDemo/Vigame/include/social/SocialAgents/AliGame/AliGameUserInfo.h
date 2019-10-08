#pragma once

#include "social/SocialUserInfo.h"
#include <string>

NS_VIGAME_SOCIAL_BEGIN

class AliGameUserInfo : public SocialUserInfo
{
private:
	std::string userId;
public:
	const char* OPPORTUNITY_TYPE_CREATEROLE = "createRole"; //创建角色
	const char* OPPORTUNITY_TYPE_ENTERGAME = "enterGame";   //进入游戏
	const char* OPPORTUNITY_TYPE_UPDATES = "updates";       //角色升级
	const char* OPPORTUNITY_TYPE_EXITGAME = "exitGame";     //角色退出游戏场景

	std::string ROLE_ID;   //无符号整型  角色标识
	std::string ROLE_NAME; //角色名称
	std::string ROLE_LEVEL; //无符号整型  角色等级，必填，如游戏存在转生，转职等，等级需累加，长度不超过10
	std::string ZONE_ID; //无符号整型  区服名称
	std::string ZONE_NAME; //区服名称
	std::string OPPORTUNITY_TYPE;
	std::string UNION_NAME; //工会名称，没有填空字符串
	std::string GAME_MONEY; //无符号整型  游戏币余额，没有填空字符串
	std::string ROLE_UNION_ID; //无符号整型 工会ID
	std::string ROLE_PROFESSION_ID; //无符号整型  职业ID，若无，传入“0”
	std::string ROLE_PROFESSION_NAME; //职业名称，若无，传入“无”
	std::string ROLE_GENDER; //性别“男、女、无”
	std::string ROLE_POWER_VALUE; //无符号整型  战力值，必填，若无，传入”0”
	std::string ROLE_VIP_LEVEL; //无符号整型  VIP等级，必填，若无，传入”0”
	std::string ROLE_UNION_TITLE_ID; //无符号整型  工会称号ID，帮派会长/帮主必传1，其他可自定义，不能为空，不能为null，若无，传入 0
	std::string ROLE_UNION_TITLE_NAME;  //工会称号名称，若无，传入“无”
	std::string ROLE_FRIEND_LIST; //好友列表，参数需拼接，请查看示例
	std::string ROLE_CREATE_TIME; // 角色创建时间，这里使用时间戳/1000得到10位数，【必须使用服务端记录的值】，否则审核不通过

	AliGameUserInfo();
	virtual bool parse(const std::unordered_map<std::string, std::string>& param) override;

	virtual std::unordered_map<std::string, std::string> getMap();

	virtual std::string getAccountId() override;
};

NS_VIGAME_SOCIAL_END
