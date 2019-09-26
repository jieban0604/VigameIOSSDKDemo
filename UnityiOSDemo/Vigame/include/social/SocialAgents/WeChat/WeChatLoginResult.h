#pragma once

#include "social/SocialLoginResult.h"

NS_VIGAME_SOCIAL_BEGIN

class WeChatLoginAuthResult : public SocialResult
{
public:
	std::string code;//授权成功返回code
	std::string state;
	std::string url;
	std::string lang;
	std::string country;

	WeChatLoginAuthResult();
	virtual bool parse(const std::unordered_map<std::string, std::string>& param) override;
};

class WeChatLoginAccessTokenResult : public SocialResult
{
public:
	std::string accessToken;//接口调用凭证
	int expiresIn;//access_token接口调用凭证超时时间，单位（秒）
	int errCode;
	std::string errMsg;
	std::string refreshToken;//用户刷新access_token
	std::string openid;//(登录)授权用户唯一标识
	std::string scope;//(登录)用户授权的作用域，使用逗号（,）分隔
	std::string unionid;//只有在用户将公众号绑定到微信开放平台帐号后，才会出现该字段。

	WeChatLoginAccessTokenResult();
	virtual bool parse(const std::unordered_map<std::string, std::string>& param) override;
};

class WeChatLoginResult : public SocialLoginResult
{
public:
	WeChatLoginAuthResult loginAuthResult;
	WeChatLoginAccessTokenResult loginAccessTokenResult;

	virtual bool parse(const std::unordered_map<std::string, std::string>& param) override;
};

NS_VIGAME_SOCIAL_END
