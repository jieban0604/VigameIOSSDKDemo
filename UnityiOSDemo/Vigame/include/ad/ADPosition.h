#pragma once

#include "ad/macros.h"
#include <string>
#include <vector>
#include <unordered_map>
#include <memory>

NS_VIGAME_AD_BEGIN

//游戏广告位
class VIGAME_DECL ADPosition
{
public:
	std::string name;                //广告位名称
	std::string type;                //广告类型
	int showmodel;					 //展示策略，1 按权重方式 ， 其他值就 随机  	 默认为0
	int rate;                        //广告出现概率百分比，安卓默认0，苹果默认100
	int delaytime;                   //广告延时出现时间，单位s 每次进入游戏会重置
    int delayDays;                   //广告延时几天时间，单位天
	int delaySecond;				 //广告延时多少s出现，单位s，累积时长	
	std::vector<std::string> agent;  //广告代理优先顺序，用英文逗号分开，可为空，如”qpay,baidu”
	std::vector<int> agentpecent;    //广告出现概率百分比，安卓默认0，苹果默认100
	std::unordered_map<std::string, std::string> extraparam;  //其它配置信息
	
public:
	ADPosition();

	void setAgent(const std::string& strAgent);
	void setAgentPercent(const std::string& strAgentPercent);

	std::string getValue(const std::string& key);
	void setValue(const std::string& key, const std::string& value);
};

class VIGAME_DECL ADPositionList : public std::vector<std::shared_ptr<ADPosition>>
{
public:
	std::shared_ptr<ADPosition> getAdPosition(std::string adPositionName);
};

NS_VIGAME_AD_END
