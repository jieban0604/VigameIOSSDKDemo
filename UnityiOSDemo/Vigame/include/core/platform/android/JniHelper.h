#pragma once

#include "core/macros.h"
#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_ANDROID

#include <jni.h>
#include <string>
#include <unordered_map>
#include <vector>

NS_VIGAME_BEGIN

class JNIHelper
{
public:
	//static void Init(void* activity, const char* package_name);
	static void setJavaVM(JavaVM* jvm);
	static JavaVM* getJavaVM();
	static JNIEnv* getEnv();
	static jobject getContext();
	static jclass findClass(const char* name);
	static JNIEnv* cacheEnv(JavaVM* jvm);

	static std::string jstring2string(jstring jstr);
	static std::string jstring2string(JNIEnv* env, jstring jstr);
	static jobject map2JavaHashMap(const std::unordered_map<std::string, std::string>& map);
	static std::unordered_map<std::string, std::string> javaHashMap2Map(jobject& jobject_param);
	static std::unordered_map<std::string, std::string> javaHashMap2Map(jobject& jobject_param, std::vector<std::string>& keylist);
};

NS_VIGAME_END

#endif