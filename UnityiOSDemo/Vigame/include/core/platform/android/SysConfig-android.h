#ifndef __SYSCONFIG_ANDROID_H__
#define __SYSCONFIG_ANDROID_H__

#include "core/SysConfig.h"

NS_VIGAME_BEGIN

class SysConfigAndroid : public SysConfig
{
public:
	virtual void init() override;

protected:
	virtual int getNetState() override;//获取网络状态

	virtual bool get_app_installed(const std::string& packagename) override;//根据包名检查app是否安装

	virtual unsigned long get_ElapsedRealtime() override;

	virtual void setStringToPasterBoard(std::string body) override;

	virtual std::string getAdvertisingId() override;
	virtual bool isRoot() override;
};

NS_VIGAME_END

#endif
