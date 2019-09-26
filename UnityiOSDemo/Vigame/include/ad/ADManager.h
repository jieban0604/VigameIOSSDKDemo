#pragma once

#include "ADSourceItem.h"
#include "ADDefine.h"
#include <string>
#include <functional>

NS_VIGAME_AD_BEGIN

// typedef std::function<void(ADSourceItem* adSourceItem, int type, int num, std::string reason)> AD_Callback_AddGameCoin;
// typedef std::function<void(ADSourceItem* adSourceItem)> AD_Callback_ADStatusChanged;
// typedef std::function<void(bool isReady)> AD_Callback_ADReadyChanged;
// typedef std::function<void(ADSourceItem* adSourceItem, int result)> AD_Callback_OpenResult;

class VIGAME_DECL ADManager
{

public:
	static void init();

	//0:普通banner广告 1:可自动隐藏banner广告(仅唯变广告)
	static int getBannerType();
    static std::pair<float, float> getScreenSize();
	static void setBannerType(int bannerType);
	static void setBannerAlignment(BannerVAlignment valign, BannerHAlignment halign);
	static void setAdStatusChangedCallback(const AD_Callback_ADStatusChanged& callback);   //设置广告加载完后的回调
	static void setAddGameCoinCallback(const AD_Callback_AddGameCoin& callback);          //设置增加钻石回调
	static void setAwakenCallback(const AD_Callback_Awaken& callback);

	static void addAdReadyChangedCallback(const std::string& adPositionName, const AD_Callback_ADReadyChanged& callback); //增加广告就绪状态回调
	static void removeAdReadyChangedCallback(const std::string& adPositionName);   //移除广告就绪状态回调

	//增加广告位监听事件
	static void addAdPositionListener(const std::string& adPositionName, const AdPositionListener& callback);

	//移除广告位监听事件
	static void removeAdPositionListener(const std::string& adPositionName);

	static bool isAdTypeExist(const std::string& adTypeName);

	static bool isAdReady(const std::string& adPositionName);//检查游戏广告位是否存在加载成功的广告
	
	static bool isAdReady(const std::string& adPositionName, const std::string& type);

	static bool isAdOpen(const std::string& adPositionName);
	
	static bool isAdOpened(); //插屏或者视频是否是打开状态
	//打开广告
	//positionName             游戏广告位名
	//openResultCallback       打开广告后回调
	//openParam                打开广告参数，默认0  (积分墙：0:仅打开积分墙, 1:使用积分墙  2:打开并使用积分墙)
	static void openAd(const std::string& adPositionName);
    
    static void openAd(const std::string& adPositionName, int width, int height, int x, int y);

	static void openAd(const std::string& adPositionName, AD_Callback_OpenResult openResultCallback);

	static void openAd(const std::string& adPositionName, int openParam);

	static void openAd(const std::string& adPositionName, int openParam, AD_Callback_OpenResult openResultCallback);
	
	//关闭广告
	static void closeAd(const std::string& positionName);

	static std::string getAdPositionParam(const std::string& adPositionName, const std::string& valuename);

	static int getVideoLimitOpenNum(); //获取可打开视频广告次数  -1无限制

	//设置客户要求的每日视频限制数
	static void setCustomVideoLimitNum(int num);

	static bool isAdBeOpenInLevel(const std::string& adPositionName, int lv);
};

NS_VIGAME_AD_END
