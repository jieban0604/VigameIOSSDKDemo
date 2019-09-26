//
//  CheckVersion.h
//  TestSource
//
//  Created by DLWX on 2017/3/1.
//
//
#include <string>
#include <functional>
#include <unordered_map>

class CheckVersion{
//     std::map<std::string, std::string> m_data;
public:
    static void checkResult( std::unordered_map<std::string, std::string> params);
    
    /**
     展示弹窗
     @param code 0 没有版本更新
     @param address 下载跳转地址
     @param message 提示信息
     */
    static void showAlert(std::string code, std::string address,std::string message);
};

