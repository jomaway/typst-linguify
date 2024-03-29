use fluent::{FluentArgs, FluentBundle, FluentResource};
use fluent_syntax::ast::Entry;
use serde_json::{from_slice, Value};
use unic_langid::LanguageIdentifier;

use wasm_minimal_protocol::{initiate_protocol, wasm_func};

initiate_protocol!();

#[wasm_func]
pub fn test() -> Vec<u8> {
    "Hello, World!".as_bytes().to_vec()
}

#[wasm_func]
pub fn get_message(fluent_str: &[u8], msg_id: &[u8], args: &[u8]) -> Result<Vec<u8>, String> {
    let fluent_str = match String::from_utf8(fluent_str.to_vec()) {
        Ok(s) => s,
        Err(e) => return Err(format!("Failed to convert fluent_str to String: {}", e)),
    };
    let msg_id = match String::from_utf8(msg_id.to_vec()) {
        Ok(s) => s,
        Err(e) => return Err(format!("Failed to convert msg_id to String: {}", e)),
    };
    let args: Value = match from_slice(args) {
        Ok(v) => v,
        Err(e) => return Err(format!("Failed to load json: {}", e)),
    };
    let args = match args.as_object() {
        Some(o) => o,
        None => return Err("Failed to convert args to object".to_string()),
    };
    let mut f_args = FluentArgs::new();
    for (key, value) in args.iter() {
        match value {
            Value::String(s) => {
                f_args.set(key, s.as_str());
            }
            Value::Number(n) => {
                let num = match n.as_i64() {
                    Some(i) => i,
                    None => return Err("Failed to convert number to i64".to_string()),
                };
                f_args.set(key, num);
            }
            _ => {}
        }
    }

    let li = LanguageIdentifier::default();
    let res = match FluentResource::try_new(fluent_str) {
        Ok(r) => r,
        // TODO: return error message
        Err(_e) => return Err("Failed to parse FluentResource".to_string()),
    };
    let mut bundle = FluentBundle::new(vec![li]);
    match bundle.add_resource(res) {
        Ok(_) => {}
        // TODO: return error message
        Err(_e) => return Err("Failed to add FluentResource".to_string()),
    }

    let msg = match bundle.get_message(msg_id.as_str()) {
        Some(m) => m,
        None => return Err("Failed to get message".to_string()),
    };
    let pattern = match msg.value() {
        Some(v) => v,
        None => return Err("Failed to get value".to_string()),
    };
    let value = bundle.format_pattern(pattern, Some(&f_args), &mut vec![]);
    Ok(value.to_string().as_bytes().to_vec())
}

#[wasm_func]
pub fn has_id(fluent_str: &[u8], msg_id: &[u8]) -> Result<Vec<u8>, String> {
    let fluent_str = match String::from_utf8(fluent_str.to_vec()) {
        Ok(s) => s,
        Err(e) => return Err(format!("Failed to convert fluent_str to String: {}", e)),
    };
    let msg_id = match String::from_utf8(msg_id.to_vec()) {
        Ok(s) => s,
        Err(e) => return Err(format!("Failed to convert msg_id to String: {}", e)),
    };

    let res = match FluentResource::try_new(fluent_str) {
        Ok(r) => r,
        // TODO: return error message
        Err(_e) => return Err("Failed to parse FluentResource".to_string()),
    };
    let has = res.entries().any(|entry: &Entry<&str>| {
        if let Entry::Message(msg) = entry {
            msg.id.name.to_string() == msg_id
        } else {
            false
        }
    });
    Ok(has.to_string().as_bytes().to_vec())
}
