/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

#ifndef WEBF_CORE_RUST_API_EXECUTING_CONTEXT_H_
#define WEBF_CORE_RUST_API_EXECUTING_CONTEXT_H_

#include "core/native/native_function.h"
#include "document.h"
#include "exception_state.h"
#include "window.h"

namespace webf {

class Document;
class ExecutingContext;
class Window;

using PublicContextGetDocument = WebFValue<Document, DocumentPublicMethods> (*)(ExecutingContext*);
using PublicContextGetWindow = WebFValue<Window, WindowPublicMethods> (*)(ExecutingContext*);
using PublicContextGetExceptionState = WebFValue<SharedExceptionState, ExceptionStatePublicMethods> (*)();
using PublicContextSetTimeout = int32_t (*)(ExecutingContext*,
                                            WebFNativeFunctionContext*,
                                            int32_t,
                                            SharedExceptionState*);

// Memory aligned and readable from WebF side.
// Only C type member can be included in this class, any C++ type and classes can is not allowed to use here.
struct ExecutingContextWebFMethods {
  static WebFValue<Document, DocumentPublicMethods> document(ExecutingContext* context);
  static WebFValue<Window, WindowPublicMethods> window(ExecutingContext* context);
  static WebFValue<SharedExceptionState, ExceptionStatePublicMethods> CreateExceptionState();
  static int32_t SetTimeout(ExecutingContext* context,
                            WebFNativeFunctionContext* callback_context,
                            int32_t timeout,
                            SharedExceptionState* shared_exception_state);

  double version{1.0};
  PublicContextGetDocument context_get_document{document};
  PublicContextGetWindow context_get_window{window};
  PublicContextGetExceptionState context_get_exception_state{CreateExceptionState};
  PublicContextSetTimeout context_set_timeout{SetTimeout};
};

}  // namespace webf

#endif  // WEBF_CORE_RUST_API_EXECUTING_CONTEXT_H_
