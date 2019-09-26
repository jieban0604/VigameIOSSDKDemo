#pragma once

#include "pay/macros.h"
#include <string>

NS_VIGAME_PAY_BEGIN

typedef enum {
	RESULT_OK,
	RESULT_FAILED,
	RESULT_CANCLE,

}E_RESULT_TYPE;

// typedef enum{
// 	 PAY_TYPE_SMS	= 0,//0:手机短信
// 	 PAY_TYPE_ALIX	= 1,//1:支付宝
// 	 PAY_TYPE_UP	= 2,//2:银联
// 	 PAY_TYPE_TEN	= 3,//3:财付通
// 	 PAY_TYPE_YEE	= 4,//4:易宝 
// 	 PAY_TYPE_CMGB	= 5,//5:移动游戏基地
// 	 PAY_TYPE_MM	= 6,//6:移动MM
// 	 PAY_TYPE_UNION = 7,//7:联通沃商店SDK
// 	 PAY_TYPE_EMP	= 8,//8:电信天翼空间SDK
// 	 PAY_TYPE_91	= 9,//9:91无线SDK
// 	 PAY_TYPE_BAIDU	= 10,//10:百度SDK	    
// 	 PAY_TYPE_MM_SMS= 11,//11:移动MM弱联网
// 	 PAY_TYPE_XIAOMI= 12,//小米sdk
// 	 PAY_TYPE_EGAME = 13,//电信爱游戏
// 	 PAY_TYPE_UNION_CENTER = 14,//联通游戏中心
// 	 PAY_TYPE_WX = 15,//微信支付
// }E_PAY_TYPE;

class OrderLog {
	std::string writablePath;
public:
	static OrderLog* getInstance();

	//************************************
	// Method:    recordOneLog
	// FullName:  OrderLog::recordOneLog
	// Access:    public 
	// Returns:   void
	// Qualifier:
	// Parameter: int payType 支付方式，参考E_PAY_TYPE
	// Parameter: string paycode 计费代码
	// Parameter: int price 价格，单位(分)
	// Parameter: int result 参考E_RESULT_TYPE
	// Parameter: string retCode 错误码，如203
	//************************************
	void recordOneLog(int payType, const std::string& paycode, int price, int result, const std::string& retCode);
	//************************************
	// Method:    postToNet
	// FullName:  OrderLog::postToNet
	// Access:    public 
	// Returns:   int 1成功 0失败
	// Qualifier:
	//************************************
	void postToNet();
protected:
	std::string readLog();
	void clearLog();
private:
	int posts();
};

NS_VIGAME_PAY_END