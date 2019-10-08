#pragma once

#include "social/macros.h"
#include "social/SocialDefine.h"
#include "social/SocialBaseAgent.h"
#include "social/SocialLoginResult.h"
#include "social/SocialUserInfo.h"
#include <functional>
#include <vector>

NS_VIGAME_SOCIAL_BEGIN

typedef std::function<void(SocialRetCode retCode, std::string reason)> LoginCallback;
typedef std::function<void(SocialRetCode retCode, std::string reason)> UpdateUserInfoCallback;

class SocialManager
{
public:
    
    
	static void init();

	//设置默认社交代理
	static void setDefaultSocialAgent(SocialType socialType);

	//是否支持指定社交代理
	static bool isSupportSocialAgent(SocialType socialType);

	//跳转到社交应用
	static void openApplication();

	static void openApplication(SocialType socialType);

	//登录
	static void login(const LoginCallback& callback);

	static void login(SocialType socialType, const LoginCallback& callback);

	static void login(SocialType socialType,const std::unordered_map<std::string,std::string>& param,const LoginCallback& callback);


	//腾讯米大师登录（type = 0 游客登录;type = 1 微信登录; type = 2 QQ登录; ）
	//static void login(SocialType socialType, int type, const LoginCallback& callback);
    
    //facebook 登录需要带登录需要的权限
    //static void login(SocialType socialType, LoginPermission loginPermission, const LoginCallback& callback);

	//注销
	static void logout();

	static void logout(SocialType socialType);

	//获取登录信息
	static SocialLoginResult* getLoginResult();

	static SocialLoginResult* getLoginResult(SocialType socialType);


	//更新用户信息
	static void updateUserInfo(const UpdateUserInfoCallback& callback);

    static void updateUserInfo(SocialType socialType, const UpdateUserInfoCallback& callback, UpdateInfoType type = UpdateInfoType::BaseInfo);

	//提交当前用户信息
	static void commitUserInfo();

	static void commitUserInfo(SocialType socialType);

	//获取用户信息
	static SocialUserInfo* getUserInfo();

	static SocialUserInfo* getUserInfo(SocialType socialType);

	//获取社交sdk代理
	static SocialBaseAgent* getSocialAgent(SocialType socialType);
    
    //邀请
    //static void inviteFriend(SocialType socialType, std::string linkURL, std::string imageURL);
    
    //向某人索取，或者赠送东西
    //static void askPeopleForSomething(SocialType socialType,std::vector<std::string> openId, VBFBSDKGameRequestActionType type, std::string title, std::string objectId, const AskPeopleCallback& callback);
    
    //得到当前登录用户的朋友id
//    static std::vector<std::string> getFriendListId(SocialType socialType);
    
    //根据用户id得到头像URL，暂时只支持facebook,需要自己再根据URL得到数据，处理成cocos2d 的texture
    static std::string getHeadimgUrlByOpenId(SocialType socialType, std::string openid);

	// 设置登录状态监听  1登录成功(如已登录，再次收到视为切换账号)  2登录失败  3注销登录成功  4注销登录失败
	static void setLoginListener(std::function<void(SocialType socialType, int loginStatus)> listener);
    
};

NS_VIGAME_SOCIAL_END
