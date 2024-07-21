/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

#ifndef WEBF_CORE_WEBF_API_EVENT_TARGET_H_
#define WEBF_CORE_WEBF_API_EVENT_TARGET_H_

#include "webf_value.h"

namespace webf {

typedef struct EventTarget EventTarget;
typedef struct SharedExceptionState SharedExceptionState;
typedef struct ExecutingContext ExecutingContext;
typedef struct Event Event;
typedef struct WebFEventListenerContext WebFEventListenerContext;

struct WebFAddEventListenerOptions {
  bool passive;
  bool once;
  bool capture;
};

using WebFImplEventCallback = void (*)(WebFEventListenerContext* callback_context, Event* event, SharedExceptionState* shared_exception_state);

struct WebFEventListenerContext {
  WebFImplEventCallback callback;
  void* ptr;
};

using WebFEventTargetAddEventListener = void (*)(EventTarget* event_target,
                                                 const char*,
                                                 WebFEventListenerContext* callback_context,
                                                 WebFAddEventListenerOptions* options,
                                                 SharedExceptionState* shared_exception_state);

using WebFEventTargetRelease = void (*)(EventTarget*);

struct EventTargetWebFMethods : public WebFPublicMethods {
  static void AddEventListener(EventTarget* event_target,
                               const char* event_name_str,
                               WebFEventListenerContext* callback_context,
                               WebFAddEventListenerOptions* options,
                               SharedExceptionState* shared_exception_state);
  static void Release(EventTarget* event_target);

  double version{1.0};
  WebFEventTargetAddEventListener webf_event_target_add_event_listener{AddEventListener};
  WebFEventTargetRelease event_target_release{Release};
};

}  // namespace webf

#endif  // WEBF_CORE_WEBF_API_EVENT_TARGET_H_
