#pragma once

#include "social/SocialLoginResult.h"

NS_VIGAME_SOCIAL_BEGIN

class AliGameLoginResult : public SocialLoginResult
{
public:
	std::string token = "";

	AliGameLoginResult();
	virtual bool parse(const std::unordered_map<std::string, std::string>& param) override;
};

NS_VIGAME_SOCIAL_END
