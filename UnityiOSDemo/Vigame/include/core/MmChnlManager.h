#ifndef __MMchnlManager_H__
#define __MMchnlManager_H__

#include "core/macros.h"
#include "core/base/log.h"
#include "core/base/Thread.h"
#include <string>
#include <map>
#include <vector>
#include <functional>
#include <memory>

NS_VIGAME_BEGIN

#define  LOGMMCHANNEL(...)  log2("MMChannelLog", __VA_ARGS__)

class VIGAME_DECL MMChnl
{
public:
	int mm;                        //1 - 有提示, 2 - 没有提示
	int qpay;                      //0-默认 1-运营商 2-Qpay 3-基地 4-沃商店 5-天翼空间 6-爱游戏 8-移动MM
	int more;                      //1 - 更多游戏打开 0 - 关闭
	int gift;                      //1 - 1分钱礼包打开 0其他关闭
	int audit;                     //IOS专用  0-审核中  1 - 审核完成
	std::string headline;          //公告URL
	std::string bonus;             //排名URL
	std::string activity;          //活动URL
	int wxshare;                   //微信分享开关	1 - 微信分享打开 0 - 关闭
	unsigned long long timestamp;  //时间戳，当前的毫秒级时间
	std::string timesegment;       //领奖时间段(11-13点，6点到9点)
	std::string giftSequence;      //自动弹出的礼包序列
	std::string adSequence;        //广告弹出的序列
	int giftDelay;                 //自动弹出礼包的时间间隔,默认-1，单位为秒。
	int freeBtn;                   //是否为领取按钮，1 - 领取按钮 0 - 购买按钮 （默认为0）
	int lottery;                   //是否打开抽奖，默认打开     1-打开  0关闭
	int wxpay;                     //是否打开微信支付选项，默认关闭 1-打开  0关闭
	int wxred;                     //支付后是否弹出微信支付红包，默认关闭 1-打开  0关闭
	int ad;                        //是否打开广告，1-打开  0-关闭（默认为1-打开）

	std::string apiGet;				//获取广告配置的地址
	std::string apiResp;			//广告上报的地址

	MMChnl();
	virtual ~MMChnl();
	virtual bool initParam(const std::string& mmchnl);
	//virtual bool initWithElement(tinyxml2::XMLElement* rootElement);
	virtual bool initWithElement(void* root);
	const char* getValueForKey(const char* pKey);
	virtual bool genMMChnl() { return false; }
	virtual std::string getMMChnl() { return m_mmchnl; }
	std::map<std::string, std::string> getMmchnlValues() { return m_mmchnlValues; }

protected:
	std::string m_mmchnl;
	std::map<std::string, std::string> m_mmchnlValues;
};

class VIGAME_DECL MMChnlLocal : public MMChnl
{
public:
	MMChnlLocal();
	virtual ~MMChnlLocal();
	virtual bool isInited() { return m_isInited; }
	virtual bool genMMChnl();
	static void saveMMChnlToFile(const std::string& mmchl);
private:
	bool m_isInited;
};

class VIGAME_DECL MMChnlNet : public MMChnl
{
public:
	MMChnlNet();
	virtual ~MMChnlNet();
	virtual bool isInited() { return m_isInited; }
	virtual bool genMMChnl();
	std::string genUrl();
private:
	bool m_isInited;
	std::string m_url;
};

class VIGAME_DECL MMChnlManager
{
public:
	MMChnlManager();
	~MMChnlManager();
	static MMChnlManager* getInstance();
	void init();

	void addMMChnlChangedListener(const std::function<void(MMChnl*)>& onChangedListener);

	MMChnlLocal* getMMChnlLocal() { return m_mmChnlLocal.get(); }
	MMChnlNet* getMMChnlNet() { return m_mmChnlNet.get(); }
	MMChnl* getMMChnl();

private:
	bool m_isInited;
	void initLocal();
	void initNet();
	void onMMChnlChanged(MMChnl* mmChnl);

private:
	//0:默认,优先网络配置,网络配置未初始化使用本地存储配置,本地存储配置仍没有,使用MMChnl.xml文件配置
	//1:debug情况下使用,只使用MMChnl.xml文件配置,不初始化网络配置
	int m_MMChnlDebug;

	int m_onChangedCount;
	std::shared_ptr<MMChnlLocal> m_mmChnlLocal;
	std::shared_ptr<MMChnlNet> m_mmChnlNet;

	std::vector<std::function<void(MMChnl*)>> m_MMChnlChangedListeners;
};

NS_VIGAME_END

#endif
