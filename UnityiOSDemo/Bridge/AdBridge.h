

extern "C"
{
	/// <summary>
    /// 打开广告
    /// </summary>
    /// <param name="adName">广告名</param>
    void OpenAd(const char* adName);
    
    
    /**
     打开原生banner广告

     @param adName 广告位名称
     @param x  左上角x坐标
     @param y  左上角y坐标
     @param width  宽
     @param height 高
     */
    void OpenYSBanner(const char* adName,int width,int height, int x,int y);
    
    //void OpenVideo(const char* adName);
	/// <summary>
    /// 打开视频广告
    /// </summary>
    /// <param name="videoName">视频广告名</param>
    void CloseAd(const char* videoName);
    
	/// <summary>
    /// 检查广告是否准备完成
    /// </summary>
    /// <param name="adName">视频广告名</param>
    void IsAdReady(const char* adName);
    
    //手机振动
    void ShockPhone();
	
	//投诉按钮点击事件
	void OpenFeedback();
    
    //统计自定义事件
    void TJCustomEvent(const char* eventId);
    
    //调用一次事件
    void setFirstLaunchEvent(const char* eventId0, const char* eventId1, const char*eventId2, const char* eventId3);
    
    //统计自定义事件
    void TJCustomEvent2(const char* eventId,const char* label);
    
    //统计自定义事件
//    void TJCustomEvent3(const char* eventId,const char* label);
    
    void TJCustomEvent4(const char* eventId, const char* model, const char*eventId1, int num);
    
    void TJStartLevel(const char* level);
    
    void TJFinishLevel(const char* level);
    
    void SetGameName(const char *name);
    
    //支付
    void OrderPay(int payId);
    
    //支付
    void OrderPay2(int payId,const char * userData);
    
    //支付
    void OrderPay3(int payId,int price,const char * userData);
    
    //使用兑换码
    void UseCDKey(const char* dhm);
    
    //获取礼包参数控制
    int GetGiftCtrlFlagUse(int giftId);
    
    //打开活动页面
    void OpenActivityPage();
    
    //打开公告
    void OpenActivityNotice();
    
    //打开排行旁
    void OpenRank();
    
    //打开用户协议
    void OpenUserAgreement();
    
    //添加本地推送
    void PushLocalNotification(const char* alerBoday,long fireDate);
    
    //评分
    void GetStartAppraise();
}





