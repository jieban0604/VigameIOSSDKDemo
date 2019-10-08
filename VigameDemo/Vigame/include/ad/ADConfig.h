#pragma once

#include "ADSource.h"
#include "ADPosition.h"
#include <memory>
#include <boost/property_tree/xml_parser.hpp>

NS_VIGAME_AD_BEGIN

class ADConfig
{
public:
	std::string m_config;
	ADSourceList m_adSourceList;          //所有广告源
	ADPositionList m_adPositionList;      //所有游戏广告位
	int m_videoLimitNum;                  //广告系统控制的视频广告每日限制次数

	int m_debug;
	int m_update;
	int m_clickLimitNum;
	int m_plaqueLimitInterval;//插屏广告展示时间间隔
	int m_splashLimitInterval;//闪屏广告展示时间间隔
	int m_bannerUpdateInterval;//banner广告强制刷新时间

	int m_adOpenLimitInterval; //广告展示时间间隔 除banner外 上一个广告关闭到下一个广告打开间隔时间

	std::string m_md5;
public:
	ADConfig();
	~ADConfig();
	static std::shared_ptr<ADConfig> createFromXml(const std::string& config);

	bool isConfigEqual(std::shared_ptr<ADConfig> right);

private:
	bool parseAdConfigXml(const std::string& config);
	bool parseAdSources(const boost::property_tree::ptree& adsourcesPtree);
	bool parseAdPositions(const boost::property_tree::ptree& adpositionsPtree);
};

NS_VIGAME_AD_END
