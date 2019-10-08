#pragma once

#include "tj/DataTJManagerImpl.h"
#include <string>
#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_MAC || VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_IOS
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_VIGAME_TJ_BEGIN
#define  TJApple   ((vigame::tj::DataTJManagerImplApple *) vigame::tj::DataTJManagerImpl::getInstance())
class DataTJManagerImplApple : public DataTJManagerImpl
{
public:
    virtual void init() override;
protected:
	//virtual void init() override;

	//账号统计
	virtual void profileSignIn(const char * puid, const char * provider = nullptr) override;
	virtual void profileSignOff() override;

    virtual void setUserLevel(int level) override;
	//充值
	virtual void pay(double money, double coin, int source) override;
	//充值并购买道具
	virtual void pay(double money, const char* item, int number, double price, int source) override;

	//购买
	virtual void buy(const char *item, int number, double price) override;

	//消耗
	virtual void use(const char *item, int number, double price) override;

	//奖励
	virtual void bonus(double coin, int source) override;// 赠送金币
	virtual void bonus(const char *item, int number, double price, int source) override;// 赠送道具

	//关卡
	virtual void startLevel(const char *level) override;
	virtual void finishLevel(const char *level, const char *score = "") override;
	virtual void failLevel(const char *level, const char *score = "") override;

	//事件统计--计数事件
	virtual void event(const char * eventId, const char * label = nullptr) override;//事件数量统计
    
    //virtual void event(const char * eventId, const char * label, int acount) override;//事件数量统计
	virtual void event(const char * eventId, std::unordered_map<std::string, std::string>& attributes) override;//统计点击行为各属性被触发的次数

	//事件统计--计算事件
	virtual void event(const char *eventId, std::unordered_map<std::string, std::string>& attributes, int duration) override;//统计数值型变量的值的分布
    
	virtual void setFirstLaunchEvent(std::unordered_map<std::string, std::string>& attributes)override;
    
    virtual void dataEyeShowTJ(std::string sid, std::string adPositionName, std::string ad_type, std::string param)override;

    
public:
    
    NSArray * tjConfigs;
    
    void applicationDidBecomeActive();
    
//    void appDidFinishLaunchingWithOptions(UIApplication *app,NSDictionary *dict);
    
    BOOL appOpenURLSourceApplication(UIApplication *application,NSURL *url,NSString *sourceApplication,id annotation);
    
    void  applicationContinueUserActivity(UIApplication *application,NSUserActivity *activity);
};

NS_VIGAME_TJ_END

#endif
