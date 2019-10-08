#pragma once

#include "ad/ADManagerImpl.h"

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_ANDROID

NS_VIGAME_AD_BEGIN

// #define AD_ParamKey_ADKey          "adKey"
// #define AD_ParamKey_ADStatus       "adStatus"
// #define AD_ParamKey_ADFromName     "adFromName"
// #define AD_ParamKey_ADTypeName     "adTypeName"
// #define AD_ParamKey_ADAgentName    "adAgentName"
// #define AD_ParamKey_APPID          "appid"
// #define AD_ParamKey_CODE           "code"
// #define AD_ParamKey_SID            "SID"
// #define AD_ParamKey_APIUrl         "apiurl"
// #define AD_ParamKey_OpenParam      "openParam"
// 
// class ADParam : public std::map<std::string, std::string>
// {
// public:
// 	ADParam(){}
// 	ADParam(ADSourceItem* pADItem);
// 	void put(const char* pKey, int value);
// 	void put(const char* pKey, const char* pValue);
// 	std::string get(std::string key);
// };

class ADManagerImplAndroid : public ADManagerImpl
{
public:
	virtual void init() override;
	virtual std::string getSupportAgents() override;
	//virtual void setProperty(const std::string& propertyName, const std::string& value) override;
	virtual void loadAdSourceOnPlatform(ADSource* adSource) override;
	virtual void loadAdOnPlatform(ADSourceItem* adSourceItem) override;
	virtual void openAdOnPlatform(ADSourceItem* adSourceItem, int openParam, int width, int height, int x, int y) override;
	virtual void closeAdOnPlatform(ADSourceItem* adSourceItem) override;
	virtual void checkAdOnPlatform(ADSourceItem* adSourceItem) override;//手动检查广告状态
    virtual void closeAllBanner() override;
    virtual std::pair<float, float> getScreenSize()override;
private:
	void installPlugins();
};

NS_VIGAME_AD_END

#endif
