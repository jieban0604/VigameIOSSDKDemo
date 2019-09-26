#pragma once

#include "core/platform/PlatformConfig.h"

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_MAC || VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_IOS

#define VIGAME_DECL

#define VIGAME_DECL_EXPORT

#include <assert.h>

#define VIGAME_ASSERT(cond) assert(cond)

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

#endif