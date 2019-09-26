#pragma once

#include "core/macros.h"

NS_VIGAME_BEGIN

char VIGAME_DECL *MD5String(const char* string);

bool VIGAME_DECL MD5Check( char *md5string, char* string );

NS_VIGAME_END