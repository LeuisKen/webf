/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */
#ifndef WEBF_CORE_WEBF_API_PLUGIN_API_CLOSE_EVENT_H_
#define WEBF_CORE_WEBF_API_PLUGIN_API_CLOSE_EVENT_H_
#include <stdint.h>
#include "event.h"
namespace webf {
typedef struct SharedExceptionState SharedExceptionState;
typedef struct ExecutingContext ExecutingContext;
typedef struct CloseEvent CloseEvent;
using PublicCloseEventGetCode = int64_t (*)(CloseEvent*);
using PublicCloseEventGetReason = const char* (*)(CloseEvent*);
using PublicCloseEventDupReason = const char* (*)(CloseEvent*);
using PublicCloseEventGetWasClean = bool (*)(CloseEvent*);
struct CloseEventPublicMethods : public WebFPublicMethods {
  static int64_t Code(CloseEvent* closeEvent);
  static const char* Reason(CloseEvent* closeEvent);
  static const char* DupReason(CloseEvent* closeEvent);
  static bool WasClean(CloseEvent* closeEvent);
  double version{1.0};
  PublicCloseEventGetCode close_event_get_code{Code};
  PublicCloseEventGetReason close_event_get_reason{Reason};
  PublicCloseEventDupReason close_event_dup_reason{DupReason};
  PublicCloseEventGetWasClean close_event_get_was_clean{WasClean};
};
}  // namespace webf
#endif // WEBF_CORE_WEBF_API_PLUGIN_API_CLOSE_EVENT_H_