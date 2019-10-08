#pragma once

#include "core/macros.h"

#ifdef __cplusplus
#define NS_VIGAME_PUSH_BEGIN                     namespace vigame { namespace push {
#define NS_VIGAME_PUSH_END                       } }
#else
#define NS_VIGAME_PUSH_BEGIN 
#define NS_VIGAME_PUSH_END
#endif

#include "core/base/log.h"

#define  LOGPUSH(...)  vigame::log2("PushLog", __VA_ARGS__)
