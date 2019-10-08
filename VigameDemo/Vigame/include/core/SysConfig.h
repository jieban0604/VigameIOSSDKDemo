#ifndef __SYSCONFIG_H__
#define __SYSCONFIG_H__

#include "core/base/log.h"
#include <string>

NS_VIGAME_BEGIN

#define  LOGSYSCONFIG(...)  log2("SysConfigLog", __VA_ARGS__)

enum{
	NET_STATE_NULL = 0,//无网络
	NET_STATE_MOBILE,//手机网络
	NET_STATE_WIFI,//wifi网络
	NET_STATE_ETHERNET,//以太网
	NET_STATE_BLUETOOTH,//蓝牙网络
	NET_STATE_MAX,
};

class SysConfig
{
public:
	static SysConfig* getInstance();

	virtual void init();

	virtual int getNetState() = 0;//获取网络状态
	virtual std::string getExtPath(){ return m_extpath;};//获取外部存储路径
	virtual std::string getWritablePath(){ return m_wrtpath;};//获取内部存储路径

	virtual std::string getUUID() { return m_uuid; };//获取imsi
	virtual std::string getImsi() { return m_imsi;};//获取imsi
	virtual std::string getImei() { return m_imei;};//获取imei
	virtual std::string getLsn() { return m_lsn;};//获取lsn
	virtual std::string getMacaddress() { return m_macaddress;};//获取mac地址
	virtual std::string getMobile() { return m_mobile;};//获取手机号
	virtual std::string getMoilemodel() {return m_mobile_model;};//获取手机型号
	virtual std::string getSystemVersion() { return m_system_version;};//获取系统版本号
	virtual std::string getOSVersion() { return m_os_version; };//获取系统版本
	virtual std::string getAppid() { return m_appid;};//获取appid
	virtual std::string getPrjid() { return m_prjid;};//获取项目id
	virtual std::string getMmid() { return m_mmid;};//获取mmid
	virtual std::string getMmAppid() { return m_mmappid; };//获取mmid

	virtual int getPayTimes() { return m_paytimes; };//获取支付次数

	virtual std::string getPackage() { return m_package;};//获取应用包名
	virtual std::string getAppName() { return m_appname;};//获取应用名称
	virtual std::string getAppVersion() { return m_version;};//获取应用版本

	virtual std::string getCountry(){return m_country;}
	virtual std::string getDeviceType() { return m_deviceType; }
	virtual int getCountryIndex() {
		if (m_countryIndex == -1)
		{
			m_countryIndex = initCountryIndex();
		}
		return m_countryIndex; 
	}

	/* virtual std::string getWeChatOpenId(){return m_wechatOpenId;}
	 virtual std::string getWeChatSecret(){return m_wechatSecret;}
	 virtual std::string getAppDownloadURL(){return m_AppDownloadURL;}
	 std::string getFbInviteURL() { return m_FbInviteURL; };
	 std::string getFbImageURL() { return m_FbImageURL; };*/
    
	virtual bool get_app_installed(const std::string& packagename) { return true;};//根据包名检查app是否安装
    
	virtual bool isRoot() { return false; }//判断设备是否越狱

	virtual unsigned long get_ElapsedRealtime() = 0;

	virtual std::string genAppJsonString();

	std::string getDateString();

	virtual void setStringToPasterBoard(std::string body) {};

	virtual std::string getAdvertisingId();

	std::string getChannel();
	std::string getSupportGames();
	//std::string m_FbInviteURL;
	//std::string m_FbImageURL;
protected:
	bool m_isInited;
    bool m_isRoot;
    
	std::string m_extpath;
	std::string m_wrtpath;
	std::string m_uuid;
	std::string m_imsi;
	std::string m_imei;
	std::string m_lsn;
	std::string m_macaddress;
	std::string m_mobile;
	std::string m_mobile_model;
	std::string m_system_version;

	std::string m_appid;
	std::string m_prjid;
	std::string m_mmid;
	std::string m_mmappid;
	std::string m_channel;

	std::string m_package;
	std::string m_appname;
	std::string m_version;
	std::string m_os_version;
	int m_paytimes;//支付次数
protected:
	std::string m_country;
	std::string m_deviceType; //设备类型 pad还是phone
    /*std::string m_wechatOpenId;
    std::string m_wechatSecret;
    std::string m_AppDownloadURL;
	std::string m_FbInviteURL;
	std::string m_FbImageURL;*/
	
	std::string m_supportGames;
	int m_countryIndex;//国家对应的计费点索引
	int initCountryIndex();
	SysConfig();
};

NS_VIGAME_END

#endif
