#pragma once

#include "core/macros.h"

#ifdef __cplusplus
#define NS_VIGAME_PAY_BEGIN                     namespace vigame { namespace pay {
#define NS_VIGAME_PAY_END                       } }
#else
#define NS_VIGAME_PAY_BEGIN 
#define NS_VIGAME_PAY_END
#endif

#include "core/base/log.h"

#define  LOGPAY(...)  vigame::log2("PayLog", __VA_ARGS__)
