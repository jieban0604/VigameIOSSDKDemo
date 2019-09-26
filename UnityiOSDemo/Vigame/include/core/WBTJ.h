#ifndef __WBTJ__H__
#define __WBTJ__H__
#include "tj/macros.h"
#include <unordered_map>
#include <string>

NS_VIGAME_BEGIN

class VIGAME_DECL WBTJ
{
public:
	static WBTJ* getInstance();
	void splashReport();//启动页上报
	void adStatusReport(std::string sid, std::string adPositionName, int status, int flag, std::string ad_type, std::string param); // 广告请求 / 展示 / 点击  上报
	void adStatusReportDelay(); //广告请求 / 展示 / 点击  上报  延迟上报
	void adConfigReport(int);	//广告配置获取成功后的上报 (1:点击icon启动时上报 2:广告配置获取成功后上报 3:加载广告源成功后上报)
	void getReport(std::string url);// http get请求
	virtual void dataEyeShow(std::string sid, std::string adPositionName, std::string ad_type, std::string param) = 0;
	virtual void fbClicked() = 0;
};

NS_VIGAME_END

#endif