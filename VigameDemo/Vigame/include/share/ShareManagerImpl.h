#pragma once

#include "share/macros.h"
#include "share/ShareInfo.h"
#include "share/ShareDefine.h"
#include <string>
#include <functional>
#include <memory>
#include <unordered_map>
#include <vector>

NS_VIGAME_SHARE_BEGIN

class ShareManagerImpl
{
private:
	std::function<void(ShareRetCode result, std::string reason)> m_shareCallback;
    std::function<void(InviteRetCode result, std::string reason)> m_inviteCallback;
public:
	static ShareManagerImpl* getInstance();
	
	virtual void init();

	//info 里面 imageUrl，url，platform 字段不能为空
    virtual void invite(ShareInfo&info, const std::function<void(InviteRetCode result, std::string reason)>& callback) final;
	virtual bool inviteEnable(ShareInfo& info) { return false; }

	virtual void share(ShareInfo& info, const std::function<void(ShareRetCode result, std::string reason)>& callback) final;
    
    virtual bool isShareAvailable(ShareInfo& info) = 0;

	virtual void onShareFinish(const ShareRetCode& result, const std::string& reason) final;
    
    virtual void onInViteFinish(const InviteRetCode& result, const std::string& reason) final;
    
    //virtual void getInvitableFriendsId(ShareInfo& info, const std::function<void(ShareRetCode result, std::vector<InvitableFriendInfo> data)>& callback) = 0;
    
    //virtual void invitePeopleById(std::vector<std::string> openId) = 0;
protected:
	virtual void shareOnPlatform(ShareInfo& info) = 0;
    virtual void inviteOnPlatform(ShareInfo& info) = 0;
};

NS_VIGAME_SHARE_END
