#pragma once

#include "push/PushManagerImpl.h"
#include <string>
#import <map>

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_MAC || VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_IOS
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_VIGAME_PUSH_BEGIN

#define  PushApple   ((vigame::push::PushManagerImplApple *)vigame::push::PushManagerImplApple::getInstance())
class PushManagerImplApple : public PushManagerImpl
{
public:
    	virtual void init(bool request) override;
protected:


	//通知栏可以设置最多显示通知的条数，当有新通知到达时，会把旧的通知隐藏。
	//virtual void setDisplayNotificationNumber(int num) override;
	//添加标签
	virtual void addTag(std::set<std::string> tags) override;
	//删除标签
	virtual void removeTag(std::set<std::string> tags) override;
	//清除用户标签
	virtual void resetTag() override;
	//设置用户别名（用户id和device_token的一对多的映射关系）
	virtual void addAlias(std::string userid, int type) override;
    
    //申请用户推送权限
    virtual void requestPermission() override;
    virtual std::map<std::string,std::string> getPushInfomations() override;
    void setPush(vector<NSDictionary> a);

};

NS_VIGAME_PUSH_END

#endif
