#pragma once

#include "share/macros.h"
#include "share/ShareInfo.h"
#include "share/ShareDefine.h"
#include <functional>
#include <vector>

NS_VIGAME_SHARE_BEGIN

class ShareManager
{
public:
	static void init();

	static void invite(ShareInfo&info, const std::function<void(InviteRetCode result, std::string reason)>& callback);//邀请
	static bool inviteEnable(ShareInfo& info);

	static void share(ShareInfo& info, const std::function<void(ShareRetCode result, std::string reason)>& callback);
    
    static bool isShareAvailable(ShareInfo& info);
	//************************************
	// Method:    getWXShare 请求微信分享数据
	// FullName:  CallHelper::getWXShare
	// Access:    public 
	// Returns:   WXShareData
	// Qualifier:
	// Parameter: int lever 关卡
	// Parameter: int score 得分
	//************************************
	static WXShareData getWXShare(int level, int score);
	
// 	static std::string _getValue(const std::string& result, const char* startstr, const char* endstr);
// 	static std::string _submitGameParam(const std::string& name, const std::string& value);
    
    //得到所有可以邀请的好友的id和昵称
    //static void getInvitableFriendsId(ShareInfo& info, const std::function<void(ShareRetCode result, std::vector<InvitableFriendInfo> data)>& callback);
    //static void invitePeopleById(std::vector<std::string> openId);
};

NS_VIGAME_SHARE_END
