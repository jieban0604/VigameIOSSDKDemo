#pragma once

#include "pay/macros.h"
#include "pay/FeeInfo.h"
#include "pay/PayParams.h"
#include <functional>
#include <set>
#include <vector>
NS_VIGAME_PAY_BEGIN

class VIGAME_DECL PayManager
{
public:
	static void init();

	static int getPayOperator();//获取运营商类型
	static int getMarketType();//获取当前APP应用市场类型,暂用PayType枚举类定义
	static int getDefaultPayType();//获取默认计费类型
	static std::set<int> getDefaultPayTypes();//获取所有的默认的计费类型
	static FeeInfo* getDefaultFeeInfo();//获取默认计费信息
	static FeeInfo* getFeeInfo(int payType = 0);//根据计费类型获取计费信息

	static void setPayFeeInfoChangedCallback(const std::function<void()> &onPayFeeInfoChangedCallback);
	static void setOnPayFinishCallback(const std::function<void(PayParams payParams)> &onPayFeeInfoChangedCallback);
	static int addOnPayFinishCallback(const std::function<void(PayParams payParams)> &onPayFeeInfoChangedCallback);
	static void removeOnPayFinishCallback(int functionId);
	//得到已经购买的商品
	static void setOnGotInventoryCallback(const std::function<void(PayParams payParams)> &onGotInventoryCallback);

	static int getGiftCtrlFlagUse(int ctrl);//返回可以直接使用的控制符
	static bool isCtrlGiftEnable();//是否可弹出礼包
	static int getGiftCtrlFlag(int ctrl);//获取弹出礼包的类型(配置文件中的原始值)

	static void orderPay(int id,std::string userdata = "");
	static void orderPay(int id, int price, std::string userdata = "");
	static void orderPay(int id, int price, int payType, std::string userdata = "");

	static void orderPayByType(int id,int type = 0, std::string userdata = "");

	static bool isMoreGame();//是否支持更多游戏
	static void openMoreGame();//打开更多游戏

	static bool isExitGame();//是否支持退出
	static void openExitGame();//调用退出
	static void setOnGameExit(const std::function<void()> &onGameExitCallback);//设置当应用退出时游戏退出的回调

	static int getButtonType(int id);//获取支付按钮显示类型  0:购买 1:领取

	static bool openAppraise();

	static bool openMarket(std::string param);
    
};

NS_VIGAME_PAY_END
