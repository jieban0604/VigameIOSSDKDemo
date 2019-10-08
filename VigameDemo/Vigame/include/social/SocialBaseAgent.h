#pragma once

#include "social/macros.h"
#include "social/SocialDefine.h"
#include "social/SocialLoginResult.h"
#include "social/SocialUserInfo.h"
#include <string>
#include <functional>
#include <memory>
#include <unordered_map>
NS_VIGAME_SOCIAL_BEGIN

typedef std::function<void(SocialRetCode retCode, std::string reason)> LoginCallback;
typedef std::function<void(SocialRetCode retCode, std::string reason)> UpdateUserInfoCallback;

class VIGAME_DECL SocialBaseAgent
{
public:
	virtual SocialType getType() = 0;

	virtual bool isSupport() = 0;

	virtual void openApplication() = 0;

	virtual bool isLogined() = 0;

	virtual void login(const std::unordered_map<std::string,std::string>& param,const LoginCallback& callback) = 0;
    
//     virtual void login(LoginPermission loginPermission, const LoginCallback& callback) = 0;
// 
// 	virtual void login(int type, const LoginCallback& callback) = 0;

	virtual void logout() = 0;

    virtual void updateUserInfo(const UpdateUserInfoCallback& callback, UpdateInfoType type = UpdateInfoType::BaseInfo) = 0;

	virtual SocialLoginResult* getLoginResult() = 0;

	virtual SocialUserInfo* getUserInfo() = 0;

	virtual void commitUserInfo() = 0;
    
    //virtual void inviteFriend(std::string linkURL, std::string imageURL) = 0;
    
    //virtual void askPeopleForSomething(VBFBSDKGameRequestActionType type, std::vector<std::string> openId, std::string title, std::string objectId) = 0;
    
    virtual void onLoginFinish(std::shared_ptr<SocialLoginResult> loginResult) = 0;
    
    
};

NS_VIGAME_SOCIAL_END
