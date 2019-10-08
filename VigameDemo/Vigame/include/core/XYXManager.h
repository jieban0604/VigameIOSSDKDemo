#pragma once
#ifndef _CONFIG_MANAGER_H__
#define _CONFIG_MANAGER_H__
#include "core/MmChnlManager.h"
#include "core/macros.h"
#include "core/base/log.h"
#include <string>
#include <vector>
#include <unordered_map>
#include "core/FileUtils.h"
using namespace std;

NS_VIGAME_BEGIN

enum XYXItemType {
	Type_Icon,//普通图标
	Type_Plist,//帧动画
	Type_Spine,//spine补间动画
	Type_Video,
};

class VIGAME_DECL XYXItem {
	public:
private:

	std::unordered_map<string, string> _valueMap;
public:

	std::string getIcon(){ 	return getValue("icon");}

	std::string getImage() { return getValue("image"); }

	std::string getLinkUrl() { return getValue("linkUrl"); }

	std::string getOpen() { return getValue("open"); }
	//用户参数
	std::string getParam() { return getValue("param"); }

	std::string getPlist() { return getValue("plist"); }

	std::string getAtlas() { return getValue("atlas"); }

	std::string getJson() { return getValue("json"); }

	XYXItemType getType();

	std::string getValue(const std::string& key);

	void setValue(const string& key, const string& value);


};

typedef std::vector<XYXItem*> XYXItemList;
typedef std::vector<std::string> GameList;
typedef std::vector<std::string> PositionList;

class VIGAME_DECL XYXConfig {

	bool _loaded;
	XYXItemList _xyxItemList;
	XYXItemList _videoItemList;

	GameList _gameList;
	std::unordered_map<std::string, std::string> _extraParams;
	std::string data;
	PositionList _positionList;
public:

	XYXConfig();

	~XYXConfig();

	bool loadFile(const std::string& filename);
	//bool loadData(const std::string& data);
	XYXItemList* getXYXItemList() {
		return &_xyxItemList;
	}
	XYXItemList* getVideoItemList() {
		return &_videoItemList;
	}
	GameList* getGameList() {
		return &_gameList;
	}
	bool isLoaded() {
		return _loaded;
	}

	std::string getExtraParam(const std::string& key);

	string getAdShowUrl();

	string getAdClickUrl();

	string getData();

	bool checkAndShowIcon();

	bool isPositionEnabled(const std::string& positionName);

};

class VIGAME_DECL XYXManager {

	XYXConfig* _localConfig;
	XYXConfig* _cachedConfig;
	XYXConfig* _remoteConfig;

	vigame::FileUtils* _fileUtils;
	string _storagePath;
	string _cacheConfigPath;
	bool _inited;
public:
	XYXManager();

	~XYXManager();

	static XYXManager* getInstance();
	//本地配置
	XYXConfig* getLocalConfig();
	//缓存配置
	XYXConfig* getCachedConfig();
	//远程下载配置
	XYXConfig* getRemoteConfig();

	XYXConfig* getConfig();
	void onMMChnlChanged(MMChnl* mmChnl);
	void init();

	void exposure(const string& url,const string& icon);

protected:

	void setStoragePath(const std::string& storagePath);
	
	void loadLocalConfig(const string& configFile);

	void downloadRemoteConfig(const char* url);

};

NS_VIGAME_END

#endif//!_CONFIG_MANAGER_H__
