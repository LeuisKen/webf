// Generated by WebF TSDL, don't edit this file directly.
// Generate command: node scripts/generate_binding_code.js
/*
* Copyright (C) 2022-present The WebF authors. All rights reserved.
*/
use std::ffi::*;
use crate::*;
#[repr(C)]
pub struct CloseEventInit {
  pub bubbles: bool,
  pub cancelable: bool,
  pub composed: bool,
  pub code: i64,
  pub reason: *const c_char,
  pub was_clean: bool,
}