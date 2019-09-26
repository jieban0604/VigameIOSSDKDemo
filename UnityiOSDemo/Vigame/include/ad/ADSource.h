#pragma once

#include "ad/macros.h"
#include <string>
#include <vector>
#include <unordered_map>
#include <memory>

NS_VIGAME_AD_BEGIN

//广告源类
class VIGAME_DECL ADSource
{
public:
	//广告源中广告位信息配置
	class VIGAME_DECL placement
	{
	public:
		std::string type;        //广告类型（splash、banner、plaque、video、wall）
		std::string code;        //广告id，可为空
		std::string limitname;   //指定广告位才能打开，可为空，如” pause, rotary”
		std::unordered_map<std::string, std::string> extraparam;  //额外参数
		std::string ad_sid;        //广告源
		std::string getValue(const std::string& key);//获取额外参数
		void setValue(const std::string& key, const std::string& value);//设置额外参数
		int priority;			   //优先级
		std::unordered_map<std::string, std::string> getValueMap();
	};

public:
	std::string agent;   //广告代理名称
	std::string appid;   //应用id或账户id，可为空
	std::string appkey;  //应用key，可为空
	std::string fixagent; //广告代理名称修正 有些特殊的 agent 会加  '666' 后缀
	std::vector<std::shared_ptr<placement>> placementList;  //全部广告位信息配置
	bool bannerPriorityMode;//是否是优先级模式
	bool plaquePriorityMode;//是否是优先级模式
	bool videoPriorityMode;//是否是优先级模式
	bool msgPriorityMode;//是否是优先级模式
public:
	ADSource();;
	ADSource(std::string agent, std::string appid, std::string appkey);
    

	std::unordered_map<std::string, std::string> getValueMap();
	void insertPlacement(std::shared_ptr<placement> placement);
	bool havePlacement(std::string type);
	std::shared_ptr<placement> getPlacement(std::string type, std::string positionName);
	std::vector<std::shared_ptr<ADSource::placement> > getPlacements(std::string type);
};

//广告源列表
class VIGAME_DECL ADSourceList : public std::vector<std::shared_ptr<ADSource>>
{
public:
	ADSourceList getSourceList(std::string type);//返回有该广告类型的广告源列表
	std::shared_ptr<ADSource> geADSource(std::string agent);//返回指定广告商的广告源
};


NS_VIGAME_AD_END
