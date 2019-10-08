#pragma once

#include "social/SocialUserInfo.h"
#include <string>
#include <map>

NS_VIGAME_SOCIAL_BEGIN

class FBUserInfo : public SocialUserInfo
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
    //id, name
	std::unordered_map<std::string, std::string > friendsOpenidList;
    //id, name, photo URL
    std::unordered_map<std::string, std::pair<std::string, std::string> > inviteFriendsOpenidList;

	virtual bool parse(const std::unordered_map<std::string, std::string>& param) override;
	virtual bool parsejson(const std::string& jsonstr);

	virtual std::string getAccountId() override {
		return openid;
	}
	//普通用户昵称
	virtual std::string getUserName() override {
		return nickname;
	}

	//普通用户性别   1男  2女  0未知
	virtual int getSex() override {
		return sex;
	}

	//个人资料填写的国家
	virtual std::string getCounty() override {
		return country;
	}

	//个人资料填写的省份
	virtual std::string getProvince() override {
		return province;
	}

	//个人资料填写的城市
	virtual std::string getCity() override {
		return city;
	}

	//用户头像url
	virtual std::string getHeadImgUrl() override {
		return headimgUrl;
	}

};

NS_VIGAME_SOCIAL_END
