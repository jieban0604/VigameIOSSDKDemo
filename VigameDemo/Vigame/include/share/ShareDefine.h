#pragma once

#include "share/macros.h"
#include <string>
using namespace std;
NS_VIGAME_SHARE_BEGIN

enum class ShareRetCode
{
	Fail = 0,
	Success = 1,
	Cancel = 2,
};

enum class InviteRetCode
{
    Fail = 0,
    Success = 1,
    Cancel = 2,
};

enum class SharePlatform
{
    Panel = 0,//分享面板
    WeChat = 1,
    QQ = 2,
    FB = 3,
    MSDK = 4,
};

enum class ShareType
{
    BigPicture = 0,
    JumpLink = 1,
	MiniProgram = 2,//微信小程序
	Text = 3,//纯文本
};

class WXShareData {
public:
	WXShareData() {}
	std::string resultCode;		//响应标志, 0表示成功, 其他表示失败
	std::string	resultMsg;		//响应内容 eg:成功
	std::string	url;            //分享链接
	std::string	title;          //分享标题
	std::string	content;        //分享内容
};


class InvitableFriendInfo{
public:
    std::string openId;
    std::string name;
    std::string imageURL;
};


NS_VIGAME_SHARE_END
