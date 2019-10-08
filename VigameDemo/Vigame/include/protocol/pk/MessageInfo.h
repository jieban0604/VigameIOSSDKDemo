#pragma once

#include "UserInfo.h"
#include <string>
#include <vector>

NS_VIGAME_PROTOCOL_BEGIN

//系统广播条目
struct MessageItemInfo
{
	std::string type;    //广播类型：system-系统	activity-活动
	std::string color;   //广播文字颜色 eg:黄色：{255,255,0} 红色：{255,0,0}
	std::string body;    //广播文字内容
};


//系统广播
struct MessageInfo 
{
	std::vector<MessageItemInfo> messageItems;
};


NS_VIGAME_PROTOCOL_END
