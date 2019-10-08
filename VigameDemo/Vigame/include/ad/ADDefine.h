#pragma once

#include "ad/macros.h"
#include <functional>

NS_VIGAME_AD_BEGIN

class ADSourceItem;

typedef std::function<void(ADSourceItem* adSourceItem, int type, int num, std::string reason)> AD_Callback_AddGameCoin;
typedef std::function<void(ADSourceItem* adSourceItem)> AD_Callback_ADStatusChanged;
typedef std::function<void(bool isReady)> AD_Callback_ADReadyChanged;
typedef std::function<void(ADSourceItem* adSourceItem, int result)> AD_Callback_OpenResult;
typedef std::function<void(void)> AD_Callback_Awaken;

enum class AdPositionListenerEvent {
	OnAdOpened,
	OnAdClosed,
	OnAdClicked,
};

enum class BannerVAlignment
{
	TOP,
	CENTER,
	BOTTOM
};

enum class BannerHAlignment
{
	LEFT,
	CENTER,
	RIGHT
};

typedef std::function<void(AdPositionListenerEvent eventId)> AdPositionListener;


NS_VIGAME_AD_END
