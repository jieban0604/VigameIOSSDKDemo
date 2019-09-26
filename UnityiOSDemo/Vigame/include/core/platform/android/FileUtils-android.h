#pragma once

#include "core/macros.h"
#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_ANDROID

#include "core/FileUtils.h"
#include <string>
#include <vector>
#include "jni.h"
#include "android/asset_manager.h"

NS_VIGAME_BEGIN

class VIGAME_DECL FileUtilsAndroid : public FileUtils
{
    friend class FileUtils;
public:
    FileUtilsAndroid();
    /**
     * @js NA
     * @lua NA
     */
    virtual ~FileUtilsAndroid();

    static bool initAssetManager();
    static AAssetManager* getAssetManager() { return assetmanager; }

    /* override functions */
    bool init();

    virtual std::string getNewFilename(const std::string &filename) const override;

    /** @deprecated Please use FileUtils::getDataFromFile or FileUtils::getStringFromFile instead. */
	//virtual std::string getFileData(const std::string& filename) override;

	virtual size_t readFileNormal(const std::string& filename, void* des, size_t& size);

	virtual size_t getFileSizeNormal(const std::string &filename);

    virtual std::string getWritablePath() const;
	virtual std::string getExternalPath() const;
    virtual bool isAbsolutePath(const std::string& strPath) const;
    
private:
    virtual bool isFileExistInternal(const std::string& strFilePath) const override;
    virtual bool isDirectoryExistInternal(const std::string& dirPath) const override;

public:
    static AAssetManager* assetmanager;
};

// end of platform group
/// @}

NS_VIGAME_END

#endif

