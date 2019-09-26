#pragma once

#include "core/macros.h"
#include <functional>
NS_VIGAME_BEGIN

class VIGAME_DECL CoreManager
{
public:
	static void init();

	static void onExit();

	static void setRewardCallback(const std::function<void(std::string)>& callback);

	static void giveReward(std::string value);
    
    //公告中 参加比赛的回调
    static void setJumpToCallback(const std::function<void(std::string)>& callback);
    static void jumpTo(std::string value);
	static void setActive(int flag);
	static void setGameName(std::string gameName);
	static std::string getGameName();
private:
	static int resumeTime;
	static std::string gameName;
};

NS_VIGAME_END
