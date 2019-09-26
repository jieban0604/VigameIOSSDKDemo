#pragma once

#include "core/macros.h"
#include <string>
#include <functional>
#include <chrono>

NS_VIGAME_BEGIN

namespace http
{
struct VIGAME_DECL options
{
	bool follow_redirects;//是否允许http重定向
	bool cache_resolved;//缓存端点
	int timeout;//超时时间(秒)
	int connecttimeout;//连接超时时间(秒)

	options() :follow_redirects(true), cache_resolved(false), timeout(60), connecttimeout(30) {}
};

struct response
{
	enum status_type {
		continue_http = 100,
		switching_protocols = 101,
		ok = 200,
		created = 201,
		accepted = 202,
		non_authoritative_information = 203,
		no_content = 204,
		reset_content = 205,
		partial_content = 206,
		multiple_choices = 300,
		moved_permanently = 301,
		moved_temporarily = 302,  ///< \deprecated Not HTTP standard
		found = 302,
		see_other = 303,
		not_modified = 304,
		use_proxy = 305,
		temporary_redirect = 307,
		bad_request = 400,
		unauthorized = 401,
		payment_required = 402,
		forbidden = 403,
		not_found = 404,
		not_supported = 405,  ///< \deprecated Not HTTP standard
		method_not_allowed = 405,
		not_acceptable = 406,
		proxy_authentication_required = 407,
		request_timeout = 408,
		conflict = 409,
		gone = 410,
		length_required = 411,
		precondition_failed = 412,
		request_entity_too_large = 413,
		request_uri_too_large = 414,
		unsupported_media_type = 415,
		unsatisfiable_range = 416,  ///< \deprecated Not HTTP standard
		requested_range_not_satisfiable = 416,
		expectation_failed = 417,
		precondition_required = 428,
		too_many_requests = 429,
		request_header_fields_too_large = 431,
		internal_server_error = 500,
		not_implemented = 501,
		bad_gateway = 502,
		service_unavailable = 503,
		gateway_timeout = 504,
		http_version_not_supported = 505,
		space_unavailable = 507,
		network_authentication_required = 511
	};

	int status;
	std::string status_message;
	std::string version;
	std::string source;
	std::string destination;
	std::string body;
	std::chrono::steady_clock::duration duration;

	response() :status(status_type::internal_server_error), status_message(""), version(""), source(""), destination(""), body(""){}
};

typedef VIGAME_DECL std::function<void(response)> HttpCallback;

response VIGAME_DECL get(const std::string& url);

response VIGAME_DECL get(const std::string& url, options opt);

void VIGAME_DECL get(const std::string& url, HttpCallback callback);

void VIGAME_DECL get(const std::string& url, HttpCallback callback, options opt);


response VIGAME_DECL post(const std::string& url, const std::string& data);

response VIGAME_DECL post(const std::string& url, const std::string& data, options opt);

void VIGAME_DECL post(const std::string& url, const std::string& data, HttpCallback callback);

void VIGAME_DECL post(const std::string& url, const std::string& data, HttpCallback callback, options opt);


}

NS_VIGAME_END