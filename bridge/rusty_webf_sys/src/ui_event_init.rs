// Generated by WebF TSDL, don't edit this file directly.
// Generate command: node scripts/generate_binding_code.js
/*
* Copyright (C) 2022-present The WebF authors. All rights reserved.
*/
use std::ffi::*;
use crate::*;
#[repr(C)]
pub struct UIEventInit {
  pub bubbles: i32,
  pub cancelable: i32,
  pub composed: i32,
  pub detail: c_double,
  pub view: RustValue<WindowRustMethods>,
  pub which: c_double,
}