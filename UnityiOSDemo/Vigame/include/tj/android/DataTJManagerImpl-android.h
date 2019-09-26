#pragma once

#include "tj/DataTJManagerImpl.h"

#include <string>

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_ANDROID

NS_VIGAME_TJ_BEGIN
	
class DataTJManagerImplAndroid : public DataTJManagerImpl
{
protected:
	virtual void init() override;

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
																															 //设置 统计 一次事件
	virtual void setFirstLaunchEvent(std::unordered_map<std::string, std::string>& attributes)override;
};

NS_VIGAME_TJ_END

#endif
