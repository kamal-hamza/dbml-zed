mod dbml;

// Exported functions for the WASM component (stub examples)
use std::ffi::{CStr, CString};
use std::os::raw::c_char;

#[no_mangle]
pub extern "C" fn parse_dbml(ptr: *const c_char) -> *mut c_char {
    if ptr.is_null() {
        return std::ptr::null_mut();
    }
    let c_str = unsafe { CStr::from_ptr(ptr) };
    let input = c_str.to_string_lossy();

    // Here you could call your dbml parsing logic
    let output = format!("Parsed DBML: {}", input);

    CString::new(output).unwrap().into_raw()
}

#[no_mangle]
pub extern "C" fn free_string(ptr: *mut c_char) {
    if ptr.is_null() {
        return;
    }
    unsafe { CString::from_raw(ptr) };
}
