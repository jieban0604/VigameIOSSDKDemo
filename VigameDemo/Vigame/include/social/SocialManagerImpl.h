#pragma once

#include "social/macros.h"
#include "social/SocialDefine.h"
#include <string>
#include <functional>
#include <memory>
#include <unordered_map>
#include <map>
#include <vector>
NS_VIGAME_SOCIAL_BEGIN

class SocialBaseAgent;
class SocialLoginResult;
class SocialUserInfo;

typedef std::function<void(SocialRetCode retCode, std::string reason)> LoginCallback;
typedef std::function<void(SocialRetCode retCode, std::string reason)> UpdateUserInfoCallback;

class SocialManagerImpl
{
private:
	std::map<SocialType, std::shared_ptr<SocialBaseAgent>> m_allSocialAgent;
	SocialType m_defaultSocialType;
	std::function<void(SocialType socialType, int loginStatus)> mLoginListener;
    
    //AskPeopleCallback m_AskPeopleCallback;
public:
	static SocialManagerImpl* getInstance();

	SocialManagerImpl();
	
	virtual void init();

	//设置默认社交代理
	virtual void setDefaultSocialAgent(SocialType socialType) final;

	virtual bool isSupportSocialAgent(SocialType socialType) final;

	//跳转到社交应用
	virtual void openApplication();

	virtual void openApplication(SocialType socialType);

	//登录
	virtual void login(const LoginCallback& callback);

	virtual void login(SocialType socialType, const LoginCallback& callback);
    
	virtual void login(SocialType socialType, const std::unordered_map<std::string,std::string>& param, const LoginCallback& callback);
    //virtual void login(SocialType socialType, LoginPermission loginPermission, const LoginCallback& callback);

	//注销
	virtual void logout();

	virtual void logout(SocialType socialType);

	//获取登录信息
	virtual SocialLoginResult* getLoginResult();

	virtual SocialLoginResult* getLoginResult(SocialType socialType);

	//更新用户信息
	virtual void updateUserInfo(const UpdateUserInfoCallback& callback);

    virtual void updateUserInfo(SocialType socialType, const UpdateUserInfoCallback& callback, UpdateInfoType type = UpdateInfoType::BaseInfo);

	//提交当前用户信息
	virtual void commitUserInfo();

	virtual void commitUserInfo(SocialType socialType);

	//获取用户信息
	SocialUserInfo* getUserInfo();

	SocialUserInfo* getUserInfo(SocialType socialType);

	//获取社交sdk代理
	virtual SocialBaseAgent* getSocialAgent(SocialType socialType) final;

	template <typename Target>
	Target VIGAME_DECL getSocialAgent()
	{
		for (auto it : m_allSocialAgent)
		{
			auto agent = it.second.get();
			auto agentMatch = dynamic_cast<Target>(agent);
			if (agentMatch)
			{
				return agentMatch;
			}
		}
		return nullptr;
	}

    //void inviteFriend(SocialType socialType, std::string linkURL, std::string imageURL);
    
    //向某人索取东西
    //void askPeopleForSomething(SocialType socialType, std::vector<std::string> openId, VBFBSDKGameRequestActionType type, std::string title, std::string objectId, const AskPeopleCallback& callback);

    //void onAskFinish(const SocialRetCode& result, const std::string& reason);
    
	//设置登录状态监听  1登录成功(如已登录，再次收到视为切换账号)  2登录失败  3注销登录成功  4注销登录失败
	void setLoginListener(std::function<void(SocialType socialType, int loginStatus)> listener);

	void onLoginStatusChanged(SocialType socialType, int loginStatus);
    
    //void onAskPeopleFinish(SocialRetCode retCode, std::string reason);
private:
	virtual void registerSocialAgent(const std::shared_ptr<SocialBaseAgent>& agent) final;
};

NS_VIGAME_SOCIAL_END
