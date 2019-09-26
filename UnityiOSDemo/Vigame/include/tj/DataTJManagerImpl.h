#pragma once

#include "tj/macros.h"
#include <unordered_map>
#include <string>

NS_VIGAME_TJ_BEGIN

enum DataTJAgentType
{
	UMENG = 1,
};

class DataTJManagerImpl
{
public:
	static DataTJManagerImpl* getInstance();

	virtual void init();

	//账号统计
	virtual void profileSignIn(const char * puid, const char * provider = nullptr) = 0;
	virtual void profileSignOff() = 0;

    virtual void setUserLevel(int level) = 0;
	//充值
	virtual void pay(double money, double coin, int source) = 0;
	//充值并购买道具
	virtual void pay(double money, const char* item, int number, double price, int source) = 0;

	//购买
	virtual void buy(const char *item, int number, double price) = 0;

	//消耗
	virtual void use(const char *item, int number, double price) = 0;

	//奖励
	virtual void bonus(double coin, int source) = 0;// 赠送金币
	virtual void bonus(const char *item, int number, double price, int source) = 0;// 赠送道具

	//关卡
	virtual void startLevel(const char *level) = 0;
	virtual void finishLevel(const char *level, const char *score = "") = 0;
	virtual void failLevel(const char *level, const char *score = "") = 0;

	//事件统计--计数事件
	virtual void event(const char * eventId, const char * label = nullptr) = 0;//事件数量统计
//    virtual void event(const char * eventId, const char * label, int count) = 0;//事件数量统计
	virtual void event(const char * eventId, std::unordered_map<std::string, std::string>& attributes) = 0;//统计点击行为各属性被触发的次数

	 //事件统计--计算事件
	virtual void event(const char *eventId, std::unordered_map<std::string, std::string>& attributes, int duration) = 0;//统计数值型变量的值的分布

	//设置 统计 一次事件
	virtual void setFirstLaunchEvent(std::unordered_map<std::string, std::string>& attributes)=0;
    
    virtual void dataEyeShowTJ(std::string sid, std::string adPositionName, std::string ad_type, std::string param){};
};

NS_VIGAME_TJ_END
