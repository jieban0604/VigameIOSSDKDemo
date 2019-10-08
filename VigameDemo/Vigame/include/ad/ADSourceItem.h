#pragma once

#include "ad/macros.h"
#include "ADSource.h"
#include <string>
#include <unordered_map>
#include <memory>
#include <functional>
#include <mutex>

NS_VIGAME_AD_BEGIN

//一个广告源条目
class VIGAME_DECL ADSourceItem
{
public:
	enum staus_type
	{
		Generated,       //生成广告源条目后，还未调用平台加载广告的状态
		Loading,         //正在加载广告(调用安卓平台/IOS平台加载广告)
		LoadUnknow,      //广告加载未知状态(未知状态也算成功)
		LoadSuccess,     //广告已加载完毕，可以打开广告
		LoadFail,        //广告已加载失败
		PreOpening,      //广告准备打开(未加载完,当加载完马上打开，已废弃!)
		Opening,         //广告正在打开(已加载完)
		Opened,          //广告已被打开
		Closing,         //广告正在关闭
		Closed,          //广告已被关闭
	};
	enum open_result
	{
		OpenSuccess,        //打开成功
		OpenFail,           //打开失败
	};

public:
	int id;             //id（唯一标识）
	bool isUsed;        //是否被使用
	std::shared_ptr<ADSource> adSource;  //广告源
	std::shared_ptr<ADSource::placement> adSourcePlacement;  //广告位
private:
	int status;         //状态
	bool isOpened;      //打开结果
	//bool isManualCheck; //手动检查
	std::chrono::steady_clock::time_point m_time_generated;
public:
	ADSourceItem() {}
	ADSourceItem(std::shared_ptr<ADSource> adSource, std::shared_ptr<ADSource::placement> placement);
	int getStatus();
	
	void setStatus(int status);
	void setStatusLoading();
	void setStatusLoadFail();
	void setStatusLoadSuccess();
	void setStatusOpening();
	void setStatusOpened();
	void setStatusClosing();
	void setStatusClosed();

	void setManualCheckStatus();

	void onClicked();

	void openResult(int openResult);
	void openResultSuccess();
	void openResultFail();

	std::unordered_map<std::string, std::string> getValueMap();

	std::chrono::steady_clock::time_point getGenaratedTime();
};

class VIGAME_DECL ADSourceItemList : public std::vector<std::shared_ptr<ADSourceItem>>
{
public:
	std::mutex _mutex;
	//std::shared_ptr<ADSourceItem> getSourceItemReady(const std::string& agent, const std::string& type); //通过广告代理、广告类型获取一个可打开的广告条目
	std::shared_ptr<ADSourceItem> getSourceItemReady(const std::string& agent, const std::string& type, const std::string& adPositionName);
	std::shared_ptr<ADSourceItem> getSourceItem(const std::string& agent, const std::string& type, const std::string& adPositionName, ADSourceItem::staus_type adStatus);
	std::vector<std::shared_ptr<ADSourceItem> > getSourceItems(const std::string& agent, const std::string& type, ADSourceItem::staus_type adStatus);
	std::vector<std::shared_ptr<ADSourceItem> > getItems(const std::string& agent, const std::string& type);
	void remove(std::shared_ptr<ADSourceItem> adSourceItem);
	void addEle(std::shared_ptr<ADSourceItem> adSourceItem);
};

NS_VIGAME_AD_END