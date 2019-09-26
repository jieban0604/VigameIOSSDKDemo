/*
  Copyright (c) 2005-2012 by Jakob Schroeter <js@camaya.net>
  This file is part of the gloox library. http://camaya.net/gloox

  This software is distributed under a license. The full license
  agreement can be found in the file LICENSE in this distribution.
  This software may not be copied, modified, sold or distributed
  other than expressed in the named license agreement.

  This software is distributed without any warranty.
*/


#ifndef __VIGAME_BASE64_H__
#define __VIGAME_BASE64_H__

#include "core/macros.h"
#include <string>

NS_VIGAME_BEGIN
/**
* Base64-encodes the input according to RFC 3548.
* @param input The data to encode.
* @return The encoded string.
*/
std::string VIGAME_DECL base64_encode(const std::string& input);

/**
* Base64-decodes the input according to RFC 3548.
* @param input The encoded data.
* @return The decoded data.
*/
std::string VIGAME_DECL base64_decode(const std::string& input);

NS_VIGAME_END

#endif
