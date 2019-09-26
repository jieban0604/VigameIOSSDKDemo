#pragma once

#include "push/macros.h"
#include <unordered_map>
#include <string>
#include <set>
#include <functional>
#include <map>
#include <unordered_map>
NS_VIGAME_PUSH_BEGIN

typedef std::function<void(std::unordered_map<std::string, std::string>)> CallbackCustomAction;
class PushManager
{
public:
	static void init(bool request = true);
	//通知栏可以设置最多显示通知的条数，当有新通知到达时，会把旧的通知隐藏。
	static void setDisplayNotificationNumber(int num);
	//添加标签
	static void addTag(std::set<std::string> tags);
	//删除标签
	static void removeTag(std::set<std::string> tags);
	//清除用户标签
	static void resetTag();
	//设置用户别名（用户id和device_token的一对多的映射关系）
	static void addAlias(std::string userid, int type);
	static void setCustomActionCallback(const CallbackCustomAction&  callback);
    static std::map<std::string,std::string> getPushInfomations();
};

NS_VIGAME_PUSH_END
