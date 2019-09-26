
#import "AdBridge.h"

#import "IOSLoader.h"
//
//#include "vigame_core.h"
////广告
#include "vigame_ad.h"
////统计
#import "vigame_tj.h"
////支付
#import "vigame_pay.h"

extern "C"
{
 static bool isFistOpenAD = true;
  
	/// <summary>
    /// 打开广告
    /// </summary>
    /// <param name="adName">广告名</param>
    void OpenAd(const char* adName)
    {
        //保存播放视频的名称
        string str = adName;

        //vigame::ad::ADManager::openAd(adName, AD_Callback_OpenResult openResultCallback)
        //打开一个视频广告 && 监听是否视频播放成功
        vigame::ad::ADManager::openAd(adName,[=](vigame::ad::ADSourceItem* adSourceItem, int result){
            char param[64] = {0};
            if (result==0)
            {
                /*打开视频成功*/
                sprintf(param, "%s_video_success",str.c_str());
            }
            else
            {
                /*打开视频失败*/
                sprintf(param, "%s_video_fail",str.c_str());
            }
            printf("%s\n",param);
            UnitySendMessage("ADManager", "VideoCallBack" ,param);
        });
        // 如果是第一次打开，改变状态？
        //
        if(isFistOpenAD)
        {
            isFistOpenAD = false;
            vigame::ad::ADManager::setAdStatusChangedCallback([=](vigame::ad::ADSourceItem* adSourceItem){
                std::string type = adSourceItem->adSourcePlacement->type;
                int stute = adSourceItem->getStatus();
                if (stute == 9 && type == "plaque") {
                    UnitySendMessage("ADManager", "VideoCallBack" ,"false");
                }
            });
        }
     }
   void OpenYSBanner(const char* adName,int width,int height, int x,int y)
    {
        NSLog(@"width = %d height = %d x=%d y= %d",width,height,x,y);
        CGFloat kScreenScale = (NSInteger)[UIScreen mainScreen].scale;
        CGSize size = [UIScreen mainScreen].bounds.size;
        if ((NSInteger)size.height==736) {
            kScreenScale/=1.15;
        }
        // 打开广告 Banner 广告同时设置size
        vigame::ad::ADManager::openAd(adName, width/kScreenScale, height/kScreenScale, x/kScreenScale, y/kScreenScale);

//       CGSize size = [UIScreen mainScreen].bounds.size;
        
//        int addNumber = 330;
//        NSLog(@"%.2f,%2f",size.width,size.height);
//        if (size.width<=375)
//        {
//            if (size.height != 812)
//            {
//                addNumber = 240;
//            }
//        }
//
//        if (size.width==414 && size.height ==736)
//        {
//            addNumber = 240;
//        }
//        int bx =  x*size.width/640.0;
//        int by =  (y+addNumber)*size.height/1136.0;
//
//        vigame::ad::ADManager::openAd(adName, size.width*1.8, size.width*1.8 *height/width, bx+15, by);

    }
    
    //关闭广告
    void CloseAd(const char* adName)
    {
        vigame::ad::ADManager::closeAd(adName);
    }

	/// <summary>
    /// 检查视频广告是否准备完成
    /// </summary>
    /// <param name="adName">视频广告名</param>
    void IsAdReady(const char* adName)
    {
        bool result = vigame::ad::ADManager::isAdReady(adName);
        char param[64] = {0};
        if (result)
        {
            sprintf(param, "%s_ready_success",adName);
        }
        else
        {
            sprintf(param, "%s_ready_fail",adName);
        }
        printf("%s\n",param);
        UnitySendMessage("ADManager", "AdCheckCallBack" ,param);
    }

//    void OpenVideo(const char* adName)
//    {
//        
//    }
    //手机振动
    void ShockPhone()
    {

    }
	
	//投诉按钮点击事件
	void OpenFeedback()
	{
        vigame::feedback::open();
	}

    void setFirstLaunchEvent(const char* eventId0, const char* eventId1, const char*eventId2, const char* eventId3){
        std::unordered_map<std::string, std::string> attributes;

        attributes.insert(std::make_pair(eventId0, "0"));
        attributes.insert(std::make_pair(eventId1, "0"));
        attributes.insert(std::make_pair(eventId2, "0"));
        attributes.insert(std::make_pair(eventId3, "0"));
        vigame::tj::DataTJManager::setFirstLaunchEvent(attributes);
    }
    
    //统计自定义事件
    void TJCustomEvent(const char* eventId)
    {
        vigame::tj::DataTJManager::event(eventId);
    }
    
    void TJCustomEvent4(const char* eventId, const char* model, const char*eventId1, int num) {
        
        std::unordered_map<std::string, std::string> attributes;

        attributes.insert(std::make_pair(model, eventId1));

        vigame::tj::DataTJManager::event(eventId, attributes, num);
    }
    

    //统计自定义事件
    void TJCustomEvent2(const char* eventId,const char* label)
    {
        vigame::tj::DataTJManager::event(eventId,label);
    }

    void TJStartLevel(const char* level)
    {
        vigame::tj::DataTJManager::startLevel(level);
    }
    
    void TJFinishLevel(const char* level)
    {
        vigame::tj::DataTJManager::finishLevel(level);
    }
    
    void TJFailLevel(const char* level)
    {
        vigame::tj::DataTJManager::failLevel(level);
    }
    
    void SetGameName(const char *name){
        vigame::CoreManager::setGameName(name);
    }
    
    //支付
    void OrderPay(int payId)
    {
        vigame::pay::PayManager::orderPay(2003);
    }
    
    //支付
    void OrderPay2(int payId,const char * userData)
    {
        vigame::pay::PayManager::orderPay(payId,userData);
    }
    
    //支付
    void OrderPay3(int payId,int price,const char * userData)
    {
        vigame::pay::PayManager::orderPay(payId,price,userData);
    }

    //使用兑换码
    void UseCDKey(const char* dhm)
    {

    }

    //获取礼包参数控制
    int GetGiftCtrlFlagUse(int giftId)
    {
        return 1;
    }

    //打开活动页面
    void OpenActivityPage()
    {

    }

    //打开公告
    void OpenActivityNotice()
    {

    }
    
    //打开排行旁
    void OpenRank()
    {
        
    }
    
    void setOnPayFinishCallback(){
        
        vigame::pay::PayManager::setOnPayFinishCallback([=](vigame::pay::PayParams params){
            
            char param[64] = {0};
            if (params.getPayResult() == vigame::pay::PAY_RESULT::PAY_RESULT_SUCCESS)
            {
                /*充值成功*/
                sprintf(param, "%d_%s",params.getPayId(),params.getUserdata().c_str());
                UnitySendMessage("ADManager", "VideoCallBack" ,param);
            }
        });
    }
    //打开用户协议
    void OpenUserAgreement()
    {
        
    }
    void getProjectid()
    {
//        NSString *projectid = [IOSLoader getProjectId];
//        UnitySendMessage("MainSetSceneID", "SetProjectID", [projectid UTF8String]);
    }
    
    void PushLocalNotification(const char* alerBoday,long fireDate){
//        string str = alerBoday;
//        std::unordered_map<std::string, std::string> userinfo;
//
//        vigame::notification::notify(str, fireDate, vigame::notification::kNotifyUnitDay, userinfo);
    }
    
    //评分
    void GetStartAppraise(){
//        vigame::InAppAppraise::startAppraise();
    }
}

