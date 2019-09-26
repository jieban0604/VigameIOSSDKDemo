#pragma once

#include "push/PushManagerImpl.h"

#include <string>

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_ANDROID

NS_VIGAME_PUSH_BEGIN
	
class PushManagerImplAndroid : public PushManagerImpl
{
protected:
	virtual void init(bool request) override;

	//通知栏可以设置最多显示通知的条数，当有新通知到达时，会把旧的通知隐藏。
	virtual void setDisplayNotificationNumber(int num) override;
	//添加标签
	virtual void addTag(std::set<std::string> tags) override;
	//删除标签
	virtual void removeTag(std::set<std::string> tags) override;
	//清除用户标签
	virtual void resetTag() override;
	//设置用户别名（用户id和device_token的一对多的映射关系）
	virtual void addAlias(std::string userid, int type) override;
};

NS_VIGAME_PUSH_END

#endif
