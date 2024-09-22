/*
* Copyright (C) 2022-present The WebF authors. All rights reserved.
*/
use std::ffi::*;
use crate::*;
#[repr(C)]
pub struct EventRustMethods {
  pub version: c_double,
  pub bubbles: extern "C" fn(ptr: *const OpaquePtr) -> bool,
  pub cancel_bubble: extern "C" fn(ptr: *const OpaquePtr) -> bool,
  pub set_cancel_bubble: extern "C" fn(ptr: *const OpaquePtr, value: bool, exception_state: *const OpaquePtr) -> bool,
  pub cancelable: extern "C" fn(ptr: *const OpaquePtr) -> bool,
  pub current_target: extern "C" fn(ptr: *const OpaquePtr) -> RustValue<EventTargetRustMethods>,
  pub default_prevented: extern "C" fn(ptr: *const OpaquePtr) -> bool,
  pub src_element: extern "C" fn(ptr: *const OpaquePtr) -> RustValue<EventTargetRustMethods>,
  pub target: extern "C" fn(ptr: *const OpaquePtr) -> RustValue<EventTargetRustMethods>,
  pub is_trusted: extern "C" fn(ptr: *const OpaquePtr) -> bool,
  pub time_stamp: extern "C" fn(ptr: *const OpaquePtr) -> f64,
  pub type_: extern "C" fn(ptr: *const OpaquePtr) -> *const c_char,
  pub init_event: extern "C" fn(ptr: *const OpaquePtr, *const c_char, bool, bool, exception_state: *const OpaquePtr) -> c_void,
  pub prevent_default: extern "C" fn(ptr: *const OpaquePtr, exception_state: *const OpaquePtr) -> c_void,
  pub stop_immediate_propagation: extern "C" fn(ptr: *const OpaquePtr, exception_state: *const OpaquePtr) -> c_void,
  pub stop_propagation: extern "C" fn(ptr: *const OpaquePtr, exception_state: *const OpaquePtr) -> c_void,
  pub release: extern "C" fn(ptr: *const OpaquePtr) -> c_void,
}
pub struct Event {
  pub ptr: *const OpaquePtr,
  context: *const ExecutingContext,
  method_pointer: *const EventRustMethods,
}
impl Event {
  pub fn initialize(ptr: *const OpaquePtr, context: *const ExecutingContext, method_pointer: *const EventRustMethods) -> Event {
    Event {
      ptr,
      context,
      method_pointer,
    }
  }
  pub fn ptr(&self) -> *const OpaquePtr {
    self.ptr
  }
  pub fn context<'a>(&self) -> &'a ExecutingContext {
    assert!(!self.context.is_null(), "Context PTR must not be null");
    unsafe { &*self.context }
  }
  pub fn bubbles(&self) -> bool {
    let value = unsafe {
      ((*self.method_pointer).bubbles)(self.ptr)
    };
    value
  }
  pub fn cancel_bubble(&self) -> bool {
    let value = unsafe {
      ((*self.method_pointer).cancel_bubble)(self.ptr)
    };
    value
  }
  pub fn set_cancel_bubble(&self, value: bool, exception_state: &ExceptionState) -> Result<(), String> {
    let result = unsafe {
      ((*self.method_pointer).set_cancel_bubble)(self.ptr, value, exception_state.ptr)
    };
    if exception_state.has_exception() {
      return Err(exception_state.stringify(self.context()));
    }
    Ok(())
  }
  pub fn cancelable(&self) -> bool {
    let value = unsafe {
      ((*self.method_pointer).cancelable)(self.ptr)
    };
    value
  }
  pub fn current_target(&self) -> EventTarget {
    let value = unsafe {
      ((*self.method_pointer).current_target)(self.ptr)
    };
    EventTarget::initialize(value.value, self.context, value.method_pointer)
  }
  pub fn default_prevented(&self) -> bool {
    let value = unsafe {
      ((*self.method_pointer).default_prevented)(self.ptr)
    };
    value
  }
  pub fn src_element(&self) -> EventTarget {
    let value = unsafe {
      ((*self.method_pointer).src_element)(self.ptr)
    };
    EventTarget::initialize(value.value, self.context, value.method_pointer)
  }
  pub fn target(&self) -> EventTarget {
    let value = unsafe {
      ((*self.method_pointer).target)(self.ptr)
    };
    EventTarget::initialize(value.value, self.context, value.method_pointer)
  }
  pub fn is_trusted(&self) -> bool {
    let value = unsafe {
      ((*self.method_pointer).is_trusted)(self.ptr)
    };
    value
  }
  pub fn time_stamp(&self) -> f64 {
    let value = unsafe {
      ((*self.method_pointer).time_stamp)(self.ptr)
    };
    value
  }
  pub fn type_(&self) -> String {
    let value = unsafe {
      ((*self.method_pointer).type_)(self.ptr)
    };
    let value = unsafe { std::ffi::CStr::from_ptr(value) };
    let value = value.to_str().unwrap();
    value.to_string()
  }
  pub fn init_event(&self, type_: &str, bubbles: bool, cancelable: bool, exception_state: &ExceptionState) -> Result<(), String> {
    unsafe {
      ((*self.method_pointer).init_event)(self.ptr, CString::new(type_).unwrap().as_ptr(), bubbles, cancelable, exception_state.ptr);
    };
    if exception_state.has_exception() {
      return Err(exception_state.stringify(self.context()));
    }
    Ok(())
  }
  pub fn prevent_default(&self, exception_state: &ExceptionState) -> Result<(), String> {
    unsafe {
      ((*self.method_pointer).prevent_default)(self.ptr, exception_state.ptr);
    };
    if exception_state.has_exception() {
      return Err(exception_state.stringify(self.context()));
    }
    Ok(())
  }
  pub fn stop_immediate_propagation(&self, exception_state: &ExceptionState) -> Result<(), String> {
    unsafe {
      ((*self.method_pointer).stop_immediate_propagation)(self.ptr, exception_state.ptr);
    };
    if exception_state.has_exception() {
      return Err(exception_state.stringify(self.context()));
    }
    Ok(())
  }
  pub fn stop_propagation(&self, exception_state: &ExceptionState) -> Result<(), String> {
    unsafe {
      ((*self.method_pointer).stop_propagation)(self.ptr, exception_state.ptr);
    };
    if exception_state.has_exception() {
      return Err(exception_state.stringify(self.context()));
    }
    Ok(())
  }
}
impl Drop for Event {
  fn drop(&mut self) {
    unsafe {
      ((*self.method_pointer).release)(self.ptr);
    }
  }
}