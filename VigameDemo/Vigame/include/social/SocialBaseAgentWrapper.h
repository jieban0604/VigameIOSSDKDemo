#pragma once

#include "social/SocialBaseAgent.h"
#include "social/SocialDefine.h"
#include "social/SocialLoginResult.h"
#include "social/SocialUserInfo.h"
#include <string>
#include <unordered_map>
#include <functional>
#include <memory>

NS_VIGAME_SOCIAL_BEGIN

class VIGAME_DECL SocialBaseAgentWrapper : public SocialBaseAgent
{
protected:
	LoginCallback m_loginCallback;
	UpdateUserInfoCallback m_updateUserInfoCallback;

public:
	virtual SocialType getType() = 0;

	virtual bool isSupport() = 0;

	virtual void openApplication();

	virtual bool isLogined();

	//virtual void login(const LoginCallback& callback);
	
	virtual void login(const std::unordered_map<std::string, std::string>& param, const LoginCallback& callback);
//     virtual void login(LoginPermission loginPermission, const LoginCallback& loginCallback);
// 
// 	virtual void login(int type, const LoginCallback& callback);


	virtual void logout();

	virtual void updateUserInfo(const UpdateUserInfoCallback& callback);

	virtual void commitUserInfo();

	virtual SocialLoginResult* getLoginResult() = 0;

	virtual SocialUserInfo* getUserInfo() = 0;

public:
	virtual void onLoginFinish(const std::unordered_map<std::string, std::string>& loginResultMap) = 0;

	virtual void onUpdateUserInfoFinish(const std::unordered_map<std::string, std::string>& userInfoMap) = 0;
	//virtual void onUpdateFriendInfoFinish(const std::unordered_map<std::string, std::string >& userInfoMap) = 0;
	//virtual void onUpdateInviteFriendInfoFinish(const std::unordered_map<std::string, std::string >& userInfoMap) = 0;
protected:
	virtual void onLoginFinish(std::shared_ptr<SocialLoginResult> loginResult);

	virtual void onUpdateUserInfoFinish(std::shared_ptr<SocialUserInfo> userInfo);
	
};

NS_VIGAME_SOCIAL_END
