#ifndef _WB_WEB_DIALOG_APPLE_H__ 
#define _WB_WEB_DIALOG_APPLE_H__
#include "core/WebDialog.h"

NS_VIGAME_BEGIN

class VIGAME_DECL WebDialogApple : public WebDialog{

public:
	//static WebDialog* getInstance();

	virtual void preload(std::string url, const OnLoadFinish& onFinish) override;

	virtual void show() override;
	
	void onFinish(bool success);
};

NS_VIGAME_END
#endif // _WB_WEB_DIALOG_H__
