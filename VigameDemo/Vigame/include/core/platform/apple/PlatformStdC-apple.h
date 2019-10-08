#pragma once

#include "core/platform/PlatformDefine.h"
#include "core/platform/PlatformStdC.h"
#include "core/platform/PlatformMacros.h"

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_MAC || VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_IOS
#include <float.h>
#include <math.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <stdint.h>

#endif
