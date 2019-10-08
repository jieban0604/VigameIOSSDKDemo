#pragma once

#include "pay/macros.h"
#include "core/macros.h"
#include "core/MmChnlManager.h"
#include "core/base/log.h"

#include "PayDefine.h"
#include "FeeItem.h"
#include "FeeInfo.h"
#include "PayParams.h"

#include <string>
#include <map>
#include <chrono>
#include <set>
#include <vector>

NS_VIGAME_PAY_BEGIN

class PayManagerImpl
{
protected:
	
	std::map<int, std::shared_ptr<FeeInfo>> m_feeInfoMaps; //计费类型、计费信息
	std::map<int,int> m_remove_feeTypes; //计费类型
	std::function<void()> m_onGameExit;
	std::function<void(PayParams payParams)> m_onPayFinishCallback;
	std::map<int, std::function<void(PayParams payParams)> > m_PayCallbacks;
	std::function<void()> m_onPayFeeInfoChangedCallback;
	std::function<void(PayParams payParams)> m_onGotInventoryCallback;
	std::chrono::milliseconds m_giftCtrlStartTime;
public:
	PayManagerImpl();
	~PayManagerImpl() = default;
	static PayManagerImpl* getInstance();
	virtual void init();
	virtual void initConfig();

	virtual int getPayOperator() const = 0;//获取运营商类型
	virtual int getMarketType() const = 0;//获取当前APP应用市场类型,暂用PayType枚举类定义
	virtual int getDefaultPayType() const = 0;//获取默认计费类型
	virtual FeeInfo* getDefaultFeeInfo() const;//获取默认计费信息
	std::set<int> getDefaultPayTypes();
	virtual FeeInfo* getFeeInfo(int payType) const;//根据计费类型获取计费信息

	virtual void setPayFeeInfoChangedCallback(const std::function<void()> &onPayFeeInfoChangedCallback);
	virtual void setOnPayFinishCallback(const std::function<void(PayParams payParams)> &onPayFeeInfoChangedCallback);
	virtual int addOnPayFinishCallback(const std::function<void(PayParams payParams)> &onPayFeeInfoChangedCallback);
	virtual void removeOnPayFinishCallback(int functionId);
	virtual void setOnGotInventoryCallback(const std::function<void(PayParams payParams)> &onGotInventoryCallback);

	virtual int getGiftCtrlFlagUse(int ctrl);//返回可以直接使用的控制符
	virtual bool isCtrlGiftEnable();//是否可弹出礼包
	virtual int getGiftCtrlFlag(int ctrl);//获取弹出礼包的类型(配置文件中的原始值)
	
	virtual void orderPay(int id, std::string userdata);
	virtual void orderPay(int id, int price,std::string userdata);
	virtual void orderPay(int id, int price, int payType, std::string userdata);
	virtual void orderPay(PayParams& payParams) = 0;
	virtual void orderPayByType(int id,int type, std::string userdata);

	virtual bool isMoreGame() const = 0;//是否支持更多游戏
	virtual void openMoreGame() = 0;//打开更多游戏

	virtual bool isExitGame() const = 0;//是否支持退出
	virtual void openExitGame() = 0;//调用退出
	virtual void setOnGameExit(const std::function<void()> &onGameExitCallback);//设置当应用退出时游戏退出的回调

	virtual void onMMChnlChanged(MMChnl* mmChnl);

	virtual void insertFeeInfo(int payType, std::shared_ptr<FeeInfo> feeInfo);
	virtual void removeFeeInfo(int payType);

	virtual void onPayFeeInfoChanged();
	virtual void onPayFinish(PayParams& payParams);
	virtual void onGotInventoryFinish(std::unordered_map<std::string, std::string> mSkus);

	virtual void onGameExit();
	
	virtual int getButtonType(int id);//获取支付按钮显示类型  0:购买 1:领取

	virtual bool openAppraise()=0;//打开用户评价

	virtual bool openMarket(std::string pkgName);//打开市场上的其他应用
};


NS_VIGAME_PAY_END