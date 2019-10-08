#pragma once

#include "share//ShareManagerImpl.h"
#include <vector>

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_ANDROID

NS_VIGAME_SHARE_BEGIN
	
class ShareManagerImplAndroid : public ShareManagerImpl
{
protected:
	virtual void init() override;

	virtual void shareOnPlatform(ShareInfo& info) override;
    
    virtual bool isShareAvailable(ShareInfo& info) override;
	virtual void inviteOnPlatform(ShareInfo&info) override;
	virtual bool inviteEnable(ShareInfo& info) override;
    
    //virtual void getInvitableFriendsId(ShareInfo& info, const std::function<void(ShareRetCode result, std::vector<InvitableFriendInfo> data)>& callback) override;
    
    //virtual void invitePeopleById(std::vector<std::string> openId) override;
};

NS_VIGAME_SHARE_END

#endif
