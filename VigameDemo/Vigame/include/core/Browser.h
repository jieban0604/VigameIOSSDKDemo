#pragma once

#include "macros.h"
#include <string>
#include <functional>

NS_VIGAME_BEGIN

namespace browser {
	//打开系统默认浏览器
	void VIGAME_DECL open(const std::string& url);
	//打开弹框样式的浏览器
	void VIGAME_DECL openDialogWeb(const std::string& url,std::string title="");
	//打开全屏的浏览器（对于Android是个单独的activity）
	void VIGAME_DECL openActivityWeb(const std::string& url, std::string title = "");
	//打开预置浏览器
	void VIGAME_DECL openInnerWeb(const std::string& url);
}

namespace feedback {
	void VIGAME_DECL open();

}
NS_VIGAME_END
