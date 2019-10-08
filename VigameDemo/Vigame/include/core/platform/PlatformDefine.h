#ifndef __PLATFORM_VIGAMEPLATFORMDEFINE_H__
#define __PLATFORM_VIGAMEPLATFORMDEFINE_H__

#include "PlatformConfig.h"

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_MAC
#include "apple/PlatformDefine-apple.h"
#elif VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_IOS
#include "apple/PlatformDefine-apple.h"
#elif VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_ANDROID
#include "android/PlatformDefine-android.h"
#elif VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_WIN32
#include "win32/PlatformDefine-win32.h"
#elif VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_WINRT
#include "winrt/PlatformDefine-winrt.h"
#elif VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_LINUX
#include "linux/PlatformDefine-linux.h"
#endif

#endif
