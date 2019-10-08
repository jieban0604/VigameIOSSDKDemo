#ifndef _WB_WEB_DIALOG_WIN32_H__ 
#define _WB_WEB_DIALOG_WIN32_H__
#include "core/WebDialog.h"

NS_VIGAME_BEGIN

class VIGAME_DECL WebDialogWin32 : public WebDialog {

public:
	//static WebDialog* getInstance();

	virtual void preload(std::string url, const OnLoadFinish& onFinish) override;

};

NS_VIGAME_END
#endif // _WB_WEB_DIALOG_H__
