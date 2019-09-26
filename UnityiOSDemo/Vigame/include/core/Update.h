#ifndef _VIGAME_UPDATE_H__
#define _VIGAME_UPDATE_H__
#include "macros.h"
#include <string>
#include <functional>
#include <unordered_map>
NS_VIGAME_BEGIN

enum class UpdateFlag {

	NO_UPDATE = 0,

	UPDATE_FOURCED = 1,//强制更新
	
	UPDATE_SELECTION =2,//用户选择更新

};

class UpdateInfo {

public:
	std::string version;
	std::string downUrl;
	std::string tips;
	UpdateFlag flag;

	UpdateInfo()
	:flag(UpdateFlag::NO_UPDATE){
	}
};

class Update {

	static UpdateInfo _updateInfo;
	
	static void _check();

	static void dealWithOnPlatform(const std::unordered_map<std::string, std::string>& params);

public:

	static void check();

	static UpdateInfo getUpdateInfo();
};

NS_VIGAME_END











#endif // _VIGAME_UPDATES_H__
