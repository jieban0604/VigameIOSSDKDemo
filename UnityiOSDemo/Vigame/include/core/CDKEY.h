#pragma once

#include "macros.h"
#include <string>
#include <functional>
#include <map>
NS_VIGAME_BEGIN

namespace dhm{

struct DhmData 
{
	DhmData();
	int price;				//价格：分
	std::string message;	//提示文字
	int state;				//使用状态（-100网络错误 -1未使用，0兑换码不存在，1成功，2不能重复使用，3参数错误，4网络错误）
	std::map<std::string, int> bonus;//奖励物品
};

bool VIGAME_DECL isSupport();  //是否支持兑换码  false：不显示  true：显示兑换码图标  

DhmData VIGAME_DECL use(const std::string& dhm);//同步

void VIGAME_DECL use(const std::string& dhm, const std::function<void(DhmData)>& callback);//异步

}

namespace exchange {

class ExchangeData
{
public:
	//int resultCode;
	//std::string resultMsg;
	std::string content;//提示内容
	int state;//兑换标志：-100 网络错误  0表示成功兑换， -1表示奖品已送完，下次再来  -2表示非法请求

	ExchangeData();
};

ExchangeData use(const std::string& prizeName, const std::string& name, const std::string& tel, const std::string& address);//同步

void use(const std::string& prizeName, const std::string& name, const std::string& tel, const std::string& address, const std::function<void(ExchangeData)>& callback);//异步

}



NS_VIGAME_END