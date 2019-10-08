#pragma once

#include "ad/ADManagerImpl.h"

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_MAC ||  VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_IOS

NS_VIGAME_AD_BEGIN

class ADManagerImplApple : public ADManagerImpl
{
public:
	virtual void init() override;
	virtual std::string getSupportAgents() override;
	//virtual void setProperty(const std::string& propertyName, const std::string& value) override;
	virtual void loadAdSourceOnPlatform(ADSource* adSource) override;
	virtual void loadAdOnPlatform(ADSourceItem* adSourceItem) override;
	virtual void openAdOnPlatform(ADSourceItem* adSourceItem, int openParam, int width, int height, int x, int y) override;
	virtual void closeAdOnPlatform(ADSourceItem* adSourceItem) override;
    virtual void checkAdOnPlatform(ADSourceItem* adSourceItem)override;//手动检查广告状态
    virtual void closeAllBanner() override;
    
    virtual std::pair<float, float> getScreenSize()override;
    
    void loadMsg(ADSourceItem* adSourceItem);
    void loadBanner(ADSourceItem* adSourceItem);//
    void loadPlaque(ADSourceItem* adSourceItem);
    void loadVideo(ADSourceItem* adSourceItem);
    void loadSplash(ADSourceItem* adSourceItem);
    
    
    void openMsg(ADSourceItem* adSourceItem, int width, int height, int x, int y);
    void openBanner(ADSourceItem* adSourceItem, int width, int height, int x, int y);
    void openPlaque(ADSourceItem* adSourceItem);
    void openVideo(ADSourceItem* adSourceItem);
    void openSplash(ADSourceItem* adSourceItem);
    
};

NS_VIGAME_AD_END

#endif
