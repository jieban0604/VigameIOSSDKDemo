#pragma once

#include "macros.h"
#include <string>
#include <functional>

NS_VIGAME_BEGIN

namespace UserAgreement {

bool VIGAME_DECL open();         //打开用户协议

bool VIGAME_DECL isAccepted();   //是否已接受用户协议

void VIGAME_DECL accept();       //接受用户协议

}

NS_VIGAME_END