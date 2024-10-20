// Generated by WebF TSDL, don't edit this file directly.
// Generate command: node scripts/generate_binding_code.js
/*
* Copyright (C) 2022-present The WebF authors. All rights reserved.
*/
use std::ffi::*;
use libc::boolean_t;
use crate::*;
#[repr(C)]
pub struct PointerEventInit {
  pub is_primary: boolean_t,
  pub pointer_id: c_double,
  pub pointer_type: *const c_char,
  pub pressure: c_double,
  pub tangential_pressure: c_double,
  pub tilt_x: c_double,
  pub tilt_y: c_double,
  pub twist: c_double,
  pub width: c_double,
  pub height: c_double,
}