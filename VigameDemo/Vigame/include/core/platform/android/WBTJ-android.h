#pragma once
#ifndef __WBTJ_ANDROID_H__
#define __WBTJ_ANDROID_H__
#include "core/macros.h"
#include "core/WBTJ.h"
#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_ANDROID
NS_VIGAME_BEGIN
class WBTJAndroid :public WBTJ
{
public:
	virtual void dataEyeShow(std::string sid, std::string adPositionName, std::string ad_type, std::string param) override;
	virtual void fbClicked()override;
};

NS_VIGAME_END
#endif
#endif