#ifndef __VIGAME_FILEUTILS_WIN32_H__
#define __VIGAME_FILEUTILS_WIN32_H__

#include "core/macros.h"
#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_WIN32

#include "core/FileUtils.h"
#include <string>
#include <vector>

NS_VIGAME_BEGIN

class VIGAME_DECL FileUtilsWin32 : public FileUtils
{
    friend class FileUtils;

public:
    FileUtilsWin32() = default;

    /* override functions */
    bool init();
    virtual std::string getWritablePath() const override;
    virtual bool isAbsolutePath(const std::string& strPath) const override;
    virtual std::string getSuitableFOpen(const std::string& filenameUtf8) const override;
    virtual size_t getFileSizeNormal(const std::string &filename);
protected:

    virtual bool isFileExistInternal(const std::string& strFilePath) const override;

    virtual bool renameFile(const std::string &path, const std::string &oldname, const std::string &name) override;
    virtual bool renameFile(const std::string &oldfullpath, const std::string &newfullpath) override;

    /**
    *  Checks whether a directory exists without considering search paths and resolution orders.
    *  @param dirPath The directory (with absolute path) to look up for
    *  @return Returns true if the directory found at the given absolute path, otherwise returns false
    */
    virtual bool isDirectoryExistInternal(const std::string& dirPath) const override;

    virtual bool removeFile(const std::string &filepath) override;

    virtual bool createDirectory(const std::string& dirPath) override;

    virtual bool removeDirectory(const std::string& dirPath) override;
    
    //virtual std::string getFileData(const std::string& filename) override;

	virtual size_t readFileNormal(const std::string& filename, void* des, size_t& size);

    virtual std::string getPathForFilename(const std::string& filename, const std::string& resolutionDirectory, const std::string& searchPath) const override;

    virtual std::string getFullPathForDirectoryAndFilename(const std::string& directory, const std::string& filename) const override;
};

// end of platform group
/// @}

NS_VIGAME_END

#endif // VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_WIN32

#endif    // __VIGMAE_FILEUTILS_WIN32_H__

