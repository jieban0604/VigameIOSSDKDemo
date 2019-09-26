#ifndef _WB_WEB_DIALOG_H__
#define  _WB_WEB_DIALOG_H__
#include "core/macros.h"
#include <string>
#include <functional>

NS_VIGAME_BEGIN


class VIGAME_DECL WebDialog {
public:
	typedef std::function<void(bool success)> OnLoadFinish;

private:
	OnLoadFinish _finishFunc;

public:

	static WebDialog* getInstance();

	virtual void preload(std::string url,const OnLoadFinish& onFinish) {
		(void)url;//unused
		_finishFunc = onFinish;
	}

	virtual void show() {

	}
protected:
	void onFinish(bool success) {
		_finishFunc(success);
	}
};

NS_VIGAME_END
#endif // _WB_WEB_DIALOG_H__
