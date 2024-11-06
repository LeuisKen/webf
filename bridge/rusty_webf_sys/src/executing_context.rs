/*
* Copyright (C) 2022-present The WebF authors. All rights reserved.
*/

use std::ffi::*;
use crate::*;

pub type WebFNativeFunction = Box<dyn Fn(c_int, *const OpaquePtr)>;

pub struct WebFNativeFunctionContextData {
  func: WebFNativeFunction,
}

#[repr(C)]
pub struct WebFNativeFunctionContext {
  pub callback: extern "C" fn(callback_context: *const OpaquePtr,
                              argc: c_int,
                              argv: *const OpaquePtr,
                              exception_state: *const OpaquePtr) -> *const c_void,
  pub free_ptr: extern "C" fn(callback_context: *const OpaquePtr) -> *const c_void,
  pub ptr: *const WebFNativeFunctionContextData,
}

extern "C" fn handle_callback(
  callback_context_ptr: *const OpaquePtr,
  argc: c_int,
  argv: *const OpaquePtr,
  exception_state: *const OpaquePtr,
) -> *const c_void {
  let callback_context = unsafe {
    &(*(callback_context_ptr as *mut WebFNativeFunctionContext))
  };
  let callback_context_data = unsafe {
    &(*(callback_context.ptr as *mut WebFNativeFunctionContextData))
  };

  unsafe {
    let func = &(*callback_context_data).func;
    func(argc, argv);
  }

  std::ptr::null()
}

extern "C" fn handle_callback_data_free(callback_context_ptr: *const OpaquePtr) -> *const c_void {
  unsafe {
    let callback_context = &(*(callback_context_ptr as *mut WebFNativeFunctionContext));
    let _ = Box::from_raw(callback_context.ptr as *mut WebFNativeFunctionContextData);
  }
  std::ptr::null()
}

#[repr(C)]
pub struct ExecutingContextRustMethods {
  pub version: c_double,
  pub get_document: extern "C" fn(*const OpaquePtr) -> RustValue<DocumentRustMethods>,
  pub get_window: extern "C" fn(*const OpaquePtr) -> RustValue<WindowRustMethods>,
  pub create_exception_state: extern "C" fn() -> RustValue<ExceptionStateRustMethods>,
  pub set_timeout: extern "C" fn(*const OpaquePtr, *const WebFNativeFunctionContext, c_int, *const OpaquePtr) -> c_int,
}

pub type TimeoutCallback = Box<dyn Fn()>;

/// An environment contains all the necessary running states of a web page.
///
/// For Flutter apps, there could be many web pages running in the same Dart environment,
/// and each web page is isolated with its own DOM tree, layout state, and JavaScript running environment.
///
/// In the Rust world, Rust code plays the same role as JavaScript,
/// so the Rust running states also live in the ExecutionContext class.
///
/// Since both JavaScript and Rust run in the same environment,
/// the DOM tree and the underlying layout state are shared between Rust and JavaScript worlds.
/// it's possible to create an HTMLElement in Rust and remove it from JavaScript,
/// and even collaborate with each other to build an enormous application.
///
/// The relationship between Window, Document, and ExecutionContext is 1:1:1 at any point in time.
pub struct ExecutingContext {
  // The underlying pointer points to the actual implementation of ExecutionContext in the C++ world.
  pub ptr: *const OpaquePtr,
  // Methods available for export from the C++ world for use.
  method_pointer: *const ExecutingContextRustMethods,
}

impl ExecutingContext {
  pub fn initialize(ptr: *const OpaquePtr, method_pointer: *const ExecutingContextRustMethods) -> ExecutingContext {
    ExecutingContext {
      ptr,
      method_pointer
    }
  }

  pub fn method_pointer<'a>(&self) -> &'a ExecutingContextRustMethods {
    unsafe {
      &*self.method_pointer
    }
  }

  /// Obtain the window instance from ExecutingContext.
  pub fn window(&self) -> Window {
    let result = unsafe {
      ((*self.method_pointer).get_window)(self.ptr)
    };
    return Window::initialize(result.value, self, result.method_pointer, result.status);
  }

  /// Obtain the document instance from ExecutingContext.
  pub fn document(&self) -> Document {
    let result = unsafe {
      ((*self.method_pointer).get_document)(self.ptr)
    };
    return Document::initialize::<DocumentRustMethods>(result.value, self, result.method_pointer, result.status);
  }

  pub fn create_exception_state(&self) -> ExceptionState {
    let result = unsafe {
      ((*self.method_pointer).create_exception_state)()
    };
    ExceptionState::initialize(result.value, result.method_pointer)
  }

  pub fn set_timeout(&self, callback: TimeoutCallback, timeout: i32, exception_state: &ExceptionState) -> Result<i32, String> {
    let general_callback: WebFNativeFunction = Box::new(move |argc, argv| {
      if argc != 0 {
        println!("Invalid argument count for timeout callback");
        return;
      }
      callback();
    });

    let callback_data = Box::new(WebFNativeFunctionContextData {
      func: general_callback,
    });
    let callback_context_data_ptr = Box::into_raw(callback_data);
    let callback_context = Box::new(WebFNativeFunctionContext {
      callback: handle_callback,
      free_ptr: handle_callback_data_free,
      ptr: callback_context_data_ptr,
    });
    let callback_context_ptr = Box::into_raw(callback_context);

    let result = unsafe {
      ((*self.method_pointer).set_timeout)(self.ptr, callback_context_ptr, timeout, exception_state.ptr)
    };

    if exception_state.has_exception() {
      unsafe {
        let _ = Box::from_raw(callback_context_ptr);
        let _ = Box::from_raw(callback_context_data_ptr);
      }
      return Err(exception_state.stringify(self));
    }

    Ok(result)
  }

}
