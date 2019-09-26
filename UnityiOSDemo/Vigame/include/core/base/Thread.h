#pragma once

#include "core/macros.h"
#include <functional>

NS_VIGAME_BEGIN

class Thread
{
typedef std::function<void(std::function<void()> function2)> ThreadOnAppMainCallback;

private:
	static ThreadOnAppMainCallback m_onAppMainThreadCallback;
public:
	static void setOnRequestAppMainThreadCallback(const ThreadOnAppMainCallback &function);

	static void runOnAppMainThread(const std::function<void()> &function);

};

NS_VIGAME_END