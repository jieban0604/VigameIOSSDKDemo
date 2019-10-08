#ifndef __BASE_VIGAME_PLATFORM_CONFIG_H__
#define __BASE_VIGAME_PLATFORM_CONFIG_H__

/**
  THIS FILE MUST NOT INCLUDE ANY OTHER FILE
*/

//////////////////////////////////////////////////////////////////////////
// pre configure
//////////////////////////////////////////////////////////////////////////

// define supported target platform macro which CC uses.
#define VIGAME_PLATFORM_UNKNOWN            0
#define VIGAME_PLATFORM_IOS                1
#define VIGAME_PLATFORM_ANDROID            2
#define VIGAME_PLATFORM_WIN32              3
#define VIGAME_PLATFORM_MARMALADE          4
#define VIGAME_PLATFORM_LINUX              5
#define VIGAME_PLATFORM_BADA               6
#define VIGAME_PLATFORM_BLACKBERRY         7
#define VIGAME_PLATFORM_MAC                8
#define VIGAME_PLATFORM_NACL               9
#define VIGAME_PLATFORM_EMSCRIPTEN        10
#define VIGAME_PLATFORM_TIZEN             11
#define VIGAME_PLATFORM_QT5               12
#define VIGAME_PLATFORM_WINRT             13

// Determine target platform by compile environment macro.
#define VIGAME_TARGET_PLATFORM             VIGAME_PLATFORM_UNKNOWN

// mac
#if defined(VIGAME_TARGET_OS_MAC) || defined(__APPLE__)
#undef  VIGAME_TARGET_PLATFORM
#define VIGAME_TARGET_PLATFORM         VIGAME_PLATFORM_MAC
#endif

// iphone
#if defined(VIGAME_TARGET_OS_IPHONE)
    #undef  VIGAME_TARGET_PLATFORM
    #define VIGAME_TARGET_PLATFORM         VIGAME_PLATFORM_IOS
#endif

// android
#if defined(ANDROID)
    #undef  VIGAME_TARGET_PLATFORM
    #define VIGAME_TARGET_PLATFORM         VIGAME_PLATFORM_ANDROID
#endif

// win32
#if defined(_WIN32)
    #undef  VIGAME_TARGET_PLATFORM
    #define VIGAME_TARGET_PLATFORM         VIGAME_PLATFORM_WIN32
#endif

// linux
#if defined(LINUX) && !defined(__APPLE__)
    #undef  VIGAME_TARGET_PLATFORM
    #define VIGAME_TARGET_PLATFORM         VIGAME_PLATFORM_LINUX
#endif

// marmalade
#if defined(MARMALADE)
#undef  VIGAME_TARGET_PLATFORM
#define VIGAME_TARGET_PLATFORM         VIGAME_PLATFORM_MARMALADE
#endif

// bada
#if defined(SHP)
#undef  VIGAME_TARGET_PLATFORM
#define VIGAME_TARGET_PLATFORM         VIGAME_PLATFORM_BADA
#endif

// qnx
#if defined(__QNX__)
    #undef  VIGAME_TARGET_PLATFORM
    #define VIGAME_TARGET_PLATFORM     VIGAME_PLATFORM_BLACKBERRY
#endif

// native client
#if defined(__native_client__)
    #undef  VIGAME_TARGET_PLATFORM
    #define VIGAME_TARGET_PLATFORM     VIGAME_PLATFORM_NACL
#endif

// Emscripten
#if defined(EMSCRIPTEN)
    #undef  VIGAME_TARGET_PLATFORM
    #define VIGAME_TARGET_PLATFORM     VIGAME_PLATFORM_EMSCRIPTEN
#endif

// tizen
#if defined(TIZEN)
    #undef  VIGAME_TARGET_PLATFORM
    #define VIGAME_TARGET_PLATFORM     VIGAME_PLATFORM_TIZEN
#endif

// qt5
#if defined(QT5)
    #undef  VIGAME_TARGET_PLATFORM
    #define VIGAME_TARGET_PLATFORM     VIGAME_PLATFORM_QT5
#endif

// WinRT (Windows 8.1 Store/Phone App)
#if defined(WINRT)
    #undef  VIGAME_TARGET_PLATFORM
    #define VIGAME_TARGET_PLATFORM          VIGAME_PLATFORM_WINRT
#endif

//////////////////////////////////////////////////////////////////////////
// post configure
//////////////////////////////////////////////////////////////////////////

// check user set platform
#if ! VIGAME_TARGET_PLATFORM
    #error  "Cannot recognize the target platform; are you targeting an unsupported platform?"
#endif 

#if (VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_WIN32)
#ifndef __MINGW32__
#pragma warning (disable:4127) 
#endif 
#endif  // VIGAME_PLATFORM_WIN32

/// @endcond
#endif  // __BASE_VIGAME_PLATFORM_CONFIG_H__
