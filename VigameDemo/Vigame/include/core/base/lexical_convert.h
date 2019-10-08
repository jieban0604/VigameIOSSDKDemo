#pragma once

#include "core/macros.h"
#include <string>

NS_VIGAME_BEGIN

//此文件所有函数请勿使用，请使用Utils里的lexical_cast

namespace lexical {

//数据类型转string
bool lexical_convert(const bool& arg, std::string& ret);

bool lexical_convert(const int& arg, std::string& ret);

bool lexical_convert(const long& arg, std::string& ret);

bool lexical_convert(const long long& arg, std::string& ret);

bool lexical_convert(const unsigned int& arg, std::string& ret);

bool lexical_convert(const unsigned long& arg, std::string& ret);

bool lexical_convert(const unsigned long long& arg, std::string& ret);

bool lexical_convert(const float& arg, std::string& ret);

bool lexical_convert(const double& arg, std::string& ret);


//char*转数据类型

bool lexical_convert(const char* arg, bool& ret);

bool lexical_convert(const char* arg, int& ret);

bool lexical_convert(const char* arg, long& ret);

bool lexical_convert(const char* arg, long long& ret);

bool lexical_convert(const char* arg, unsigned int& ret);

bool lexical_convert(const char* arg, unsigned long& ret);

bool lexical_convert(const char* arg, unsigned long long& ret);

bool lexical_convert(const char* arg, float& ret);

bool lexical_convert(const char* arg, double& ret);


//string转数据类型

bool lexical_convert(const std::string& arg, bool& ret);

bool lexical_convert(const std::string& arg, int& ret);

bool lexical_convert(const std::string& arg, long& ret);

bool lexical_convert(const std::string& arg, long long& ret);

bool lexical_convert(const std::string& arg, unsigned int& ret);

bool lexical_convert(const std::string& arg, unsigned long& ret);

bool lexical_convert(const std::string& arg, unsigned long long& ret);

bool lexical_convert(const std::string& arg, float& ret);

bool lexical_convert(const std::string& arg, double& ret);


template <typename Target, typename Source>
inline Target lexical_convert(const Source& arg)
{
	Target ret;
	lexical_convert(arg, ret);
	return ret;
}

}
NS_VIGAME_END