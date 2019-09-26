#pragma once

#include "social/macros.h"

NS_VIGAME_SOCIAL_BEGIN

enum class SocialRetCode
{
	Fail = 0,
	Success = 1,
	Cancel = 2,
};

enum class SocialType
{
	NOTYPE =-1,
	WeChat = 1,
	QQ = 2,
    FB = 3, 
	MSDK = 4,
	AliGame = 5,
	Downjoy = 6,
	Vivo = 7,
};

enum class LoginPermission
{
    Public_Profile = 1,
    Publish_Actions = 2,
    User_Relationship_Details = 3,
};

enum class SocialStatus
{

	Status_initing = 0,
	Status_init_success,
	Status_init_fail,	

	Status_logining = 4,
	Status_login_fail,
	Status_login_success,
	Status_login_out,
	Status_login_change,

};

enum VBFBSDKGameRequestActionType {
    /*! No action type */
    VBFBSDKGameRequestActionTypeNone,
    /*! Send action type: The user is sending an object to the friends. */
    VBFBSDKGameRequestActionTypeSend,
    /*! Ask For action type: The user is asking for an object from friends. */
    VBFBSDKGameRequestActionTypeAskFor,
    /*! Turn action type: It is the turn of the friends to play against the user in a match. (no object) */
    VBFBSDKGameRequestActionTypeTurn
};


enum class UpdateInfoType
{
    //基础信息
    BaseInfo = 0,
    //可以邀请的好友信息,facebook用到
    InviteFriendInfo = 1
};


NS_VIGAME_SOCIAL_END
