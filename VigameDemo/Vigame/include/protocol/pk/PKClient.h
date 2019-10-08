#pragma once

#include "UserInfo.h"
#include "PKInfo.h"
#include "BonusInfo.h"
#include "RotaryInfo.h"
#include "MessageInfo.h"
#include <string>
#include <functional>

NS_VIGAME_PROTOCOL_BEGIN

class PKClient
{
public:
	static PKClient* getInstance();

	//获取用户信息
	void getUserInfo(std::function<void(bool result, UserInfo userinfo)> callback);

	//设置用户信息
	bool setUserInfo(const UserInfo& userinfo);
	
	//获取PK数据
	void getPKInfo(const std::string& area, std::function<void(bool result, PKInfo pkInfo)> callback);
	void getPKInfo(std::function<void(bool result, PKInfo pkInfo)> callback){ return getPKInfo("0", callback); }


	//上传PK数据
	void setVSScore(int vsScore, const std::string& area, std::function<void(bool result, PKRankResult pkRankResult)> callback);
	void setPKScore(int pkScore, const std::string& area, std::function<void(bool result, PKRankResult pkRankResult)> callback);
	void setTopScore(int topScore, const std::string& area, std::function<void(bool result, PKRankResult pkRankResult)> callback);

	void setVSScore(int vsScore, std::function<void(bool result, PKRankResult pkRankResult)> callback)
	{
		return setVSScore(vsScore, "0", callback);
	}
	void setPKScore(int pkScore, std::function<void(bool result, PKRankResult pkRankResult)> callback)
	{
		return setPKScore(pkScore, "0", callback);
	}
	void setTopScore(int topScore, std::function<void(bool result, PKRankResult pkRankResult)> callback)
	{
		return setTopScore(topScore, "0", callback);
	}

	//询问奖励协议
	void getBonus(const std::string& area, int level, bool isSupportWX, std::function<void(bool result, BonusInfo bonusInfo)> callback);
	void getBonus(const std::string& area, int level, std::function<void(bool result, BonusInfo bonusInfo)> callback);

	//转盘抽奖协议
	void getRotary(std::function<void(bool result, RotaryInfo rotaryInfo)> callback);

	//获取系统广播
	void getMessage(std::function<void(bool result, MessageInfo messageInfo)> callback);

protected:
	void commintPKScore(const std::string& action, const std::string& score, const std::string& area, std::function<void(bool result, PKRankResult pkRankResult)> callback);
	
};


NS_VIGAME_PROTOCOL_END
