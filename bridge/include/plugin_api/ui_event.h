/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */
#ifndef WEBF_CORE_WEBF_API_PLUGIN_API_UI_EVENT_H_
#define WEBF_CORE_WEBF_API_PLUGIN_API_UI_EVENT_H_
#include <stdint.h>
#include "event.h"
namespace webf {
typedef struct Window Window;
typedef struct WindowPublicMethods WindowPublicMethods;
typedef struct SharedExceptionState SharedExceptionState;
typedef struct ExecutingContext ExecutingContext;
typedef struct UIEvent UIEvent;
using PublicUIEventGetDetail = double (*)(UIEvent*);
using PublicUIEventGetView = WebFValue<Window, WindowPublicMethods> (*)(UIEvent*);
using PublicUIEventGetWhich = double (*)(UIEvent*);
struct UIEventPublicMethods : public WebFPublicMethods {
  static double Detail(UIEvent* uiEvent);
  static WebFValue<Window, WindowPublicMethods> View(UIEvent* uiEvent);
  static double Which(UIEvent* uiEvent);
  double version{1.0};
  PublicUIEventGetDetail ui_event_get_detail{Detail};
  PublicUIEventGetView ui_event_get_view{View};
  PublicUIEventGetWhich ui_event_get_which{Which};
};
}  // namespace webf
#endif // WEBF_CORE_WEBF_API_PLUGIN_API_UI_EVENT_H_