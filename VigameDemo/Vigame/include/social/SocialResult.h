#pragma once

#include "social/macros.h"
#include "social/SocialDefine.h"
#include <string>
#include <unordered_map>

NS_VIGAME_SOCIAL_BEGIN

class SocialResult
{
private:
	SocialRetCode retCode;
	std::string reason;

public:
	SocialResult();

	virtual bool parse(const std::unordered_map<std::string, std::string>& param);

	virtual SocialRetCode getRetCode();

	virtual void setRetCode(SocialRetCode retCode);

	virtual std::string getReason();

	virtual void setReason(std::string reason);
};

NS_VIGAME_SOCIAL_END