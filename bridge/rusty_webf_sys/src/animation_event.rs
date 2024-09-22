/*
* Copyright (C) 2022-present The WebF authors. All rights reserved.
*/
use std::ffi::*;
use crate::*;
#[repr(C)]
pub struct AnimationEventRustMethods {
  pub version: c_double,
  pub animation_name: extern "C" fn(ptr: *const OpaquePtr) -> *const c_char,
  pub elapsed_time: extern "C" fn(ptr: *const OpaquePtr) -> f64,
  pub pseudo_element: extern "C" fn(ptr: *const OpaquePtr) -> *const c_char,
}
pub struct AnimationEvent {
  pub ptr: *const OpaquePtr,
  context: *const ExecutingContext,
  method_pointer: *const AnimationEventRustMethods,
}
impl AnimationEvent {
  pub fn initialize(ptr: *const OpaquePtr, context: *const ExecutingContext, method_pointer: *const AnimationEventRustMethods) -> AnimationEvent {
    AnimationEvent {
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
  pub fn animation_name(&self) -> String {
    let value = unsafe {
      ((*self.method_pointer).animation_name)(self.ptr)
    };
    let value = unsafe { std::ffi::CStr::from_ptr(value) };
    let value = value.to_str().unwrap();
    value.to_string()
  }
  pub fn elapsed_time(&self) -> f64 {
    let value = unsafe {
      ((*self.method_pointer).elapsed_time)(self.ptr)
    };
    value
  }
  pub fn pseudo_element(&self) -> String {
    let value = unsafe {
      ((*self.method_pointer).pseudo_element)(self.ptr)
    };
    let value = unsafe { std::ffi::CStr::from_ptr(value) };
    let value = value.to_str().unwrap();
    value.to_string()
  }
}