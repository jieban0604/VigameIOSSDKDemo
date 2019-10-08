#pragma once

#include "core/SysConfig.h"

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_MAC || VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_IOS

NS_VIGAME_BEGIN

class SysConfigApple : public SysConfig
{
public:
    virtual void init() override;
    void showiOSConfigParams();
protected:
    virtual int getNetState() override;//获取网络状态
    virtual unsigned long get_ElapsedRealtime() override;
    virtual void setStringToPasterBoard(std::string body) override;
    virtual bool isRoot() override;//判断设备是否越狱
    
};

NS_VIGAME_END

#endif
