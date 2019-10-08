#pragma once

#include "pay/macros.h"

NS_VIGAME_PAY_BEGIN

enum PAY_OPERATOR{
	PAY_Operator_CMCC = 1,
	PAY_Operator_UniCom,
	PAY_Operator_Telecom,
};

enum PAY_TYPE {
	PAY_TYPE_FREE = -1,
	PAY_TYPE_NOFEE = 0,
	/**********运营商计费--BEGIN***********/
	PAY_TYPE_OPERATOR_BEGIN = 1,
	PAY_TYPE_QPAY = PAY_TYPE_OPERATOR_BEGIN,
	PAY_TYPE_MM = 2,
	PAY_TYPE_CMGAME = 3,
	PAY_TYPE_UNI = 4,
	PAY_TYPE_UNIWo = 5,
	PAY_TYPE_CTEStore = 6,
	PAY_TYPE_Egame = 7,
	PAY_TYPE_Telecom = 9,
	PAY_TYPE_OPERATOR_END = PAY_TYPE_Telecom,
	/**********运营商计费--END***********/
	PAY_TYPE_AliPay = 10,
	PAY_TYPE_WXPay = 11,
	PAY_TYPE_Market = 12,//渠道市场支付
	PAY_TYPE_NetPay = 13,
	PAY_TYPE_IOS = 30,
	/**********渠道计费--BEGIN***********/
	PAY_TYPE_CHANNEL_BEGIN =100,
	PAY_TYPE_Amigo = PAY_TYPE_CHANNEL_BEGIN,
	PAY_TYPE_Duoku = 101,
	PAY_TYPE_Kugou = 102,
	PAY_TYPE_360 = 103,
	PAY_TYPE_OPPO = 104,
	PAY_TYPE_Anzhi = 105,
	PAY_TYPE_Mi = 106,
	PAY_TYPE_Vivo = 107,
	PAY_TYPE_MiWeChat = 108,
	PAY_TYPE_Meizu = 109,
	PAY_TYPE_UC = 110,
	PAY_TYPE_Midas = 111,
	PAY_TYPE_GooglePlay = 112,
	PAY_TYPE_Huawei = 113,
	PAY_TYPE_YSDK = 114,
	PAY_TYPE_CHANNEL_END = 150,//预留一些
	/**********渠道计费--END***********/
};

enum PAY_RESULT {
	PAY_RESULT_OTHER = -4,//其它
	PAY_RESULT_PAYCODERROR = -3,//计费点错误
	PAY_RESULT_UNINIT = -2,//支付尚未初始化
	PAY_RESULT_ERROR = -1,//支付错误
	PAY_RESULT_SUCCESS = 0,//支付成功
	PAY_RESULT_FAIL = 1,//支付失败
	PAY_RESULT_CANCEL = 2,//支付取消
};


enum GIFT_CTRL_TYPE {
	GIFT_CTRL_PENNY = 1,//1:新手礼包
	GIFT_CTRL_SPEED,//2:快充
	GIFT_CTRL_LIMITED,//3:限时礼包（默认：移动关闭，联通和电信打开）
	GIFT_CTRL_REWARD,//4:过关奖励（默认打开）
	GIFT_CTRL_VIP,//5.Vip礼包
	GIFT_CTRL_BARGAIN,//6.今日特价
	GIFT_CTRL_PRICERITE,//7.实惠大礼包
	GIFT_CTRL_STORE,//8商城
    GIFT_CTRL_NOICEPACK,//9 6元新手礼包
    GIFT_CTRL_THANKSGIVINGPACK // 10, 18元感恩节礼包
};

NS_VIGAME_PAY_END
