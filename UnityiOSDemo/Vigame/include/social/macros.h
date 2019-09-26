#pragma once

#include "core/macros.h"

#ifdef __cplusplus
#define NS_VIGAME_SOCIAL_BEGIN                     namespace vigame { namespace social {
#define NS_VIGAME_SOCIAL_END                       } }
#else
#define NS_VIGAME_SOCIAL_BEGIN 
#define NS_VIGAME_SOCIAL_END
#endif

#include "core/base/log.h"

#define  LOGSOCIAL(...)  vigame::log2("SocialLog", __VA_ARGS__)
