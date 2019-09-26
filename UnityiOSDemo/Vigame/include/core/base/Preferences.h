#pragma once

#include "core/macros.h"
#include "boost/property_tree/xml_parser.hpp"
#include <string>

NS_VIGAME_BEGIN

#define  LOGUSERDEFAULT(...)  log2("PreferencesLog", __VA_ARGS__)

class VIGAME_DECL Preferences
{
public:
	Preferences() = default;
	~Preferences();

	static Preferences* getInstance();

	void init();

	std::string getPathKey(const std::string& key);


	template <class Type>
	Type getValue(const std::string& key, Type defaultValue)
	{
		try
		{
			return m_ptree.get<Type>(getPathKey(key), defaultValue);
		}
		catch (...)
		{
			return defaultValue;
		}
	}

	template <class Type>
	bool setValue(const std::string& key, Type defaultValue)
	{
		try
		{
			m_ptree.put(getPathKey(key), defaultValue);
			return true;
		}
		catch (...)
		{
			return false;
		}
	}

	void deleteKey(const std::string& key)
	{
		try
		{
			m_ptree.erase(getPathKey(key));
		}
		catch (...)
		{

		}
	}

	void flush();

private:
	std::string m_filePath;
	boost::property_tree::ptree m_ptree;
};


NS_VIGAME_END

