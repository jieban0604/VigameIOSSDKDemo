#pragma once

#include "ad/macros.h"
#include "ADDefine.h"
#include "ADCache.h"
#include "ADSource.h"
#include "ADSourceItem.h"
#include "ADPosition.h"
#include "ADConfig.h"
#include "core/MmChnlManager.h"
#include <string>
#include <list>
#include <map>
#include <unordered_map>
#include <chrono>
#include <functional>
#include <mutex>

NS_VIGAME_AD_BEGIN

class ADManagerImpl
{
	friend class ADSourceItem;
private:
    int m_totalDays;
	//AD_Callback_OpenResult m_openResultCallback;  //打开广告回调
	AD_Callback_AddGameCoin m_addGameCoinCallback; //积分墙等广告增加金币
	AD_Callback_ADStatusChanged m_adStatusChangedCallback;//广告状态改变时回调
	AD_Callback_Awaken m_awakenCallback;//唤醒触发的回调
	std::unordered_map<std::string, bool> m_adPositonStatusReady;
	std::unordered_map<std::string, AD_Callback_ADReadyChanged> m_adReadyChangedCallbacks;//广告就绪状态回调
	std::unordered_map<std::string, AdPositionListener> m_adPositionListeners;//所有广告位监听事件
	std::unordered_map<std::string, AD_Callback_OpenResult> m_openResultCallbacks;//广告就绪状态回调
//	int m_Debug; //Debug为1时，只使用本地配置
	//bool m_isConfigInited;
	std::chrono::steady_clock::time_point m_time_begin;
	std::chrono::steady_clock::time_point m_time_plaqueShow;//插屏类型广告展示时间
	std::chrono::steady_clock::time_point m_time_splashShow;//插屏类型广告展示时间
	std::chrono::steady_clock::time_point m_time_adClose;   //广告关闭时的时间

	std::string m_apiGet;
	std::string m_apiResp;
	//ADSourceList m_adSourceList;          //所有广告源
	
	std::shared_ptr<ADConfig> m_adConfigSaved;   //本地存储
	std::shared_ptr<ADConfig> m_adConfigDefault; //本地缺省配置
	std::shared_ptr<ADConfig> m_adConfigNet;     //网络配置
	std::shared_ptr<ADConfig> m_adConfigCurrent; //当前使用配置
	int m_debug;  //Debug为1时，只使用本地配置
	int m_netUpdateTask;    //0任务未开,1任务打开
	//int m_netUpdateSeconds; //网络配置更新间隔
	ADSourceItemList m_adSourceItemList;  //所有广告源条目
	ADSourceItemList m_adSourceItemManualCheckList; //手动检查条目
	//ADPositionList m_adPositionList;      //所有游戏广告位
	ADCacheList m_adCacheList;            //广告缓存列表
	//ADPositionList m_preOpenAdPositionList; //预打开游戏广告位名称
	
	int m_videoDayOpenNum;//视频广告今日打开次数
	std::unordered_map < std::string, std::string > mProperty;//属性

public:
	ADManagerImpl();
	~ADManagerImpl();
	static ADManagerImpl* getInstance();

	virtual void init();

	void initConfig();

	void setBannerType(int bannerType);
	int getBannerType();
	
	void setBannerAlignment(BannerVAlignment valign, BannerHAlignment halign);

	void getBannerAlignment(BannerVAlignment& valign, BannerHAlignment& halign);

	virtual std::pair<float, float> getScreenSize() = 0;

	void setAwakenCallback(const AD_Callback_Awaken& callback);

	void setAdStatusChangedCallback(const AD_Callback_ADStatusChanged& callback); //设置广告加载完后的回调
	void setAddGameCoinCallback(const AD_Callback_AddGameCoin& callback); //设置增加钻石回调

	void addAdReadyChangedCallback(const std::string& adPositionName, const AD_Callback_ADReadyChanged& callback); //增加广告就绪状态回调
	void removeAdReadyChangedCallback(const std::string& adPositionName);   //移除广告就绪状态回调

	//增加广告位监听事件
	void addAdPositionListener(const std::string& adPositionName, const AdPositionListener& callback);

	//移除广告位监听事件
	void removeAdPositionListener(const std::string& adPositionName);

	bool isAdTypeExist(const std::string& adTypeName);

	bool isAdReady(const std::string& adPositionName);//检查游戏广告位是否存在加载成功的广告

	bool isAdReady(const std::string& adPositionName, const std::string& type);

	//广告是否在展示
	bool isAdOpen(const std::string& adPositionName);
	//打开广告
	//positionName             游戏广告位名
	//openResultCallback       打开广告后回调
	//openParam                打开广告参数，默认0  (积分墙：0:仅打开积分墙, 1:使用积分墙  2:打开并使用积分墙)
	void openAd(const std::string& adPositionName);
    
    void openAd(const std::string& adPositionName, int width, int height, int x, int y);

	void openAd(const std::string& adPositionName, AD_Callback_OpenResult openResultCallback);

	void openAd(const std::string& adPositionName, int openParam);

	void openAd(const std::string& adPositionName, int openParam, AD_Callback_OpenResult openResultCallback);
    
    void openAd(const std::string& adPositionName, int openParam, AD_Callback_OpenResult openResultCallback, int width, int height, int x, int y);

	void openAdSourceItem(ADSourceItem* adSourceItem, int openParam, AD_Callback_OpenResult openResultCallback, int width, int height, int x, int y);

	void openAdSourceItemByPosition(std::shared_ptr<ADSourceItem> adSourceItem, int openParam, AD_Callback_OpenResult openResultCallback, int width, int height, int x, int y,const std::string& positionName);

	void reloadFailedAd(std::shared_ptr<ADPosition> adPosition);
	void reloadAllFailedAD();
	void closeAd(const std::string& positionName ,bool bannerFlag = false);

	ADSourceItem* getSourceItemByID(int id);

	std::string getAdPositionParam(const std::string& adPositionName, const std::string& valueName);

	int getVideoLimitOpenNum(); //获取可打开视频广告次数  -1无限制
	int getClickLimitNum();
	//设置客户要求的每日视频限制数
	void setCustomVideoLimitNum(int num);
private:
	std::once_flag loadAdInitial_flag;
	std::once_flag manualCheckAdInitial_flag;
	bool firstLoadConfig;
public:
	void onMMChnlChanged(MMChnl* mmChnl);
	void onAdSourceItemStatusChanged(ADSourceItem* adSourceItem);
	void onAdSourceItemClicked(ADSourceItem* adSourceItem);
	void setApiGet(const std::string& apiGet);
	void setApiResp(const std::string& apiResp);
//	bool parseAdConfigXml(const std::string& config, ADSourceList& adSourceList, ADPositionList& adPositionList, int& videoLimitNum);
//	bool parseAdSourcesXml(void* adsourcesElement, ADSourceList& adSourceList);
//	bool parseAdPositions(void* adpositionsElement, ADPositionList& adPositionList);
	//void loadAdInitial();
	void loadAdConfig(std::shared_ptr<ADConfig> adConfig);
	void loadAd(std::shared_ptr<ADSource> adSource);
	void loadAd(std::shared_ptr<ADSource> adSource, std::string type);
	void loadAd(std::shared_ptr<ADSource> adSource, std::shared_ptr<ADSource::placement> placement);

	void manualCheckAdInitial();
	void setManualCheckAd(ADSourceItem* adSourceItem);

	void addGameCoin(ADSourceItem* adSourceItem, int type, int num, const std::string& reson);//广告请求增加游戏金币
	void openAdResult(ADSourceItem* adSourceItem, int openResult);//打开广告结果
	std::string getPositionName(int sourceItemId);

	void setProperty(const std::string& propertyName, const std::string& value);

	std::string getProperty(const std::string& propertyName);

	virtual void loadAdSourceOnPlatform(ADSource* adSource) = 0;   //加载广告全局配置
	virtual void loadAdOnPlatform(ADSourceItem* adSourceItem) = 0; //加载广告位
	virtual void openAdOnPlatform(ADSourceItem* adSourceItem, int openParam, int width, int height, int x, int y) = 0;
	virtual void closeAdOnPlatform(ADSourceItem* adSourceItem) = 0;

    virtual void closeAllBanner() = 0;
	virtual void checkAdOnPlatform(ADSourceItem* adSourceItem) {};//手动检查广告状态

	virtual std::string getSupportAgents() = 0;
	//判断唤醒能否被打开
	bool isAwakenADSuitable();
	bool isAdOpened();
	bool isAdBeOpenInLevel(const std::string& adPositionName, int lv);
	void awakenGame();
	void setActive(int active);
private:
	//检查广告是否有效
	void checkAdInvalid();

private:
	int mActive;//界面是否是活动的 activity onPause时为0 onResume时为1
	int mTotalSecond;
	bool mAutoBannerFlag;
	bool mBannerShowing;
	int mBannerTimes; //banner广告展示时长
	void updateTimes(); //线程里面更新各种时间

	std::vector<std::string> mBannerAgents;//当前 banner 可打开的其他agents
	ADSourceItem* mBannerAdSourceItem;  //当前展示的banner的广告配置
	std::vector<std::string> randomListByPercent(std::vector<int> , std::vector<std::string>);//按照概率排列列表
	void reOpenFailBanner(); //重新打开banner

	std::shared_ptr<ADSourceItem> getReadyItem(ADPosition* adPosition);
	std::string getDefaultADName(ADSourceItem* item); //获取上报时的广告位名字
	void postADStatus(std::string sid,std::string adPositionName,int status,int flag = 0,std::string ad_type ="",std::string param = "");
public:
	void adTJ(int sourceId,int status ,int flag);
	void selfADShowTJ(int sourceId);
};

NS_VIGAME_AD_END
