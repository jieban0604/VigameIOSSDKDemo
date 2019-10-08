#pragma once

#include "pay/macros.h"
#include "core/macros.h"
#include "PayDefine.h"
#include <string>
#include <unordered_map>

NS_VIGAME_PAY_BEGIN

class VIGAME_DECL PayParams
{
private:
	int payTimes;
	int payType;
	int payId;
	int payPrice;
	std::string payCode;
	std::string payDesc;
	int payResult;
	std::string tradeId;
	std::string reason;//支付后弹出提示
	std::string reasonCode;//支付结果代码
	int giftCoinNum;
	float giftCoinPercent;
	float discount;
	std::string userdata;//用户数据
public:
	PayParams();

	int getPayTimes() const;
	void setPayTimes(int payTimes);

	int getPayType() const;
	void setPayType(int payType);

	int getPayId() const;
	void setPayId(int payId);

	int getPayPrice() const;
	std::string getPayPriceStr() const;
	void setPayPrice(int payPrice);

	std::string getPayCode() const;
	void setPayCode(std::string payCode);

	std::string getPayDesc() const;
	void setPayDesc(std::string payDesc);

	int getPayResult() const;
	void setPayResult(int payResult);

	std::string getTradeId() const;
	void setTradeId(std::string tradeId);

	std::string getReason() const;
	void setReason(std::string reason);

	std::string getReasonCode() const;
	void setReasonCode(std::string reasonCode);

	int getGiftCoinNum() const;
	void setGiftCoinNum(int giftCoinNum);

	float getGiftCoinPercent() const;
	void setGiftCoinPercent(float giftCoinPercent);

	float getDiscount() const;
	void setDiscount(float discount);

	std::string getUserdata();
	void setUserdata(std::string var);//最长16个字符

//#if (VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_ANDROID)
	std::unordered_map<std::string, std::string> getValueMap();

	static PayParams generateByValueMap(std::unordered_map<std::string, std::string> valueMap);
//#endif
};

NS_VIGAME_PAY_END