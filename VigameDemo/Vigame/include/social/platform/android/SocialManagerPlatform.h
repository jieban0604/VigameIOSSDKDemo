#pragma once

#include "social/macros.h"

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_ANDROID
#include "social/SocialDefine.h"
#include <string>
#include <functional>
#include <memory>
#include <unordered_map>
#include <vector>

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
	//std::unordered_map<std::string, std::string> getBaseInfo(SocialBaseAgent* agent);

	//跳转到社交应用
	void openApplication(SocialBaseAgent* agent);

	//登录
	void login(SocialBaseAgent* agent);

	//带参数登录
	void login(SocialBaseAgent* agent, int type);

	//注销
	void logout(SocialBaseAgent* agent);

	//是否登录
	bool isLogined(SocialBaseAgent* agent);

	//更新用户信息
	void updateUserInfo(SocialBaseAgent* agent, UpdateInfoType type = UpdateInfoType::BaseInfo);

	//获取登录结果
	std::unordered_map<std::string, std::string> getLoginResult(SocialBaseAgent* agent);

	//获取用户信息
	std::unordered_map<std::string, std::string> getUserInfo(SocialBaseAgent* agent);

	//设置用户信息
	void setUserInfo(SocialBaseAgent* agent, std::unordered_map<std::string, std::string> param);

	//向用户获得东西，包括邀请来玩游戏
	void askPeopleForSomething(VBFBSDKGameRequestActionType type, std::vector<std::string> openId, std::string title, std::string objectId, SocialBaseAgent* agent);

	//启动小程序
	void launchMiniProgram(SocialBaseAgent* agent, const std::string& userName, const std::string& path);
public:
	//登录完成
	void onLoginFinish(SocialType socialType, const std::unordered_map<std::string, std::string>& result);

	//更新用户信息完成
	void onUpdateUserInfoFinish(SocialType socialType, const std::unordered_map<std::string, std::string>& result);

	//更新用户朋友信息完成
	void onUpdateFriendInfoFinish(SocialType socialType, const std::unordered_map<std::string, std::string>& result);

	//更新可以邀请朋友信息完成
	void onUpdateInviteFriendInfoFinish(SocialType socialType, const std::unordered_map<std::string, std::string>& result);

	// 状态改变回调
	void onLoginStatusChanged(SocialType socialType, const int result);

};

NS_VIGAME_SOCIAL_END

#endif