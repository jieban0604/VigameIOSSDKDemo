#pragma once
#include "social/SocialUserInfo.h"
#include <string>

NS_VIGAME_SOCIAL_BEGIN

class VivoUserInfo : public SocialUserInfo
{
	std::string roleId;     //角色id
	std::string roleName;	//角色名称


public:

	virtual bool parse(const std::unordered_map<std::string, std::string>& param) override;

	virtual std::string getAccountId() override {
		return roleId;
	}

	virtual std::string getUserName() override {
		return roleName;
	}

};

NS_VIGAME_SOCIAL_END
