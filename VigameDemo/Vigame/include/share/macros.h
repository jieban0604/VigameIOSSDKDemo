#pragma once

#include "core/macros.h"

#ifdef __cplusplus
#define NS_VIGAME_SHARE_BEGIN                     namespace vigame { namespace share {
#define NS_VIGAME_SHARE_END                       } }
#else
#define NS_VIGAME_SHARE_BEGIN 
#define NS_VIGAME_SHARE_END
#endif

#include "core/base/log.h"

#define  LOGSHARE(...)  vigame::log2("ShareLog", __VA_ARGS__)
