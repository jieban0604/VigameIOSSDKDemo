#pragma once

#include "social/SocialUserInfo.h"
#include <string>

NS_VIGAME_SOCIAL_BEGIN

class WeChatUserInfo : public SocialUserInfo
{
public:

	std::string openid;     //普通用户的标识
	std::string nickname;   //普通用户昵称
	std::string province;   //个人资料填写的省份
	std::string city;       //个人资料填写的城市
	std::string country;    //个人资料填写的国家
	std::string headimgUrl; //用户头像url
	std::string privilege;  //用户特权信息，json数组
	std::string unionid;    //用户统一标识
	int sex;                //普通用户性别   1男  2女
	std::vector<std::pair<std::string, std::string> >friendsOpenidList;

	virtual bool parse(const std::unordered_map<std::string, std::string>& param) override;
	virtual bool parsejson(const std::string& jsonstr);

	virtual std::string getAccountId() override;

	virtual std::string getUserName() override;

	virtual int getSex() override;

	virtual std::string getCounty() override;

	virtual std::string getProvince() override;

	virtual std::string getCity() override;

	virtual std::string getHeadImgUrl() override;
};

NS_VIGAME_SOCIAL_END
