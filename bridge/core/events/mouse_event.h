/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

#ifndef WEBF_CORE_EVENTS_MOUSE_EVENT_H_
#define WEBF_CORE_EVENTS_MOUSE_EVENT_H_

#include "qjs_mouse_event_init.h"
#include "ui_event.h"

namespace webf {

struct NativeMouseEvent;

class MouseEvent : public UIEvent {
  DEFINE_WRAPPERTYPEINFO();

 public:
  using ImplType = MouseEvent*;

  static MouseEvent* Create(ExecutingContext* context, const AtomicString& type, ExceptionState& exception_state);

  static MouseEvent* Create(ExecutingContext* context,
                            const AtomicString& type,
                            const std::shared_ptr<MouseEventInit>& initializer,
                            ExceptionState& exception_state);

  explicit MouseEvent(ExecutingContext* context, const AtomicString& type, ExceptionState& exception_state);

  explicit MouseEvent(ExecutingContext* context,
                      const AtomicString& type,
                      const std::shared_ptr<MouseEventInit>& initializer,
                      ExceptionState& exception_state);

  explicit MouseEvent(ExecutingContext* context, const AtomicString& type, NativeMouseEvent* native_mouse_event);

  bool altKey() const;
  double button() const;
  double buttons() const;
  double clientX() const;
  double clientY() const;
  bool ctrlKey() const;
  bool metaKey() const;
  double movementX() const;
  double movementY() const;
  double offsetX() const;
  double offsetY() const;
  double pageX() const;
  double pageY() const;
  double screenX() const;
  double screenY() const;
  bool shiftKey() const;
  double x() const;
  double y() const;
  EventTarget* relatedTarget() const;

  void Trace(GCVisitor* visitor) const override;

  bool IsMouseEvent() const override;

 private:
  bool alt_key_;
  double button_;
  double buttons_;
  double client_x_;
  double client_y_;
  bool ctrl_key_;
  bool meta_key_;
  double movement_x_;
  double movement_y_;
  double offset_x_;
  double offset_y_;
  double page_x_;
  double page_y_;
  double screen_x_;
  double screen_y_;
  bool shift_key_;
  double x_;
  double y_;
  Member<EventTarget> related_target_;
};

}  // namespace webf

#endif  // WEBF_CORE_EVENTS_TOUCH_EVENT_H_
