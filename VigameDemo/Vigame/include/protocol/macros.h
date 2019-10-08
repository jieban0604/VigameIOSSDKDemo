#pragma once

#include "core/macros.h"

#ifdef __cplusplus
#define NS_VIGAME_PROTOCOL_BEGIN                     namespace vigame { namespace protocol {
#define NS_VIGAME_PROTOCOL_END                       } }
#else
#define NS_VIGAME_PROTOCOL_BEGIN 
#define NS_VIGAME_PROTOCOL_END
#endif

#include "core/base/log.h"

#define  LOGPROTOCOL(...)  vigame::log2("PROTOCOLLog", __VA_ARGS__)
