#pragma once

#include "BaseAgent.h"

NS_VIGAME_SOCIAL_BEGIN

struct QQLoginParam : BaseLoginParam
{
	int result;
	std::string openid;
	std::string accessToken;
	std::string payToken;
	std::string expires_in;
	std::string pf;
	std::string pfKey;
};

struct QQUserInfoParam : BaseUserInfoParam
{
	std::string openid;     //普通用户的标识
	std::string nickname;	//普通用户昵称
	std::string province;   //个人资料填写的省份
	std::string city;       //个人资料填写的城市
	std::string country;    //个人资料填写的国家
	std::string headImgUrl; //用户头像url
	std::string unionId;	//用户统一标识
	int sex;                //普通用户性别   1男  2女
	int vip;                //vip等级
	int level;              //qq等级
	int isLost;             //登陆 中断天数
	int result;             //标志位 0成功 -1 失败
};

class VIGAME_DECL QQAgent : public SocialBaseAgent
{
private:
	QQLoginParam m_QQLoginParam;
	QQUserInfoParam m_QQUserInfoParam;
public:
	virtual int getType() override;

	virtual void login(const LoginCallback& loginCallback) override;

	virtual void loginOut(const LoginOutCallback& loginOutCallback) override;

	virtual void share(const std::string& url, const std::string& title, const std::string& content, const ShareCallback& shareCallback) override;
};

NS_VIGAME_SOCIAL_END
