#pragma once

#include "core/macros.h"
#if VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_MAC || VIGAME_TARGET_PLATFORM == VIGAME_PLATFORM_IOS

#include "core/FileUtils.h"
#include <string>
#include <vector>

NS_VIGAME_BEGIN

class VIGAME_DECL FileUtilsApple : public FileUtils
{
public:
    FileUtilsApple();
    /* override functions */
    virtual std::string getWritablePath() const override;
    virtual std::string getFullPathForDirectoryAndFilename(const std::string& directory, const std::string& filename) const override;
	void setBundle(NSBundle* bundle);
private:
    virtual bool isFileExistInternal(const std::string& filePath) const override;
    virtual bool removeDirectory(const std::string& dirPath) override;
    
    NSBundle* getBundle() const;
    NSBundle* _bundle;
};

NS_VIGAME_END

#endif

