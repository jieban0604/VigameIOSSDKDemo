#pragma once

#include "pay/macros.h"
#include "core/macros.h"
#include <string>

NS_VIGAME_PAY_BEGIN

class VIGAME_DECL FeeItem
{
private:
	int id;
	int price;
	std::string code;
	std::string desc;
	float giftCoinPercent;
public:
	FeeItem(int id, int price, std::string code, std::string desc,float giftCoinPercent);
	int getID() const;
	int getPrice() const;
	std::string getCode() const;
	std::string getDesc() const;
	float getGiftCoinPercent() const;
};

NS_VIGAME_PAY_END