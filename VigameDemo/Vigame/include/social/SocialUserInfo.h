#pragma once

#include "social/SocialResult.h"
#include <string>
#include <vector>

NS_VIGAME_SOCIAL_BEGIN

class SocialUserInfo : public SocialResult
{
public:
	virtual bool parse(const std::unordered_map<std::string, std::string>& param) override;

	//社交用户账号唯一ID
	virtual std::string getAccountId();

	//普通用户昵称
	virtual std::string getUserName();

	//普通用户性别   1男  2女  0未知
	virtual int getSex();

	//个人资料填写的国家
	virtual std::string getCounty();

	//个人资料填写的省份
	virtual std::string getProvince();

	//个人资料填写的城市
	virtual std::string getCity();

	//用户头像url
	virtual std::string getHeadImgUrl();
	//用户头像url
	virtual int getLoginStatus();
};

NS_VIGAME_SOCIAL_END
