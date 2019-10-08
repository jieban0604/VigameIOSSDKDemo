#pragma once

#include "tj/macros.h"
#include <unordered_map>
#include <string>


NS_VIGAME_TJ_BEGIN

class DataTJManager
{
public:
	static void init();

	//账号统计
	static void profileSignIn(const char * puid, const char * provider = nullptr);
	static void profileSignOff();

    static void setUserLevel(int level);
	//充值
	static void pay(double money, double coin, int source);
	//充值并购买道具
	static void pay(double money, const char* item, int number, double price, int source);

	//购买
	static void buy(const char *item, int number, double price);

	//消耗
	static void use(const char *item, int number, double price);

	//奖励
	static void bonus(double coin, int source);// 赠送金币
	static void bonus(const char *item, int number, double price, int source);// 赠送道具

	//关卡
	static void startLevel(const char *level);
    static void finishLevel(const char *level, const char *score = "");
	static void failLevel(const char *level, const char *score = "");

	//事件统计--计数事件
	static void event(const char * eventId, const char * label = nullptr/*用户字段*/);//事件数量统计
    //static void event(const char * eventId, const char * label, int acount);
	static void event(const char * eventId, std::unordered_map<std::string, std::string>& attributes);//统计点击行为各属性被触发的次数

	//事件统计--计算事件
	static void event(const char *eventId, std::unordered_map<std::string, std::string>& attributes, int duration);//统计数值型变量的值的分布
	//设置 统计 一次事件
	static void setFirstLaunchEvent(std::unordered_map<std::string, std::string>& attributes);
};

NS_VIGAME_TJ_END
