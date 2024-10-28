// Generated by WebF TSDL, don't edit this file directly.
// Generate command: node scripts/generate_binding_code.js
/*
* Copyright (C) 2022-present The WebF authors. All rights reserved.
*/
use std::ffi::*;
use crate::*;
#[repr(C)]
pub struct KeyboardEventInit {
  pub detail: c_double,
  pub view: RustValue<WindowRustMethods>,
  pub which: c_double,
  pub alt_key: i32,
  pub char_code: c_double,
  pub code: *const c_char,
  pub ctrl_key: i32,
  pub is_composing: i32,
  pub key: *const c_char,
  pub key_code: c_double,
  pub location: c_double,
  pub meta_key: i32,
  pub repeat: i32,
  pub shift_key: i32,
}