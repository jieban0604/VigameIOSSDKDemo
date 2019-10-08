#pragma once

#include "social/SocialBaseAgentWrapper.h"
#include "FBLoginResult.h"
#include "FBUserInfo.h"
#include <string>

NS_VIGAME_SOCIAL_BEGIN

typedef std::function<void(SocialRetCode retCode, std::string reason)> AskPeopleCallback;

class VIGAME_DECL FBAgent : public SocialBaseAgentWrapper
{
private:
	std::shared_ptr<FBLoginResult> m_FBLoginResult;
	std::shared_ptr<FBUserInfo> m_FBUserInfo;
	std::string APP_ID;
	std::string APP_SECRET;
	std::string MCH_ID;
	std::string API_KEY;
	std::string NOTIFYURL;

	AskPeopleCallback m_AskPeopleCallback;
public:
	virtual SocialType getType() override final;

	virtual bool isSupport() override final;

	virtual bool isLogined() override final;

	//virtual void login(const LoginCallback& loginCallback) override;
    //param参数可传loginPermission
	virtual void login(const std::unordered_map<std::string, std::string>& param, const LoginCallback& callback) override;
// 	virtual void login(int type, const LoginCallback& callback) override;
// 
//     virtual void login(LoginPermission loginPermission, const LoginCallback& loginCallback) override;

	virtual void logout() override;

	virtual SocialLoginResult* getLoginResult() override;

    virtual void updateUserInfo(const UpdateUserInfoCallback& callback, UpdateInfoType type = UpdateInfoType::BaseInfo) override;

	virtual SocialUserInfo* getUserInfo() override;
    
    //linkURL 去 https://developers.facebook.com/quickstarts/?platform=app-links-host 生成
   // virtual void inviteFriend(std::string linkURL, std::string imageURL) override;
//     
//     
 	virtual void askPeopleForSomething(VBFBSDKGameRequestActionType type, std::vector<std::string> openId, std::string title, std::string objectId, const AskPeopleCallback& callback);
    
	void onAskPeopleFinish(SocialRetCode result, std::string reason);

protected:
	virtual void onLoginFinish(const std::unordered_map<std::string, std::string>& loginResultMap) override final;
	virtual void onLoginFinish(std::shared_ptr<SocialLoginResult> loginResult) override final;

public:
	virtual void onUpdateUserInfoFinish(const std::unordered_map<std::string, std::string >& userInfoMap) override final;
	virtual void onUpdateFriendInfoFinish(const std::unordered_map<std::string, std::string >& userInfoMap) final;
	virtual void onUpdateInviteFriendInfoFinish(const std::unordered_map<std::string, std::string >& userInfoMap) final;


	virtual void onUpdateUserInfoFinish(std::shared_ptr<SocialUserInfo> userInfo) override final;
	virtual void onUpdateUserInfoFail(const std::string& reason) final;

protected:
	//virtual void loadBaseInfo();
	virtual bool isInstalled();
	virtual bool isSupportAPI();

};

NS_VIGAME_SOCIAL_END
