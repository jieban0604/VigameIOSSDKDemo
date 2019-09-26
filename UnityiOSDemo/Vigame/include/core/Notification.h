#pragma once
#include "macros.h"
#include <string>
#include <unordered_map>
NS_VIGAME_BEGIN

namespace notification {


    typedef enum{
        //不间隔提示
        kNotifyUnitNull = 1,
        kNotifyUnitEra = 1 << 1,
        kNotifyUnitYear = 1 << 2,
        kNotifyUnitMonth = 1 << 3,
        //每天提示
        kNotifyUnitDay = 1 << 4,
        kNotifyUnitHour = 1 << 5,
        kNotifyUnitMinute = 1 << 6,
        kNotifyUnitSecond = 1 << 7,
        kNotifyUnitWeek = 1 << 8,
//         kNotifyUnitWeekday = 1 << 9,
//         kNotifyUnitWeekdayOrdinal = 1 << 10,
//         kNotifyUnitQuarter = 1 << 11,
//         kNotifyUnitWeekOfMonth = 1 << 12,
//         kNotifyUnitWeekOfYear = 1 << 13,
//         kNotifyUnitYearForWeekOfYear = 1 << 14,
    }NotifyInteeval;
    
	//************************************
	// Method:    notify
	// FullName:  vigame::notification::notify
	// Access:    public 
	// Returns:   void VIGAME_DECL
	// Qualifier:
	// Parameter: std::string alertBody 推送的内容
	// Parameter: long firedate         开始推送的时间1970开始的秒
	// Parameter: NotifyInteeval inteval重复推送的间隔时间
	// Parameter: ::string userdata     推送的自定义数据
    // --------------例子---------------
    // std::map<std::string,std::string> userinfo;
    // userinfo.insert(pair<std::string, std::string>("testKey", "testValue"));
    // int notifyId = vigame::notification::notify("起来领体力", vigame::utils::secondNow(), vigame::notification::kNotifyUnitNull, userinfo);
	//************************************
    unsigned int VIGAME_DECL notify(std::string alertBody,long firedate,NotifyInteeval inteval,std::unordered_map<std::string,std::string> userinfo);


    //************************************
    // Method:    cancel 取消一个一直定时推送的通知
    // FullName:  vigame::notification::cancel
    // Access:    public
    // Returns:   void VIGAME_DECL
    // Qualifier:
    // Parameter: unsigned int Id 推送的id
    //************************************
    void VIGAME_DECL cancel(unsigned int Id);
    
    //************************************
    // Method:    cancleAll 全部取消本地的定时通知(Android暂不支持)
    // FullName:  vigame::notification::cancleAll
    // Access:    public
    //************************************
	void VIGAME_DECL cancelAll();


}

NS_VIGAME_END
