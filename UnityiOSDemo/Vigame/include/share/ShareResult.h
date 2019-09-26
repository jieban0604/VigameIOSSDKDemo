#pragma once

#include "share/macros.h"
#include "share/ShareDefine.h"
#include <string>
#include <unordered_map>

NS_VIGAME_SHARE_BEGIN

struct ShareResult
{
private:
	ShareRetCode retCode;
	std::string reason;

public:
	ShareResult();

	virtual bool parse(const std::unordered_map<std::string, std::string>& param);

	virtual ShareRetCode getRetCode();

	virtual void setRetCode(ShareRetCode retCode);

	virtual std::string getReason();

	virtual void setReason(std::string reason);
};

NS_VIGAME_SHARE_END