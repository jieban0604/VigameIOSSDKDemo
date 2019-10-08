#pragma once

#include "social/SocialBaseAgentWrapper.h"
#include "WeChatLoginResult.h"
#include "WeChatUserInfo.h"
#include <string>

NS_VIGAME_SOCIAL_BEGIN

class VIGAME_DECL WeChatAgent : public SocialBaseAgentWrapper
{
private:
	std::shared_ptr<WeChatLoginResult> m_weChatLoginResult;
	std::shared_ptr<WeChatUserInfo> m_weChatUserInfo;
	std::string APP_ID;
	std::string APP_SECRET;
	std::string MCH_ID;
	std::string API_KEY;
	std::string NOTIFYURL;
public:
	virtual SocialType getType() override final;

	virtual bool isSupport() override final;

	virtual void openApplication() override final;

	virtual bool isLogined() override final;

	//virtual void login(const LoginCallback& loginCallback) override;
    
// 	virtual void login(int type, const LoginCallback& callback) override;
// 
//     virtual void login(LoginPermission loginPermission, const LoginCallback& loginCallback) override;
	
	virtual void login(const std::unordered_map<std::string, std::string>& param, const LoginCallback& loginCallback) override;

	virtual void logout() override;

	virtual SocialLoginResult* getLoginResult() override;

	virtual void updateUserInfo(const UpdateUserInfoCallback& callback, UpdateInfoType type = UpdateInfoType::BaseInfo) override;

	virtual SocialUserInfo* getUserInfo() override;
    
//     virtual void inviteFriend(std::string linkURL, std::string imageURL) override;
//     
//     virtual void askPeopleForSomething(VBFBSDKGameRequestActionType type, std::vector<std::string> openId, std::string title, std::string objectId);
	
	//启动小程序
	void launchMiniProgram(const std::string& userName, const std::string& path);

protected:
	virtual void onLoginFinish(const std::unordered_map<std::string, std::string>& loginResultMap) override final;
	virtual void onLoginFinish(std::shared_ptr<SocialLoginResult> loginResult) override final;

	virtual void onUpdateUserInfoFinish(const std::unordered_map<std::string, std::string>& userInfoMap) override final;
// 	virtual void onUpdateFriendInfoFinish(const std::unordered_map<std::string, std::string >& userInfoMap) override final;
// 	virtual void onUpdateInviteFriendInfoFinish(const std::unordered_map<std::string, std::string >& userInfoMap) override final;
	virtual void onUpdateUserInfoFinish(std::shared_ptr<SocialUserInfo> userInfo) override final;
	virtual void onUpdateUserInfoFail(const std::string& reason) final;

protected:
	//virtual void loadBaseInfo();
	virtual bool isInstalled();
	virtual bool isSupportAPI();
    
private:
    

};

NS_VIGAME_SOCIAL_END
