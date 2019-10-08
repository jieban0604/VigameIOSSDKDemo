#pragma once

#include "core/macros.h"

#ifdef __cplusplus
#define NS_VIGAME_TJ_BEGIN                     namespace vigame { namespace tj {
#define NS_VIGAME_TJ_END                       } }
#else
#define NS_VIGAME_TJ_BEGIN 
#define NS_VIGAME_TJ_END
#endif

#include "core/base/log.h"

#define  LOGTJ(...)  vigame::log2("TJLog", __VA_ARGS__)
