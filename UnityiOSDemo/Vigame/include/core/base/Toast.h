#pragma once

#include "core/macros.h"
#include <string>

NS_VIGAME_BEGIN

class VIGAME_DECL Toast
{
public:
	static void makeText(const std::string& text);
};

NS_VIGAME_END
