// Generated by WebF TSDL, don't edit this file directly.
// Generate command: node scripts/generate_binding_code.js
/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */
#ifndef WEBF_CORE_WEBF_API_PLUGIN_API_ADD_EVENT_LISTENER_OPTIONS_H_
#define WEBF_CORE_WEBF_API_PLUGIN_API_ADD_EVENT_LISTENER_OPTIONS_H_
#include <stdint.h>
#include "webf_value.h"
namespace webf {
struct WebFAddEventListenerOptions {
  int32_t capture;
  int32_t passive;
  int32_t once;
};
}  // namespace webf
#endif  // WEBF_CORE_WEBF_API_PLUGIN_API_ADD_EVENT_LISTENER_OPTIONS_H_