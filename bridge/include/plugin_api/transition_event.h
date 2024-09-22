/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */
#ifndef WEBF_CORE_WEBF_API_PLUGIN_API_TRANSITION_EVENT_H_
#define WEBF_CORE_WEBF_API_PLUGIN_API_TRANSITION_EVENT_H_
#include <stdint.h>
#include "event.h"
namespace webf {
typedef struct SharedExceptionState SharedExceptionState;
typedef struct ExecutingContext ExecutingContext;
typedef struct TransitionEvent TransitionEvent;
using PublicTransitionEventGetElapsedTime = double (*)(TransitionEvent*);
using PublicTransitionEventGetPropertyName = const char* (*)(TransitionEvent*);
using PublicTransitionEventDupPropertyName = const char* (*)(TransitionEvent*);
using PublicTransitionEventGetPseudoElement = const char* (*)(TransitionEvent*);
using PublicTransitionEventDupPseudoElement = const char* (*)(TransitionEvent*);
struct TransitionEventPublicMethods : public WebFPublicMethods {
  static double ElapsedTime(TransitionEvent* transitionEvent);
  static const char* PropertyName(TransitionEvent* transitionEvent);
  static const char* DupPropertyName(TransitionEvent* transitionEvent);
  static const char* PseudoElement(TransitionEvent* transitionEvent);
  static const char* DupPseudoElement(TransitionEvent* transitionEvent);
  double version{1.0};
  PublicTransitionEventGetElapsedTime transition_event_get_elapsed_time{ElapsedTime};
  PublicTransitionEventGetPropertyName transition_event_get_property_name{PropertyName};
  PublicTransitionEventDupPropertyName transition_event_dup_property_name{DupPropertyName};
  PublicTransitionEventGetPseudoElement transition_event_get_pseudo_element{PseudoElement};
  PublicTransitionEventDupPseudoElement transition_event_dup_pseudo_element{DupPseudoElement};
};
}  // namespace webf
#endif // WEBF_CORE_WEBF_API_PLUGIN_API_TRANSITION_EVENT_H_