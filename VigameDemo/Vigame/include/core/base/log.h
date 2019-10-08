#ifndef _VIGAME_LOG_H__
#define _VIGAME_LOG_H__

#include "core/macros.h"

NS_VIGAME_BEGIN

void VIGAME_DECL log(const char * format, ...) VIGAME_FORMAT_PRINTF(1, 2);
void VIGAME_DECL log2(const char *tag, const char * format, ...) VIGAME_FORMAT_PRINTF(2, 3);

NS_VIGAME_END

#endif