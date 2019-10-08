#ifndef __SYSCONFIG_WIN32_H__
#define __SYSCONFIG_WIN32_H__

#include "core/SysConfig.h"

NS_VIGAME_BEGIN

class SysConfigWin32 : public SysConfig
{
public:
	virtual void init() override;

protected:
	virtual int getNetState() override;//获取网络状态
	
	virtual unsigned long get_ElapsedRealtime() override;
};

NS_VIGAME_END

#endif
