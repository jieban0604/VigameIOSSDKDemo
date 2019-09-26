#pragma once

#include "ad/macros.h"
#include <memory>
#include <vector>
#include "ADSourceItem.h"
#include "ADPosition.h"

//class VIGAME_DECL ADSourceItem;
//class VIGAME_DECL ADPosition;

NS_VIGAME_AD_BEGIN

//广告缓存，可供多个游戏广告位使用
class ADCache
{
public:
	std::shared_ptr<ADSourceItem> adSourceItem;    //广告源条目
	std::shared_ptr<ADPosition> adPosition;        //使用的游戏广告位
public:
	ADCache(std::shared_ptr<ADSourceItem> adSourceItem, std::shared_ptr<ADPosition> adPosition);
private:
	ADCache();
};

//typedef std::vector<std::shared_ptr<ADCache>> ADCacheList;

class VIGAME_DECL ADCacheList : public std::vector<std::shared_ptr<ADCache>>
{
public:
	//根据广告位获取第一个调用打开的 adCache
	ADCacheList::iterator findItem(const std::string& positionName) {
		for (ADCacheList::iterator it = this->begin(); it != this->end(); it++)
		{
			std::shared_ptr<ADCache> adCache = *it;
			if (adCache->adPosition->name == positionName)
			{
				return it;
			}
		}
		return this->end();
	}
	ADCacheList::iterator findItemByADSourceItem(ADSourceItem* adSource) {
		for (ADCacheList::iterator it = this->begin(); it != this->end(); it++)
		{
			std::shared_ptr<ADCache> adCache = *it;
			if (adCache->adSourceItem.get() == adSource)
			{
				return it;
			}
		}
		return this->end();
	}
	//根据广告位获取所有调用打开的 adCache
	std::vector<std::shared_ptr<ADCache>> findItems(const std::string& positionName) {
		std::vector<std::shared_ptr<ADCache> > adl;
		for (ADCacheList::iterator it = this->begin(); it != this->end(); it++)
		{
			std::shared_ptr<ADCache> adCache = *it;
			if (adCache->adPosition->name == positionName)
			{
				adl.push_back(adCache);
			}
		}
		return adl;
	}
	//移除一个 adCache 元素
	ADCacheList::iterator removeItem(std::shared_ptr<ADCache> adCache) {
		for (ADCacheList::iterator it = this->begin(); it != this->end(); it++)
		{
			if (*it == adCache)
			{
				return this->erase(it);
			}
		}
		return this->end();
	}

	//std::mutex _mutex;
	////std::shared_ptr<ADSourceItem> getSourceItemReady(const std::string& agent, const std::string& type); //通过广告代理、广告类型获取一个可打开的广告条目
	//std::shared_ptr<ADSourceItem> getSourceItemReady(const std::string& agent, const std::string& type, const std::string& adPositionName);
	//std::shared_ptr<ADSourceItem> getSourceItem(const std::string& agent, const std::string& type, const std::string& adPositionName, ADSourceItem::staus_type adStatus);

	//void remove(std::shared_ptr<ADSourceItem> adSourceItem);
};

NS_VIGAME_AD_END
