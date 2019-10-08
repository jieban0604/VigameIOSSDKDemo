#pragma once

#include "core/macros.h"
#include "core/base/base64.h"
#include "core/base/Utils.h"
#include "core/base/Thread.h"
#include "core/base/log.h"
#include "core/base/Toast.h"
#include "core/CoreManager.h"
#include "core/Browser.h"
#include "core/Activity.h"
#include "core/Notice.h"
#include "core/CDKEY.h"
#include "core/Rank.h"
#include "core/UserAgreement.h"
#include "core/Signature.h"
#include "core/FileUtils.h"
#include "core/HttpFetch.h"
#include "core/MmChnlManager.h"
#include "core/SysConfig.h"
#include "core/Notification.h"
#include "core/zpack/zpFileUtils.h"
#include "core/XYXManager.h"
#include "core/Community.h"
#include "core/InAppAppraise.h"
#include "core/Community.h"

#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_ANDROID
#include "core/platform/android/JniHelper.h"
#endif

#include "core/auto_link.h"
