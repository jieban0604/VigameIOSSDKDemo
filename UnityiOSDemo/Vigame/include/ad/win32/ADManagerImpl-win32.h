#pragma once

#include "ad/ADManagerImpl.h"

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_WIN32

NS_VIGAME_AD_BEGIN

class ADManagerImplWin32 : public ADManagerImpl
{
public:
	virtual void init() override;
	virtual std::string getSupportAgents() override;
	//virtual void setProperty(const std::string& propertyName, const std::string& value) override;
	virtual void loadAdSourceOnPlatform(ADSource* adSource) override;
	virtual void loadAdOnPlatform(ADSourceItem* adSourceItem) override;
	virtual void openAdOnPlatform(ADSourceItem* adSourceItem, int openParam, int width, int height, int x, int y) override;
	virtual void closeAdOnPlatform(ADSourceItem* adSourceItem) override;
    virtual void closeAllBanner() override;
	virtual void checkAdOnPlatform(ADSourceItem* adSourceItem) override;//手动检查广告状态
    virtual std::pair<float, float> getScreenSize()override;
};

NS_VIGAME_AD_END

#endif
