#pragma once

#include "share/macros.h"
#include <unordered_map>
#include "ShareDefine.h"

NS_VIGAME_SHARE_BEGIN

class ShareInfo
{
    
private:
	std::unordered_map<std::string, std::string> m_params;
public:
	ShareInfo();

	std::unordered_map<std::string, std::string> getParams();
    
    //分享的平台
    void platForm(SharePlatform platform);
    SharePlatform getSharePlatform();

	//title标题，在印象笔记、邮箱、信息、微信（包括好友、朋友圈和收藏）、 易信（包括好友、朋友圈）、人人网和QQ空间使用
	void title(std::string param);
    std::string getTitle();

	//site是分享此内容的网站名称，仅在QQ空间使用
	void site(std::string param);
    std::string getSite();

	//siteUrl是分享此内容的网站地址，仅在QQ空间使用
	void siteUrl(std::string param);
    std::string getSiteUrl();

	//text是分享文本，所有平台都需要这个字段
	void text(std::string param);
    std::string getText();

	//imagePath是本地的图片路径，除Linked-In外的所有平台都支持这个字段
	void imagePath(std::string param);
    std::string getImagePath();

	//imageUrl是图片的网络路径，新浪微博、人人网、QQ空间和Linked-In支持此字段
	void imageUrl(std::string param);
    std::string getImageUrl();

	//thumbImage是缩略图
	void thumbImage(std::string param);
    std::string getThumbImage();

	//链接，在QQ空间、人人、微信、QQ使用
	void url(std::string param);
    std::string getUrl();

	//使用米大师分享时，0/1分别代表分享到聊天窗口/朋友圈，10/11表示分享到QQ空间/QQ聊天窗口
	//使用微信分享时，0/1/2分别代表分享到聊天窗口/朋友圈/收藏，缺省2
	void shareTo(std::string param);
    std::string getShareTo();
    
    
    void action(std::string param);
    std::string getAction();

	void messageExt(std::string param);
    std::string getMessageExt();
    
    //使用微信分享时，可以选择分享的方式，有一种是小图片+链接，还有就是就一张大图,还有文字分享，小程序分享
    void shareType(ShareType param);
    ShareType getShareType();
    
    //
    void tagName(std::string param);
    std::string getTagName();

	//自定义的键值对（分享微信小程序时，需要userName和path两个自定义键值对）
	void setValue(std::string key,std::string value);
	std::string getValue(std::string key);
};

NS_VIGAME_SHARE_END
