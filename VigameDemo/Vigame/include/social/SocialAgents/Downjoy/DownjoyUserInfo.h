#pragma once
#include "social/SocialUserInfo.h"
#include <string>

NS_VIGAME_SOCIAL_BEGIN

class DownjoyUserInfo : public SocialUserInfo
{
	std::string umid;     //普通用户的标识
	std::string username;	//用户名
	//std::string nickname;   //普通用户昵称
	std::string phone;		//当乐用户登录手机
	std::string gender;		// 当乐用户性别，可取值：男，女，未知。
	std::string vip;		//当乐用户 vip 等级
	std::string avatarUrl;	//当乐用户头像地址
	std::string security_num;//当乐用户密保手机
public:

	virtual bool parse(const std::unordered_map<std::string, std::string>& param) override;
	//virtual bool parsejson(const std::string& jsonstr);

	virtual std::string getAccountId() override {
		return umid;
	}

	virtual std::string getUserName() override {
		return username;
	}

	virtual int getSex() override {
		return gender=="男"?1:0;
	}

	virtual std::string getHeadImgUrl() override{
		return avatarUrl;
	}

	std::string getPhone() {
		return phone;
	}
	std::string getVip() {
		return vip;
	}
	std::string getSecurityNum() {
		return security_num;
	}
};

NS_VIGAME_SOCIAL_END
