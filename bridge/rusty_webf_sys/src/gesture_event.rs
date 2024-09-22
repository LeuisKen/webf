/*
* Copyright (C) 2022-present The WebF authors. All rights reserved.
*/
use std::ffi::*;
use crate::*;
#[repr(C)]
pub struct GestureEventRustMethods {
  pub version: c_double,
  pub state: extern "C" fn(ptr: *const OpaquePtr) -> *const c_char,
  pub direction: extern "C" fn(ptr: *const OpaquePtr) -> *const c_char,
  pub delta_x: extern "C" fn(ptr: *const OpaquePtr) -> f64,
  pub delta_y: extern "C" fn(ptr: *const OpaquePtr) -> f64,
  pub velocity_x: extern "C" fn(ptr: *const OpaquePtr) -> f64,
  pub velocity_y: extern "C" fn(ptr: *const OpaquePtr) -> f64,
  pub scale: extern "C" fn(ptr: *const OpaquePtr) -> f64,
  pub rotation: extern "C" fn(ptr: *const OpaquePtr) -> f64,
}
pub struct GestureEvent {
  pub ptr: *const OpaquePtr,
  context: *const ExecutingContext,
  method_pointer: *const GestureEventRustMethods,
}
impl GestureEvent {
  pub fn initialize(ptr: *const OpaquePtr, context: *const ExecutingContext, method_pointer: *const GestureEventRustMethods) -> GestureEvent {
    GestureEvent {
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
  pub fn state(&self) -> String {
    let value = unsafe {
      ((*self.method_pointer).state)(self.ptr)
    };
    let value = unsafe { std::ffi::CStr::from_ptr(value) };
    let value = value.to_str().unwrap();
    value.to_string()
  }
  pub fn direction(&self) -> String {
    let value = unsafe {
      ((*self.method_pointer).direction)(self.ptr)
    };
    let value = unsafe { std::ffi::CStr::from_ptr(value) };
    let value = value.to_str().unwrap();
    value.to_string()
  }
  pub fn delta_x(&self) -> f64 {
    let value = unsafe {
      ((*self.method_pointer).delta_x)(self.ptr)
    };
    value
  }
  pub fn delta_y(&self) -> f64 {
    let value = unsafe {
      ((*self.method_pointer).delta_y)(self.ptr)
    };
    value
  }
  pub fn velocity_x(&self) -> f64 {
    let value = unsafe {
      ((*self.method_pointer).velocity_x)(self.ptr)
    };
    value
  }
  pub fn velocity_y(&self) -> f64 {
    let value = unsafe {
      ((*self.method_pointer).velocity_y)(self.ptr)
    };
    value
  }
  pub fn scale(&self) -> f64 {
    let value = unsafe {
      ((*self.method_pointer).scale)(self.ptr)
    };
    value
  }
  pub fn rotation(&self) -> f64 {
    let value = unsafe {
      ((*self.method_pointer).rotation)(self.ptr)
    };
    value
  }
}