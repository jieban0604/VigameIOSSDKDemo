#pragma once

#include "pay/macros.h"
#include <unordered_map>
#include <memory>

NS_VIGAME_PAY_BEGIN

typedef std::unordered_map<std::string, int> PayTypeButton;
typedef std::unordered_map<int, std::shared_ptr<PayTypeButton>> PayTypeButtons;

class PayButton
{
	std::shared_ptr<PayTypeButton> m_globlePayTypeButton;
	std::shared_ptr<PayTypeButtons> m_payTypeButtons;

public:
	PayButton();
	~PayButton();

	static PayButton* getInstance();

	void init();

	void loadConfig();

	//获取支付按钮显示类型  0:购买 1:领取
	int getButtonType(int id);
private:
	std::string getPayTypeString();
	void loadConfig(const std::string& config);
};

NS_VIGAME_PAY_END
