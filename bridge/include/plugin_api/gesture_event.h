/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */
#ifndef WEBF_CORE_WEBF_API_PLUGIN_API_GESTURE_EVENT_H_
#define WEBF_CORE_WEBF_API_PLUGIN_API_GESTURE_EVENT_H_
#include <stdint.h>
#include "event.h"
namespace webf {
typedef struct SharedExceptionState SharedExceptionState;
typedef struct ExecutingContext ExecutingContext;
typedef struct GestureEvent GestureEvent;
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
  static const char* State(GestureEvent* gestureEvent);
  static const char* DupState(GestureEvent* gestureEvent);
  static const char* Direction(GestureEvent* gestureEvent);
  static const char* DupDirection(GestureEvent* gestureEvent);
  static double DeltaX(GestureEvent* gestureEvent);
  static double DeltaY(GestureEvent* gestureEvent);
  static double VelocityX(GestureEvent* gestureEvent);
  static double VelocityY(GestureEvent* gestureEvent);
  static double Scale(GestureEvent* gestureEvent);
  static double Rotation(GestureEvent* gestureEvent);
  double version{1.0};
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
#endif // WEBF_CORE_WEBF_API_PLUGIN_API_GESTURE_EVENT_H_