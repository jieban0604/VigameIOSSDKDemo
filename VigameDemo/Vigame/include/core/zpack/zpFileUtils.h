#pragma once

#include "core/macros.h"
#include "core/base/log.h"
#include "zpack.h"
#include <list>
#include <unordered_map>
#include <string>
#include <memory>
#include <vector>
#define  LOGZPFILE(...)  vigame::log2("zpFileLog", __VA_ARGS__)

namespace zp
{
struct OpenedFileInfo 
{
	std::string filePath;
	FILE*   fp;
	int     fd;
	off_t	start;
	off_t	length;

	OpenedFileInfo() :filePath(""), fp(nullptr), fd(-1), start(0), length(0) {}
};

class VIGAME_DECL FileUtils
{
public:
	FileUtils() = default;
	~FileUtils();

	static FileUtils* getInstance();

	int addZpkFile(const std::string& zpkFilePath);

	bool isFileExist(const std::string& filename);
	bool isFileExist(const std::string& zpkFilePath, const std::string& filename);

	size_t getFileSize(const std::string &filename);

	std::string getFileData(const std::string& filename);
	std::string getFileData(const std::string& zpkFilePath, const std::string& filename);

	size_t readFile(const std::string& filename, void* des, size_t& size);

	std::string getFilePath(const std::string& filename);       //获取释放文件路径(暂仅ios需要)
	OpenedFileInfo getOpenedFile(const std::string& filename);  //获取打开文件的信息(android播放音乐需要用到)
	
	void setZpkPaths(std::vector<std::string>& files);
	const std::vector<std::string>& getZpkPaths();

protected:
	bool isFileExist(IPackage* package, const std::string& filename);
	std::string getFileData(IPackage* package, const std::string& filename);
private:
	std::unordered_map<std::string, std::shared_ptr<IPackage>> m_packages;    //zpk文件相对路径、Ipackage
	std::unordered_map<std::string, OpenedFileInfo> m_openedFiles;            //打开的文件
	std::unordered_map<std::string, std::string> m_childFilePaths;            //释放的文件
    std::vector<std::string> m_zpkfiles;//added zpkfile
    
};

}
