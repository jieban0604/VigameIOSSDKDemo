#pragma once

#include "macros.h"
#include <string>
#include <functional>
#include <vector>

NS_VIGAME_BEGIN



namespace rank {

//一个用户在某一关的表现，存储在我们服务器
class UserRankInfo{
public:
    std::string userid;
    int score;
    //一个用户玩的最高关卡数
    int maxLevel;
};
    
typedef std::function<void(int result, std::vector<UserRankInfo> infoList)> UserRankInfoCallback;

//获取排行榜首页Url
std::string VIGAME_DECL getUrl();

void VIGAME_DECL submit(std::string userId, int level, int score, int usedCoins, int leftCoins, const std::function<void(int result)>& callback, std::string topType = "");//仅提供异步

// 提交排上数据
// 0成功，其他表示失败
// Parameter: int lever 关卡
// Parameter: int score 得分
// Parameter: int usedCoins 消耗钻石
// Parameter: int leftCoins 剩余钻石
void VIGAME_DECL submit(int level, int score, int usedCoins, int leftCoins, const std::function<void(int result)>& callback, std::string topType = "");//仅提供异步

std::string VIGAME_DECL getJsonStringFromFacebookIdList(std::string type,const std::vector<std::string>& userIdList, int level = -1);


    
//打开排行榜页面,返回打开成功或失败
bool VIGAME_DECL open();
    
class Rank{
    public:
        static Rank* getInstance();
        //如果不传任何level ，就是传入-1，会得到一个用户的朋友的玩的最高关卡
        void  getFriendsScoreList(std::string type, std::vector<std::string> userIdList, const UserRankInfoCallback & callback, int level = -1);
        void  removeCallBack();
    private:
        UserRankInfoCallback m_callback;

};
    
}

NS_VIGAME_END
