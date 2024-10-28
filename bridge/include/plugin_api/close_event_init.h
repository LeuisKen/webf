// Generated by WebF TSDL, don't edit this file directly.
// Generate command: node scripts/generate_binding_code.js
/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */
#ifndef WEBF_CORE_WEBF_API_PLUGIN_API_CLOSE_EVENT_INIT_H_
#define WEBF_CORE_WEBF_API_PLUGIN_API_CLOSE_EVENT_INIT_H_
#include <stdint.h>
#include "webf_value.h"
namespace webf {
struct WebFCloseEventInit {
  int32_t bubbles;
  int32_t cancelable;
  int32_t composed;
  int64_t code;
  const char* reason;
  int32_t was_clean;
};
}  // namespace webf
#endif  // WEBF_CORE_WEBF_API_PLUGIN_API_CLOSE_EVENT_INIT_H_