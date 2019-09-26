#pragma once

#include "social/macros.h"

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_MAC ||  VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_IOS
#include "social/SocialDefine.h"
#include <string>
#include <functional>
#include <memory>
#include <unordered_map>

NS_VIGAME_SOCIAL_BEGIN

class SocialBaseAgent;
class SocialUserInfo;

class SocialManagerPlatform
{
public:
	static SocialManagerPlatform* getInstance();

	void init();

	//是否支持指定社交代理
	bool isSupportSocialAgent(SocialBaseAgent* agent);

	//获取基本信息
	std::unordered_map<std::string, std::string> getBaseInfo(SocialBaseAgent* agent);

	//登录
	void login(SocialBaseAgent* agent);

	//注销
	void logout(SocialBaseAgent* agent);

	//更新用户信息
	void updateUserInfo(SocialBaseAgent* agent);

	//获取登录结果
	std::unordered_map<std::string, std::string> getLoginResult(SocialBaseAgent* agent);

	//获取用户信息
	std::unordered_map<std::string, std::string> getUserInfo(SocialBaseAgent* agent);

public:
	//登录完成
	void onLoginFinish(SocialType socialType, const std::unordered_map<std::string, std::string>& result);

	//更新用户信息完成
	void onUpdateUserInfoFinish(SocialType socialType, const std::unordered_map<std::string, std::string>& result);
};

NS_VIGAME_SOCIAL_END

#endif
