#ifndef __VIGAMEPLATFORMDEFINE_H__
#define __VIGAMEPLATFORMDEFINE_H__

#include "core/platform/PlatformConfig.h"
#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_WIN32

#ifdef __MINGW32__
#include <string.h>
#endif

#if defined (VIGAME_DYN_LINK)
#if defined(VIGAME_SOURCE)
#define VIGAME_DECL     __declspec(dllexport)
#else
#define VIGAME_DECL     __declspec(dllimport)
#endif
#else
#  define VIGAME_DECL
#endif

#define VIGAME_DECL_EXPORT __declspec(dllexport)

#include <assert.h>

#define VIGAME_ASSERT(expr)    assert(expr)
#define VIGAME_ASSERT_MSG(expr, msg) assert((expr)&&(msg))

#define VIGAME_UNUSED_PARAM(unusedparam) (void)unusedparam

/* Define NULL pointer value */
#ifndef NULL
#ifdef __cplusplus
#define NULL    0
#else
#define NULL    ((void *)0)
#endif
#endif

#endif // VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_WIN32

#endif /* __VIGAMEPLATFORMDEFINE_H__*/
