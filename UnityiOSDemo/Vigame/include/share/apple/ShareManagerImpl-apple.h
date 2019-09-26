#pragma once

#include "share//ShareManager.h"
#include "share//ShareManagerImpl.h"

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_MAC ||  VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_IOS

NS_VIGAME_SHARE_BEGIN
	
class ShareManagerImplApple : public ShareManagerImpl
{
protected:
	virtual void init() override;

    virtual void inviteOnPlatform(ShareInfo&info)override;//邀请
    
	virtual void shareOnPlatform(ShareInfo& info) override;
    
    virtual bool isShareAvailable(ShareInfo& info) override;
    
    //virtual void getInvitableFriendsId(ShareInfo& info, const std::function<void(ShareRetCode result, std::vector<InvitableFriendInfo> data)>& callback) override;
    
    //virtual void invitePeopleById(std::vector<std::string> openId) override;
};

NS_VIGAME_SHARE_END

#endif
