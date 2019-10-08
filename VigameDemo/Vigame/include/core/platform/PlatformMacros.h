#pragma once

#ifdef __cplusplus
#define NS_VIGAME_BEGIN                     namespace vigame {
#define NS_VIGAME_END                       }
#else
#define NS_VIGAME_BEGIN 
#define NS_VIGAME_END
#endif

#if defined(__GNUC__) && (__GNUC__ >= 4)
#define VIGAME_FORMAT_PRINTF(formatPos, argPos) __attribute__((__format__(printf, formatPos, argPos)))
#elif defined(__has_attribute)
#if __has_attribute(format)
#define VIGAME_FORMAT_PRINTF(formatPos, argPos) __attribute__((__format__(printf, formatPos, argPos)))
#endif // __has_attribute(format)
#else
#define VIGAME_FORMAT_PRINTF(formatPos, argPos)

#ifdef __GNUC__
#define VIGAME_UNUSED __attribute__ ((unused))
#else
#define VIGAME_UNUSED
#endif

#if(VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_WIN32)
#define strcasecmp _stricmp
#endif

#endif