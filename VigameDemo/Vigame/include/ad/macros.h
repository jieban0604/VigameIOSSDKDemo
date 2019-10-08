#pragma once

#include "core/macros.h"

#ifdef __cplusplus
#define NS_VIGAME_AD_BEGIN                     namespace vigame { namespace ad {
#define NS_VIGAME_AD_END                       } }
#else
#define NS_VIGAME_AD_BEGIN 
#define NS_VIGAME_AD_END
#endif

#include "core/base/log.h"

#define  LOGAD(...)  vigame::log2("ADLog", __VA_ARGS__)
