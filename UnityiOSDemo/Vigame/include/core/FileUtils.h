#pragma once

#include "core/macros.h"
#include "core/base/log.h"
#include <string>
#include <vector>
#include <unordered_map>

NS_VIGAME_BEGIN

#define  LOGFILE(...)  log2("FileLog", __VA_ARGS__)

class VIGAME_DECL FileUtils
{
public:
	static FileUtils* getInstance();

	virtual ~FileUtils();

	virtual void purgeCachedEntries();

	virtual std::string getFileData(const std::string& filename);

	virtual std::string getFileDataZpk(const std::string& filename);

	virtual std::string getFileDataNormal(const std::string& filename);

	virtual size_t readFile(const std::string& filename, void* des, size_t& size);

	virtual size_t readFileZpk(const std::string& filename, void* des, size_t& size);

	virtual size_t readFileNormal(const std::string& filename, void* des, size_t& size);

	//virtual unsigned char* getFileDataFromZip(const std::string& zipFilePath, const std::string& filename, ssize_t *size);

	virtual std::string fullPathForFilename(const std::string &filename) const;

	virtual std::string fullPathFromRelativeFile(const std::string &filename, const std::string &relativeFile);

	virtual void setSearchResolutionsOrder(const std::vector<std::string>& searchResolutionsOrder);

	virtual void addSearchResolutionsOrder(const std::string &order, const bool front = false);

	virtual const std::vector<std::string>& getSearchResolutionsOrder() const;

	virtual void setSearchPaths(const std::vector<std::string>& searchPaths);

	void setDefaultResourceRootPath(const std::string& path);

	void addSearchPath(const std::string & path, const bool front = false);

	virtual const std::vector<std::string>& getSearchPaths() const;

	virtual std::string getExternalPath() const; // 获取sd卡里包名的文件夹，为空时返回 getWritablePath

	virtual std::string getWritablePath() const = 0;

	virtual void setWritablePath(const std::string& writablePath);

	virtual bool writeStringToFile(const std::string& dataStr, const std::string& fullPath);

	virtual bool writeDataToFile(const std::string& data, const std::string& fullPath);

	/**
	* Windows fopen can't support UTF-8 filename
	* Need convert all parameters fopen and other 3rd-party libs
	*
	* @param filenameUtf8 std::string name file for conversion from utf-8
	* @return std::string ansi filename in current locale
	*/
	virtual std::string getSuitableFOpen(const std::string& filenameUtf8) const;

	virtual bool isFileExist(const std::string& filename) const;

	virtual std::string getFileExtension(const std::string& filePath) const;

	/**
	*  Checks whether the path is an absolute path.
	*
	*  @note On Android, if the parameter passed in is relative to "assets/", this method will treat it as an absolute path.
	*        Also on Blackberry, path starts with "app/native/Resources/" is treated as an absolute path.
	*
	*  @param path The path that needs to be checked.
	*  @return True if it's an absolute path, false if not.
	*/
	virtual bool isAbsolutePath(const std::string& path) const;

	/**
	*  Checks whether the path is a directory.
	*
	*  @param dirPath The path of the directory, it could be a relative or an absolute path.
	*  @return True if the directory exists, false if not.
	*/
	virtual bool isDirectoryExist(const std::string& dirPath) const;

	/**
	*  Creates a directory.
	*
	*  @param dirPath The path of the directory, it must be an absolute path.
	*  @return True if the directory have been created successfully, false if not.
	*/
	virtual bool createDirectory(const std::string& dirPath);

	/**
	*  Removes a directory.
	*
	*  @param dirPath  The full path of the directory, it must be an absolute path.
	*  @return True if the directory have been removed successfully, false if not.
	*/
	virtual bool removeDirectory(const std::string& dirPath);

	/**
	*  Removes a file.
	*
	*  @param filepath The full path of the file, it must be an absolute path.
	*  @return True if the file have been removed successfully, false if not.
	*/
	virtual bool removeFile(const std::string &filepath);

	/**
	*  Renames a file under the given directory.
	*
	*  @param path     The parent directory path of the file, it must be an absolute path.
	*  @param oldname  The current name of the file.
	*  @param name     The new name of the file.
	*  @return True if the file have been renamed successfully, false if not.
	*/
	virtual bool renameFile(const std::string &path, const std::string &oldname, const std::string &name);

	/**
	*  Renames a file under the given directory.
	*
	*  @param oldfullpath  The current fullpath of the file. Includes path and name.
	*  @param newfullpath  The new fullpath of the file. Includes path and name.
	*  @return True if the file have been renamed successfully, false if not.
	*/
	virtual bool renameFile(const std::string &oldfullpath, const std::string &newfullpath);

	/**
	*  Retrieve the file size.
	*
	*  @note If a relative path was passed in, it will be inserted a default root path at the beginning.
	*  @param filename The path of the file, it could be a relative or absolute path.
	*  @return The file size.
	*/

	virtual size_t getFileSize(const std::string &filename);

	virtual size_t getFileSizeZpk(const std::string &filename);

	virtual size_t getFileSizeNormal(const std::string &filename);



	/** Returns the full path cache. */
	const std::unordered_map<std::string, std::string>& getFullPathCache() const { return _fullPathCache; }

	protected:
		/**
		*  The default constructor.
		*/
		FileUtils();

		/**
		*  Initializes the instance of FileUtils. It will set _searchPathArray and _searchResolutionsOrderArray to default values.
		*
		*  @note When you are porting Cocos2d-x to a new platform, you may need to take care of this method.
		*        You could assign a default value to _defaultResRootPath in the subclass of FileUtils(e.g. FileUtilsAndroid). Then invoke the FileUtils::init().
		*  @return true if succeed, otherwise it returns false.
		*
		*/
		virtual bool init();

		/**
		*  Gets the new filename from the filename lookup dictionary.
		*  It is possible to have a override names.
		*  @param filename The original filename.
		*  @return The new filename after searching in the filename lookup dictionary.
		*          If the original filename wasn't in the dictionary, it will return the original filename.
		*/
		virtual std::string getNewFilename(const std::string &filename) const;

		/**
		*  Checks whether a file exists without considering search paths and resolution orders.
		*  @param filename The file (with absolute path) to look up for
		*  @return Returns true if the file found at the given absolute path, otherwise returns false
		*/
		virtual bool isFileExistInternal(const std::string& filename) const = 0;

		/**
		*  Checks whether a directory exists without considering search paths and resolution orders.
		*  @param dirPath The directory (with absolute path) to look up for
		*  @return Returns true if the directory found at the given absolute path, otherwise returns false
		*/
		virtual bool isDirectoryExistInternal(const std::string& dirPath) const;

		/**
		*  Gets full path for filename, resolution directory and search path.
		*
		*  @param filename The file name.
		*  @param resolutionDirectory The resolution directory.
		*  @param searchPath The search path.
		*  @return The full path of the file. It will return an empty string if the full path of the file doesn't exist.
		*/
		virtual std::string getPathForFilename(const std::string& filename, const std::string& resolutionDirectory, const std::string& searchPath) const;

		/**
		*  Gets full path for the directory and the filename.
		*
		*  @note Only iOS and Mac need to override this method since they are using
		*        `[[NSBundle mainBundle] pathForResource: ofType: inDirectory:]` to make a full path.
		*        Other platforms will use the default implementation of this method.
		*  @param directory The directory contains the file we are looking for.
		*  @param filename  The name of the file.
		*  @return The full path of the file, if the file can't be found, it will return an empty string.
		*/
		virtual std::string getFullPathForDirectoryAndFilename(const std::string& directory, const std::string& filename) const;

		/** Dictionary used to lookup filenames based on a key.
		*  It is used internally by the following methods:
		*
		*  std::string fullPathForFilename(const char*);
		*
		*  @since v2.1
		*/
		//ValueMap _filenameLookupDict;

		/**
		*  The vector contains resolution folders.
		*  The lower index of the element in this vector, the higher priority for this resolution directory.
		*/
		std::vector<std::string> _searchResolutionsOrderArray;

		/**
		* The vector contains search paths.
		* The lower index of the element in this vector, the higher priority for this search path.
		*/
		std::vector<std::string> _searchPathArray;

		/**
		*  The default root path of resources.
		*  If the default root path of resources needs to be changed, do it in the `init` method of FileUtils's subclass.
		*  For instance:
		*  On Android, the default root path of resources will be assigned with "assets/" in FileUtilsAndroid::init().
		*  Similarly on Blackberry, we assign "app/native/Resources/" to this variable in FileUtilsBlackberry::init().
		*/
		std::string _defaultResRootPath;

		/**
		*  The full path cache. When a file is found, it will be added into this cache.
		*  This variable is used for improving the performance of file search.
		*/
		mutable std::unordered_map<std::string, std::string> _fullPathCache;

		/**
		* Writable path.
		*/
		std::string _writablePath;
};

NS_VIGAME_END
