#pragma once

#include "pay/PayManagerImpl.h"

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_WIN32

NS_VIGAME_PAY_BEGIN

class PayManagerImplWin32 : public PayManagerImpl
{
private:
	std::shared_ptr<FeeInfo> m_pFeeInfoWin32;
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
	virtual bool openAppraise() override;//打开用户评价
};

NS_VIGAME_PAY_END

#endif