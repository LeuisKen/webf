/*
* Copyright (C) 2022-present The WebF authors. All rights reserved.
*/
use std::ffi::*;
use crate::*;
#[repr(C)]
pub struct HashchangeEventRustMethods {
  pub version: c_double,
  pub new_url: extern "C" fn(ptr: *const OpaquePtr) -> *const c_char,
  pub old_url: extern "C" fn(ptr: *const OpaquePtr) -> *const c_char,
}
pub struct HashchangeEvent {
  pub ptr: *const OpaquePtr,
  context: *const ExecutingContext,
  method_pointer: *const HashchangeEventRustMethods,
}
impl HashchangeEvent {
  pub fn initialize(ptr: *const OpaquePtr, context: *const ExecutingContext, method_pointer: *const HashchangeEventRustMethods) -> HashchangeEvent {
    HashchangeEvent {
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
  pub fn new_url(&self) -> String {
    let value = unsafe {
      ((*self.method_pointer).new_url)(self.ptr)
    };
    let value = unsafe { std::ffi::CStr::from_ptr(value) };
    let value = value.to_str().unwrap();
    value.to_string()
  }
  pub fn old_url(&self) -> String {
    let value = unsafe {
      ((*self.method_pointer).old_url)(self.ptr)
    };
    let value = unsafe { std::ffi::CStr::from_ptr(value) };
    let value = value.to_str().unwrap();
    value.to_string()
  }
}