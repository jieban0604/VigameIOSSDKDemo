#include "PKClient.h"
#include "core/SysConfig.h"
#include "core/HttpFetch.h"
#include "core/base/Utils.h"
#include "core/base/base64.h"
#include "boost/property_tree/xml_parser.hpp"
#include <memory>
#include <mutex>

#if 1
#define ADDR_SET_USER	"https://cfg.vigame.cn/setUser" //设置用户
#define ADDR_GET_USER	"https://cfg.vigame.cn/getUser" //获取用户信息
#define ADDR_SET_PK		"https://cfg.vigame.cn/savedu"  //提交pk数据
#define ADDR_GET_PK		"https://cfg.vigame.cn/getpk"  //获取pk数据
#define ADDR_GET_BONUS	"https://cfg.vigame.cn/getRandom"
#define ADDR_GET_ROTARY "https://cfg.vigame.cn/getRotary"
#define ADDR_GET_MESSAGE "https://cfg.vigame.cn/getMsg"
#else
#define ADDR_SET_USER "http://192.168.1.118:8001/zhpay/setUser" //设置用户
#define ADDR_GET_USER "http://192.168.1.118:8001/zhpay/getUser" //获取用户信息
#define ADDR_SET_PK "http://192.168.1.118:8001/zhpay/savedu"  //提交pk数据
#define ADDR_GET_PK "http://192.168.1.118:8001/zhpay/getpk"  //获取pk数据
#define ADDR_GET_BONUS	"http://192.168.1.118:8001/zhpay/getRandom"
#define ADDR_GET_ROTARY "http://192.168.1.118:8001/zhpay/getRotary"
#define ADDR_GET_MESSAGE "http://192.168.1.118:8001/zhpay/getMsg"
#endif

NS_VIGAME_PROTOCOL_BEGIN

static void genBaseTree(boost::property_tree::ptree& tree)
{
	tree.add("pid", SysConfig::getInstance()->getPrjid());
	tree.add("appid", SysConfig::getInstance()->getAppid());
	tree.add("lsn", SysConfig::getInstance()->getLsn());
	tree.add("imsi", SysConfig::getInstance()->getImsi());
	tree.add("imei", SysConfig::getInstance()->getImei());
	tree.add("mac", SysConfig::getInstance()->getMacaddress());
}

static void genUserInfoTree(boost::property_tree::ptree& tree, const UserInfo& userinfo)
{
	tree.add("userid", userinfo.userid);
	tree.add("username", userinfo.username);
	tree.add("hiscore", userinfo.hiscore);
	tree.add("hilevel", userinfo.hilevel);
	tree.add("vsrate", userinfo.vsrate);
	tree.add("vswins", userinfo.vswins);
	tree.add("pkwins", userinfo.pkwins);
	tree.add("vip", userinfo.vip);
	tree.add("avatar", userinfo.avatar);
	tree.add("coin", userinfo.coin);
	tree.add("ticket", userinfo.ticket);
	tree.add("chip", userinfo.chip);
}

static UserInfo getUserInfoByTree(const boost::property_tree::ptree& tree)
{
	UserInfo userInfo;
	userInfo.userid = tree.get("userid", "");
	userInfo.username = tree.get("username", "");
	userInfo.hiscore = tree.get("hiscore", "");
	userInfo.hilevel = tree.get("hilevel", "");
	userInfo.vsrate = tree.get("vsrate", "");
	userInfo.vswins = tree.get("vswins", "");
	userInfo.pkwins = tree.get("pkwins", "");
	userInfo.vip = tree.get("vip", "");
	userInfo.avatar = tree.get("avatar", "");
	userInfo.coin = tree.get("coin", "");
	userInfo.ticket = tree.get("ticket", "");
	userInfo.chip = tree.get("chip", "");
	return std::move(userInfo);
}

static bool postXml(const std::string& url, const std::string& data, std::string& result)
{
	try
	{
		http::response response = http::post(url, data);
		if (response.status == http::response::status_type::ok)
		{
			result = response.body;
			return true;
		}
	}
	catch (...)
	{

	}
	return false;
}

static bool postXml(const std::string& url, const boost::property_tree::ptree& tree, std::string& result)
{
	try
	{
		std::stringstream ss;
		boost::property_tree::xml_parser::write_xml(ss, tree);

		std::string data = ss.str();

		return postXml(url, data, result);
	}
	catch (...)
	{

	}
	return false;
}

PKClient* PKClient::getInstance()
{
	static std::unique_ptr<PKClient> s_instance;
	static std::once_flag s_instance_created;
	std::call_once(s_instance_created, [=] { s_instance = std::make_unique<PKClient>(); });
	return s_instance.get();
}

void PKClient::getUserInfo(std::function<void(bool result, UserInfo userinfo)> callback)
{
	UserInfo userInfo;

	std::string action = "getuser";
	boost::property_tree::ptree requestRootTree;
	requestRootTree.add("request", "");
	
	boost::property_tree::ptree& requestTree = requestRootTree.get_child("request");
	requestTree.add("action", action);
	genBaseTree(requestTree);

	std::string result;
	if (!postXml(ADDR_GET_USER, requestRootTree, result))
	{
		callback(false, userInfo);
		return;
	}

	std::stringstream ssresult;
	ssresult << result;
	boost::property_tree::ptree receiveRootTree;
	boost::property_tree::xml_parser::read_xml(ssresult, receiveRootTree);

	auto responseTreeOpt = receiveRootTree.get_child_optional("response");
	if (responseTreeOpt)
	{
		boost::property_tree::ptree& responseTree = *responseTreeOpt;
		int retCode = responseTree.get<int>("resultCode", -1);
		if (retCode == 0)
		{
			auto userTreeOpt = responseTree.get_child_optional("user");
			if (userTreeOpt)
			{
				userInfo = getUserInfoByTree(*userTreeOpt);
				callback(true, userInfo);
				return;
			}
		}
	}

	callback(false, userInfo);
}

bool PKClient::setUserInfo(const UserInfo& userinfo)
{
	std::string action = "setuser";
	boost::property_tree::ptree requestRootTree;
	requestRootTree.add("request", "");

	boost::property_tree::ptree& requestTree = requestRootTree.get_child("request");
	requestTree.add("action", action);
	genBaseTree(requestTree);
	genUserInfoTree(requestTree, userinfo);

	
	std::stringstream ssrequest;
	boost::property_tree::xml_parser::write_xml(ssrequest, requestRootTree);
	std::string data = ssrequest.str();

	//加入验证代码
	int ran = abs(rand());
	std::string sign = utils::generateSign(data, ran);
	std::string value = utils::lexical_cast<std::string>(ran) + "&" + sign;

	std::string url = ADDR_SET_USER;
	url += "?value=" + base64_encode(value);


	std::string result;
	if (!postXml(url, data, result))
	{
		return false;
	}

	std::stringstream ssresult;
	ssresult << result;
	boost::property_tree::ptree receiveRootTree;
	boost::property_tree::xml_parser::read_xml(ssresult, receiveRootTree);

	auto responseTreeOpt = receiveRootTree.get_child_optional("response");
	if (responseTreeOpt)
	{
		int retCode = responseTreeOpt->get<int>("resultCode", -1);
		if (retCode == 0)
			return true;
	}
	
	return false;
}

void PKClient::getPKInfo(const std::string& area, std::function<void(bool result, PKInfo pkInfo)> callback)
{
	PKInfo pkInfo;

	std::string action = "getpkinfo";
	boost::property_tree::ptree requestRootTree;
	requestRootTree.add("request", "");
	
	boost::property_tree::ptree& requestTree = requestRootTree.get_child("request");
	genBaseTree(requestTree);
	requestTree.add("action", action);
	requestTree.add("area", area);

	std::string result;
	if (!postXml(ADDR_GET_PK, requestRootTree, result))
	{
		callback(false, pkInfo);
		return;
	}

	std::stringstream ssresult;
	ssresult << result;
	boost::property_tree::ptree receiveRootTree;
	boost::property_tree::xml_parser::read_xml(ssresult, receiveRootTree);

	auto responseTreeOpt = receiveRootTree.get_child_optional("response");
	if (responseTreeOpt)
	{
		boost::property_tree::ptree& responseTree = *responseTreeOpt;
		int retCode = responseTree.get<int>("resultCode", -1);
		if (retCode == 0)
		{
			//开始解析
			pkInfo.pkRank = responseTree.get<int>("pkRank", 0);
			pkInfo.preRank = responseTree.get<int>("preRank", 0);

			auto vsOpt = responseTree.get_child_optional("vs");
			if (vsOpt)
			{
				boost::property_tree::ptree& vsTree = *vsOpt;

				for (auto child : vsTree)
				{
					if (child.first == "<xmlattr>")
					{
						pkInfo.vsUserList.online = child.second.get("online", "");
						pkInfo.vsUserList.date = child.second.get("data", "");
					}
					else if (child.first == "user")
					{
						UserInfo userInfo = getUserInfoByTree(child.second);
						pkInfo.vsUserList.users.push_back(std::move(userInfo));
					}
				}
			}

			auto pkOpt = responseTree.get_child_optional("pk");
			if (pkOpt)
			{
				boost::property_tree::ptree pkTree = *pkOpt;

				for (auto child : pkTree)
				{
					if (child.first == "<xmlattr>")
					{
						pkInfo.pkUserList.online = child.second.get("online", "");
						pkInfo.pkUserList.date = child.second.get("data", "");
					}
					else if (child.first == "user")
					{
						UserInfo userInfo = getUserInfoByTree(child.second);
						pkInfo.pkUserList.users.push_back(std::move(userInfo));
					}
				}
			}

			auto topOpt = responseTree.get_child_optional("top");
			if (topOpt)
			{
				boost::property_tree::ptree topTree = *topOpt;

				for (auto child : topTree)
				{
					if (child.first == "<xmlattr>")
					{
						pkInfo.topUserList.online = child.second.get("online", "");
						pkInfo.topUserList.date = child.second.get("data", "");
					}
					else if (child.first == "user")
					{
						UserInfo userInfo = getUserInfoByTree(child.second);
						pkInfo.topUserList.users.push_back(std::move(userInfo));
					}
				}
			}

			callback(true, pkInfo);
		}
	}

	callback(false, pkInfo);
}

void PKClient::commintPKScore(const std::string& action, const std::string& score, const std::string& area, std::function<void(bool result, PKRankResult pkRankResult)> callback)
{
	PKRankResult pkRankResult;

	boost::property_tree::ptree requestRootTree;
	requestRootTree.add("request", "");

	boost::property_tree::ptree& requestTree = requestRootTree.get_child("request");
	genBaseTree(requestTree);
	requestTree.add("action", action);
	requestTree.add("area", area);

	if (action == "setvs")
	{
		requestTree.add("vs", score);
	}
	else if (action == "setpk")
	{
		requestTree.add("pk", score);
	}
	else if (action == "settop")
	{
		requestTree.add("top", score);
	}

	std::stringstream ssrequest;
	boost::property_tree::xml_parser::write_xml(ssrequest, requestRootTree);
	std::string data = ssrequest.str();

	std::string result;
	if (!postXml(ADDR_SET_PK, data, result))
	{
		callback(false, pkRankResult);
		return;
	}

	std::stringstream ssresult;
	ssresult << result;
	boost::property_tree::ptree receiveRootTree;
	boost::property_tree::xml_parser::read_xml(ssresult, receiveRootTree);

	auto responseTreeOpt = receiveRootTree.get_child_optional("response");
	if (responseTreeOpt)
	{
		boost::property_tree::ptree responseTree = *responseTreeOpt;
		int retCode = responseTree.get<int>("resultCode", -1);
		if (retCode == 0)
		{
			pkRankResult.area = responseTree.get("area", "");
			pkRankResult.rank = responseTree.get("rank", "");

			std::string bonus = responseTree.get("bonusMap", "");
			if (bonus.length() > 0)
			{
				std::string::size_type start = 0;
				std::string strItem;
				while (start < bonus.length())
				{
					std::string::size_type end = bonus.find(",", start);
					if (end == std::string::npos)
						end = bonus.length();
					strItem = bonus.substr(start, end - start);
					if (strItem.length()>0)
					{
						std::string::size_type sep = strItem.find(":");
						if (sep != std::string::npos)
						{
							std::string key = strItem.substr(0, sep);
							int value = utils::lexical_cast<int>(strItem.substr(sep + 1, strItem.length() - sep - 1));
							pkRankResult.bonusMap.insert(std::make_pair(key, value));
						}
					}
					start = end + 1;
				}
			}

			callback(true, pkRankResult);
			return;
		}
	}

	callback(false, pkRankResult);
}

void PKClient::setVSScore(int vsScore, const std::string& area, std::function<void(bool result, PKRankResult pkRankResult)> callback)
{
	return commintPKScore("setvs", utils::lexical_cast<std::string>(vsScore), area, callback);
}

void PKClient::setPKScore(int pkScore, const std::string& area, std::function<void(bool result, PKRankResult pkRankResult)> callback)
{
	return commintPKScore("setpk", utils::lexical_cast<std::string>(pkScore), area, callback);
}

void PKClient::setTopScore(int topScore, const std::string& area, std::function<void(bool result, PKRankResult pkRankResult)> callback)
{
	return commintPKScore("settop", utils::lexical_cast<std::string>(topScore), area, callback);
}

void PKClient::getBonus(const std::string& area, int level, bool isSupportWX, std::function<void(bool result, BonusInfo bonusInfo)> callback)
{
	BonusInfo bonusInfo;

	std::string action = "getbonus";
	boost::property_tree::ptree requestRootTree;
	requestRootTree.add("request", "");

	boost::property_tree::ptree& requestTree = requestRootTree.get_child("request");
	genBaseTree(requestTree);
	requestTree.add("action", action);
	requestTree.add("area", area);
	requestTree.add("level", area);
	if (isSupportWX)
	{
		requestTree.add("wx", "1");
	}
	else
	{
		requestTree.add("wx", "0");
	}
	

	std::string result;
	if (!postXml(ADDR_GET_BONUS, requestRootTree, result))
	{
		callback(false, bonusInfo);
		return;
	}

	std::stringstream ssresult;
	ssresult << result;
	boost::property_tree::ptree receiveRootTree;
	boost::property_tree::xml_parser::read_xml(ssresult, receiveRootTree);

	auto responseTreeOpt = receiveRootTree.get_child_optional("response");
	if (responseTreeOpt)
	{
		boost::property_tree::ptree responseTree = *responseTreeOpt;
		int retCode = responseTree.get<int>("resultCode", -1);
		if (retCode == 0)
		{
			std::string bonus = responseTree.get<std::string>("bonus", "");
			std::string bonustimes = responseTree.get<std::string>("bonustimes", "");
			std::vector<std::string> bonusVec = utils::splitString(bonus, ",");
			std::vector<std::string> bonustimesVec = utils::splitString(bonustimes, ",");
			for (auto& bonusPairStr : bonusVec)
			{
				std::vector<std::string> bonusPairVec = utils::splitString(bonusPairStr, ":");
				if (bonusPairVec.size() == 2)
				{
					bonusInfo.bonusMap.insert(std::make_pair(bonusPairVec[0], utils::lexical_cast<int>(bonusPairVec[1])));
				}
			}

			for (auto& bonustimesPairStr : bonustimesVec)
			{
				std::vector<std::string> bonustimesPairVec = utils::splitString(bonustimesPairStr, ":");
				if (bonustimesPairVec.size() == 2)
				{
					bonusInfo.bonusTimesMap.insert(std::make_pair(bonustimesPairVec[0], utils::lexical_cast<int>(bonustimesPairVec[1])));
				}
			}

			callback(true, bonusInfo);
			return;
		}
	}

	callback(false, bonusInfo);
}


void PKClient::getBonus(const std::string& area, int level, std::function<void(bool result, BonusInfo bonusInfo)> callback)
{
	return getBonus(area, level, SysConfig::getInstance()->get_app_installed("com.tencent.mm"), callback);
}

void PKClient::getRotary(std::function<void(bool result, RotaryInfo rotaryInfo)> callback)
{
	RotaryInfo rotaryInfo;

	std::string action = "getRotary";

	boost::property_tree::ptree requestRootTree;
	requestRootTree.add("request", "");

	boost::property_tree::ptree& requestTree = requestRootTree.get_child("request");
	genBaseTree(requestTree);

	std::string result;
	if (!postXml(ADDR_GET_ROTARY, requestRootTree, result))
	{
		callback(false, rotaryInfo);
		return;
	}

	std::stringstream ssresult;
	ssresult << result;
	boost::property_tree::ptree receiveRootTree;
	boost::property_tree::xml_parser::read_xml(ssresult, receiveRootTree);

	auto responseTreeOpt = receiveRootTree.get_child_optional("response");
	if (responseTreeOpt)
	{
		boost::property_tree::ptree responseTree = *responseTreeOpt;
		int retCode = responseTree.get<int>("resultCode", -1);
		if (retCode == 0)
		{
			rotaryInfo.prize = responseTree.get<std::string>("prize", "");
			rotaryInfo.num = responseTree.get<int>("num", 0);
			callback(true, rotaryInfo);
			return;
		}
	}

	callback(false, rotaryInfo);
}

void PKClient::getMessage(std::function<void(bool result, MessageInfo messageInfo)> callback)
{
	MessageInfo messageInfo;
	std::string action = "getMessage";

	boost::property_tree::ptree requestRootTree;
	requestRootTree.add("request", "");

	boost::property_tree::ptree& requestTree = requestRootTree.get_child("request");
	genBaseTree(requestTree);

	std::string result;
	if (!postXml(ADDR_GET_MESSAGE, requestRootTree, result))
	{
		callback(false, messageInfo);
		return;
	}

	std::stringstream ssresult;
	ssresult << result;
	boost::property_tree::ptree receiveRootTree;
	boost::property_tree::xml_parser::read_xml(ssresult, receiveRootTree);

	auto responseTreeOpt = receiveRootTree.get_child_optional("response");
	if (responseTreeOpt)
	{
		boost::property_tree::ptree responseTree = *responseTreeOpt;
		int retCode = responseTree.get<int>("resultCode", -1);
		if (retCode == 0)
		{
			for (auto child : responseTree)
			{
				if (child.first == "message")
				{
					MessageItemInfo messageItemInfo;
					messageItemInfo.type = child.second.get("type", "");
					messageItemInfo.color = child.second.get("color", "");
					messageItemInfo.body = child.second.get("body", "");
				}
			}
			
			callback(true, messageInfo);
			return;
		}
	}

	callback(false, messageInfo);
}

NS_VIGAME_PROTOCOL_END
