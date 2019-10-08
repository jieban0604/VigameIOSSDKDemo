#pragma once

#include "social/SocialLoginResult.h"

NS_VIGAME_SOCIAL_BEGIN

class FBLoginAuthResult : public SocialResult
{
public:
	std::string code;//授权成功返回code
	std::string state;
	std::string url;
	std::string lang;
	std::string country;

	FBLoginAuthResult();
	virtual bool parse(const std::unordered_map<std::string, std::string>& param) override;
};

class FBLoginAccessTokenResult : public SocialResult
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

	FBLoginAccessTokenResult();
	virtual bool parse(const std::unordered_map<std::string, std::string>& param) override;
};

class FBLoginResult : public SocialLoginResult
{
public:
	FBLoginAuthResult loginAuthResult;
	FBLoginAccessTokenResult loginAccessTokenResult;

	virtual bool parse(const std::unordered_map<std::string, std::string>& param) override;
};

NS_VIGAME_SOCIAL_END
