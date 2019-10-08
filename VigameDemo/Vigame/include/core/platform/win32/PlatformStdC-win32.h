#ifndef __VIGAME_STD_C_H__
#define __VIGAME_STD_C_H__

#include "core/platform/PlatformDefine.h"
#include "core/platform/PlatformStdC.h"
#include "core/platform/PlatformMacros.h"

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_WIN32

#include <BaseTsd.h>
#ifndef __SSIZE_T
#define __SSIZE_T
typedef SSIZE_T ssize_t;
#endif // __SSIZE_T

// for MIN MAX and sys/time.h on win32 platform
#ifdef __MINGW32__
#include <sys/time.h>
#endif // __MINGW32__

#if _MSC_VER >= 1600 || defined(__MINGW32__)
    #include <stdint.h>
#else
    #include "./compat/stdint.h"
#endif


// Structure timeval has define in winsock.h, include windows.h for it.
#include <WinSock2.h>
#include <Windows.h>

#ifndef __MINGW32__

//#include <WinSock2.h>

NS_VIGAME_BEGIN

struct timezone
{
	int tz_minuteswest;
	int tz_dsttime;
};

int VIGAME_DECL gettimeofday(struct timeval *, struct timezone *);

NS_VIGAME_END

#else

#undef _WINSOCKAPI_
#include <winsock2.h>

// Conflicted with math.h isnan
#include <cmath>
using std::isnan;

inline int vsnprintf_s(char *buffer, size_t sizeOfBuffer, size_t count,
	const char *format, va_list argptr) {
	return vsnprintf(buffer, sizeOfBuffer, format, argptr);
}

#ifndef __clang__
inline errno_t strcpy_s(char *strDestination, size_t numberOfElements,
	const char *strSource) {
	strcpy(strDestination, strSource);
	return 0;
}
#endif
#endif // __MINGW32__

#endif // VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_WIN32

#endif  // __VIGAME_STD_C_H__



