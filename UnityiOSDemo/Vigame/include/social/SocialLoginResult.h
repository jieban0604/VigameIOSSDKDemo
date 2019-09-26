#pragma once

#include "social/SocialResult.h"
#include <string>

NS_VIGAME_SOCIAL_BEGIN

class SocialLoginResult : public SocialResult
{
protected:
	int loginType;

	virtual bool parse(const std::unordered_map<std::string, std::string>& param) override;

public:
	SocialLoginResult();

	//登录类型：0:登录 1:登出
	int getLoginType();
};

NS_VIGAME_SOCIAL_END
