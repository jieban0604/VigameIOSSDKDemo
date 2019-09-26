#pragma once

#include "pay/macros.h"
#include "FeeItem.h"
#include <list>
#include <map>
#include <memory>

NS_VIGAME_PAY_BEGIN

class VIGAME_DECL FeeInfo
{
private:
	std::map<std::string, std::string> m_feeInfoValues;
	std::list<std::shared_ptr<FeeItem>> m_feeItems;

	//非接口,勿调用
public:
	FeeInfo() = default;
	~FeeInfo() = default;

	static std::shared_ptr<FeeInfo> parseFeeData(std::string strFeeData);
	void insertFeeItems(std::shared_ptr<FeeItem> feeItem);

	//接口函数
public:
	std::list<std::shared_ptr<FeeItem>> getFeeItems() const;
	FeeItem* getFeeItem(int id) const;
	FeeItem* getFeeItemByCode(std::string code) const;
	FeeItem* getFeeItem(int id, int price) const;
	int getFeePriceByID(int id) const;
	std::map<std::string ,std::string> getValues();
	const char* getValueForKey(const char* pKey) const;
};

NS_VIGAME_PAY_END