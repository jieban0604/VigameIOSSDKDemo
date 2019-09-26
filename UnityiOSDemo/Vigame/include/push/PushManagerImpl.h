#pragma once

#include "push/macros.h"
#include <unordered_map>
#include <string>
#include <set>
#include <map>
#include <vector>
#include <functional>
#include <map>
NS_VIGAME_PUSH_BEGIN
using namespace std;
enum PushAgentType
{
	UMENG = 1,
};

typedef std::function<void(std::unordered_map<std::string,std::string>)> CallbackCustomAction;

class PushManagerImpl
{
	CallbackCustomAction m_callbckCustomAction;
public:
	static PushManagerImpl* getInstance();

	virtual void init(bool request);
	//申请推送权限
	virtual void requestPermission() {

	}
	void setCustomActionCallback(const CallbackCustomAction& callback);

	//通知栏可以设置最多显示通知的条数，当有新通知到达时，会把旧的通知隐藏。
	virtual void setDisplayNotificationNumber(int num);
	//添加标签
	virtual void addTag(std::set<std::string> tags);
	//删除标签
	virtual void removeTag(std::set<std::string> tags);
	//清除用户标签
	virtual void resetTag();
	//设置用户别名（用户id和device_token的一对多的映射关系）
	virtual void addAlias(std::string userid, int type);
	virtual void dealWithCustomAction(std::string);
	std::unordered_map<std::string, std::string>  string2Map(std::string);
    virtual std::map<std::string,std::string> getPushInfomations();
    void dealWithCustomAction(std::unordered_map<std::string, std::string> map);
};

NS_VIGAME_PUSH_END
