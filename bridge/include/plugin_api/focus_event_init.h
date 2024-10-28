// Generated by WebF TSDL, don't edit this file directly.
// Generate command: node scripts/generate_binding_code.js
// clang-format off
/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */
#ifndef WEBF_CORE_WEBF_API_PLUGIN_API_FOCUS_EVENT_INIT_H_
#define WEBF_CORE_WEBF_API_PLUGIN_API_FOCUS_EVENT_INIT_H_
#include <stdint.h>
#include "webf_value.h"
namespace webf {
typedef struct EventTarget EventTarget;
typedef struct EventTargetPublicMethods EventTargetPublicMethods;
typedef struct Window Window;
typedef struct WindowPublicMethods WindowPublicMethods;
struct WebFFocusEventInit {
  double detail;
  WebFValue<Window, WindowPublicMethods> view;
  double which;
  WebFValue<EventTarget, EventTargetPublicMethods> related_target;
};
}  // namespace webf
#endif  // WEBF_CORE_WEBF_API_PLUGIN_API_FOCUS_EVENT_INIT_H_