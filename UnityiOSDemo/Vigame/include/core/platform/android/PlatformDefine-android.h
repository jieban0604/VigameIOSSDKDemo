#ifndef __VIGAMEPLATFORMDEFINE_H__
#define __VIGAMEPLATFORMDEFINE_H__

#include "core/platform/PlatformConfig.h"
#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_ANDROID

#include "android/log.h"

#define VIGAME_DECL

#define VIGAME_DECL_EXPORT

#define VIGAME_NO_MESSAGE_PSEUDOASSERT(cond)                        \
    if (!(cond)) {                                              \
        __android_log_print(ANDROID_LOG_ERROR,                  \
                            "vigame assert",                 \
                            "%s function:%s line:%d",           \
                            __FILE__, __FUNCTION__, __LINE__);  \
    }

#define VIGAME_MESSAGE_PSEUDOASSERT(cond, msg)                          \
    if (!(cond)) {                                                  \
        __android_log_print(ANDROID_LOG_ERROR,                      \
                            "vigame assert",                     \
                            "file:%s function:%s line:%d, %s",      \
                            __FILE__, __FUNCTION__, __LINE__, msg); \
    }

#define VIGAME_ASSERT(cond) VIGAME_NO_MESSAGE_PSEUDOASSERT(cond)
#define VIGAME_ASSERT_MSG(cond, msg) VIGAME_MESSAGE_PSEUDOASSERT(cond, msg)

#define VIGAME_UNUSED_PARAM(unusedparam) (void)unusedparam

/* Define NULL pointer value */
#ifndef NULL
#ifdef __cplusplus
#define NULL    0
#else
#define NULL    ((void *)0)
#endif
#endif

#endif // VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_ANDROID

#endif /* __VIGAMEPLATFORMDEFINE_H__*/
