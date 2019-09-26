#ifndef __WBTJ__H__
#define __WBTJ__H__
#include "tj/macros.h"
#include <unordered_map>
#include <string>

NS_VIGAME_BEGIN

class VIGAME_DECL WBTJ
{
public:
	static WBTJ* getInstance();
	void splashReport();//����ҳ�ϱ�
	void adStatusReport(std::string sid, std::string adPositionName, int status, int flag, std::string ad_type, std::string param); // ������� / չʾ / ���  �ϱ�
	void adStatusReportDelay(); //������� / չʾ / ���  �ϱ�  �ӳ��ϱ�
	void adConfigReport(int);	//������û�ȡ�ɹ�����ϱ� (1:���icon����ʱ�ϱ� 2:������û�ȡ�ɹ����ϱ� 3:���ع��Դ�ɹ����ϱ�)
	void getReport(std::string url);// http get����
	virtual void dataEyeShow(std::string sid, std::string adPositionName, std::string ad_type, std::string param) = 0;
	virtual void fbClicked() = 0;
};

NS_VIGAME_END

#endif