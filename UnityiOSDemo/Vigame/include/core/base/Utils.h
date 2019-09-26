#pragma once

#include "lexical_convert.h"
#include "core/macros.h"
#include <ctime>
#include <string>
#include <vector>
#include <chrono>

NS_VIGAME_BEGIN

namespace utils {

//生成随机密钥串
std::string VIGAME_DECL generateSign(std::string value, int rand);

    void osLog(const char *tag, char * buf);
    
//数据转换
template <typename Target, typename Source>
inline Target VIGAME_DECL lexical_cast(const Source &arg)
{
	return lexical::lexical_convert<Target>(arg);
}

//分割字符串
std::vector<std::string> VIGAME_DECL splitString(std::string str, const std::string& splitstr);

int VIGAME_DECL getUtf8Length(const char *str);

std::string VIGAME_DECL subUtfString(const char *str, unsigned int start, unsigned int end);

//获得字符串中asc字符长度
unsigned int VIGAME_DECL getAscLength(const char* str);

//（英文和数字是1个字符，汉字两个字符）
unsigned int VIGAME_DECL getStringLengthAdvance(const char* str);

//截取字符串并保证中文字符的完整
std::string VIGAME_DECL subStringAdvance(const char* str, unsigned int length);

//返回毫秒级系统UTG时间
inline long long VIGAME_DECL millisecondNow()
{
	using namespace std::chrono;
	return duration_cast<milliseconds>(system_clock::now().time_since_epoch()).count();
}

//返回秒级系统UTG时间
inline long long VIGAME_DECL secondNow()
{
	using namespace std::chrono;
	return duration_cast<seconds>(system_clock::now().time_since_epoch()).count();
}

//返回年月日时间 YYYYMMDD
std::string VIGAME_DECL getDate();

//获取网络时间，返回成功或失败，参数返回毫秒级UTG时间
bool getNetTime(long long& millisecond);

//获取网络时间，返回成功或失败，参数返回time_point
bool getNetTime(std::chrono::system_clock::time_point& timepoint);

std::string VIGAME_DECL getTimeOfDay();

int VIGAME_DECL getDayOfYear();
int VIGAME_DECL getSecondToNextDay();
int VIGAME_DECL getSecondOfDay();

}

NS_VIGAME_END
