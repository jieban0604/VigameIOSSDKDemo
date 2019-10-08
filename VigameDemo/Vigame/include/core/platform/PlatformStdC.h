#ifndef __VIGAME_PLATFORM_STDC_H__
#define __VIGAME_PLATFORM_STDC_H__

#include "PlatformConfig.h"

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_MAC
#include "apple/PlatformStdC-apple.h"
#elif VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_IOS
#include "apple/PlatformStdC-apple.h"
#elif VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_ANDROID
#include "android/PlatformStdC-android.h"
#elif VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_WIN32
#include "win32/PlatformStdC-win32.h"
#elif VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_WINRT
#include "winrt/PlatformStdC.h"
#elif VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_LINUX
#include "linux/PlatformStdC-linux.h"
#endif

#endif
