#pragma once

#include "pay/PayManagerImpl.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_MAC ||  VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_IOS

NS_VIGAME_PAY_BEGIN

class PayManagerImplApple : public PayManagerImpl
{
public:
	virtual void init() override;
	virtual void onMMChnlChanged(MMChnl* mmChnl) override;
	virtual int getPayOperator() const override;
	virtual int getMarketType() const override;
	virtual int getDefaultPayType() const override;
	virtual void orderPay(PayParams& payParams) override;
	virtual bool isMoreGame() const override;
	virtual void openMoreGame() override;
	virtual bool isExitGame() const override;
	virtual void openExitGame() override;
	virtual bool openAppraise() override;
    
    void setPayResult(PayParams param, int result);
};

NS_VIGAME_PAY_END

#endif
