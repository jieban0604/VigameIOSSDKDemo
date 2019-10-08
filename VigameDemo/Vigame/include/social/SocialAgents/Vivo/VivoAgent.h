/********************************************************************
	created:	2017/08/01
	created:	1:8:2017   10:17
	filename: 	D:\work7\VigameLibrary\source\vigame\social\SocialAgents\Downjoy\VivoAgent.h
	file path:	D:\work7\VigameLibrary\source\vigame\social\SocialAgents\Downjoy
	file base:	VivoAgent
	file ext:	h
	author:		Tyson
	
	purpose:	当乐社交
*********************************************************************/

#include "social/SocialBaseAgentWrapper.h"
#include <string>
#include "VivoLoginResult.h"
#include "VivoUserInfo.h"
NS_VIGAME_SOCIAL_BEGIN

class VIGAME_DECL VivoAgent : public SocialBaseAgentWrapper {
private:
	std::shared_ptr<VivoLoginResult> m_loginResult;
	std::shared_ptr<VivoUserInfo> m_userInfo;
public:
	
	virtual SocialType getType() override;
	
	virtual void login(const std::unordered_map<std::string, std::string>& param, const LoginCallback& callback) override;

	virtual bool isSupport() override;

	virtual bool isLogined() override;

	virtual void updateUserInfo(const UpdateUserInfoCallback& callback, UpdateInfoType type = UpdateInfoType::BaseInfo) override;

	virtual SocialLoginResult* getLoginResult() override;

	virtual SocialUserInfo* getUserInfo() override;
	void reportRoleInfo(const std::string& roleId, const std::string& roleLevel, const std::string& roleName, const std::string& serviceAreaID, const std::string& serviceAreaName);
protected:
	virtual void onLoginFinish(const std::unordered_map<std::string, std::string>& loginResultMap) override;
	
	virtual void onLoginFinish(std::shared_ptr<SocialLoginResult> loginResult) override;

	virtual void onUpdateUserInfoFinish(const std::unordered_map<std::string, std::string>& userInfoMap) override final;

	virtual void onUpdateUserInfoFinish(std::shared_ptr<SocialUserInfo> userInfo) override final;

	
};

NS_VIGAME_SOCIAL_END