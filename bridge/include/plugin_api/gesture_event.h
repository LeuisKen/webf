// Generated by WebF TSDL, don't edit this file directly.
// Generate command: node scripts/generate_binding_code.js
/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */
#ifndef WEBF_CORE_WEBF_API_PLUGIN_API_GESTURE_EVENT_H_
#define WEBF_CORE_WEBF_API_PLUGIN_API_GESTURE_EVENT_H_
#include <stdint.h>
#include "script_value_ref.h"
#include "event.h"
namespace webf {
class SharedExceptionState;
class ExecutingContext;
class GestureEvent;
typedef struct ScriptValueRef ScriptValueRef;
using PublicGestureEventGetState = const char* (*)(GestureEvent*);
using PublicGestureEventDupState = const char* (*)(GestureEvent*);
using PublicGestureEventGetDirection = const char* (*)(GestureEvent*);
using PublicGestureEventDupDirection = const char* (*)(GestureEvent*);
using PublicGestureEventGetDeltaX = double (*)(GestureEvent*);
using PublicGestureEventGetDeltaY = double (*)(GestureEvent*);
using PublicGestureEventGetVelocityX = double (*)(GestureEvent*);
using PublicGestureEventGetVelocityY = double (*)(GestureEvent*);
using PublicGestureEventGetScale = double (*)(GestureEvent*);
using PublicGestureEventGetRotation = double (*)(GestureEvent*);
struct GestureEventPublicMethods : public WebFPublicMethods {
  static const char* State(GestureEvent* gesture_event);
  static const char* DupState(GestureEvent* gesture_event);
  static const char* Direction(GestureEvent* gesture_event);
  static const char* DupDirection(GestureEvent* gesture_event);
  static double DeltaX(GestureEvent* gesture_event);
  static double DeltaY(GestureEvent* gesture_event);
  static double VelocityX(GestureEvent* gesture_event);
  static double VelocityY(GestureEvent* gesture_event);
  static double Scale(GestureEvent* gesture_event);
  static double Rotation(GestureEvent* gesture_event);
  double version{1.0};
  EventPublicMethods event;
  PublicGestureEventGetState gesture_event_get_state{State};
  PublicGestureEventDupState gesture_event_dup_state{DupState};
  PublicGestureEventGetDirection gesture_event_get_direction{Direction};
  PublicGestureEventDupDirection gesture_event_dup_direction{DupDirection};
  PublicGestureEventGetDeltaX gesture_event_get_delta_x{DeltaX};
  PublicGestureEventGetDeltaY gesture_event_get_delta_y{DeltaY};
  PublicGestureEventGetVelocityX gesture_event_get_velocity_x{VelocityX};
  PublicGestureEventGetVelocityY gesture_event_get_velocity_y{VelocityY};
  PublicGestureEventGetScale gesture_event_get_scale{Scale};
  PublicGestureEventGetRotation gesture_event_get_rotation{Rotation};
};
}  // namespace webf
#endif  // WEBF_CORE_WEBF_API_PLUGIN_API_GESTURE_EVENT_H_