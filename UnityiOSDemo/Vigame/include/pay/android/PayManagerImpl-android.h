#pragma once

#include "pay/PayManagerImpl.h"

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_ANDROID

NS_VIGAME_PAY_BEGIN

class PayManagerImplAndroid : public PayManagerImpl
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
	virtual bool openMarket(std::string pkgName) override;
private:
	std::string m_qpay;
};

NS_VIGAME_PAY_END

#endif