// linguify

#import "fluent.typ": ftl_data, get_message as __get_message

/// None or dictionary of the following structure:
///
/// ```
/// conf.default-lang: "en"
/// lang.en:  *en-data*
/// lang.de: *de-data*
/// ```
#let database = state("linguify-database", none);


/// Set the default linguify database
///
/// The data must contain at least a lang section like described at @@database.
///
/// - data (dictionary): the database which will be set to @@database
/// -> content (state-update)
#let set_database(data) = {
  assert.eq(type(data), dictionary, message: "expected data to be a dictionary, found " + type(data))
  if (data.at("conf", default: none) == none) {
    data.insert("conf", (:))
  }
  // assert(data.at("conf", default: none) != none, message: "missing conf section ")
  assert(data.at("lang", default: none) != none, message: "missing lang section ")
  database.update(data);
}

/// Add data to the current database
///
/// - data (dictionary): the database which will be set to @@database
/// -> content (state-update)
#let update_database(data) = {
  context {
    let _database = database.get()
    for (key,value) in data.pairs() {
      // let lang_section = database.at(key, default: none)
      if key not in _database.keys() {
        _database.insert(key, value)
      } else {
        let new = _database.at(key) + value
        _database.insert(key, new)
      }
    }
    database.update(_database);
  }
}

// Helper function. 
// if the value is auto "ret" is returned else the value self is returned
#let if-auto-then(val,ret) = {
  if (val == auto){
    ret
  } else { 
    val 
  }
}

/// Get a value from a L10n data dictionary.
/// - src (dict): The dictionary to get the value from.
/// - key (str): The key to get the value for.
/// - lang (str): The language to get the value for.
/// - mode (str): The data structure of src, currently only "dict" is supported.
/// -> The value for the key in the dictionary. If the key does not exist, `none` is returned.
#let get_text(src, key, lang, mode: "dict", args: none) = {
  assert.eq(type(src), dictionary, message: "expected src to be a dictionary, found " + type(src))
  let lang_section = src.at(lang, default: none)
  if (lang_section != none) {
    if mode == "dict" {
      return lang_section.at(key, default: none)
    }
    else if mode == "ftl" {
      return __get_message(lang_section, key, args: args)
    }
  }
  return none
}

/// fetch a string in the required lang.
///
/// - key (string): The key at which to retrieve the item.
/// - from (dictionary): database to fetch the item from. If auto linguify's global database will used.
/// - lang (string): the language to look for, if auto use `context text.lang` (default)
/// - default (any): A default value to return if the key is not part of the database.
/// -> content
#let linguify(key, from: auto, lang: auto, default: auto, args: auto) = {
  context {
    let database = if-auto-then(from,database.get())

    let data_type = database.conf.at("data_type", default: "dict")

    // check if database is not empty. Means no data dictionary was specified.
    assert(database != none, message: "linguify database is empty.")
    // get selected language.
    let selected_lang = if-auto-then(lang, text.lang)
    let lang_not_found = not selected_lang in database.lang
    let fallback_lang = database.conf.at("default-lang", default: none)

    let args = if-auto-then(args, (:))

    let value = get_text(database.lang, key, selected_lang, mode: data_type, args: args)
    
    if (value != none) {
      return value
    }
    
    // Check if a fallback language is set
    if (fallback_lang != none) {
      let value = get_text(database.lang, key, fallback_lang, mode: data_type, args: args)

      // Use the fallback language if possible
      if (value != none) {
        return value
      }

      // if the key is not found in the fallback language
      return if-auto-then(default, {
        let error_message = if lang_not_found {
        "Could not find language `" + selected_lang + "` in the linguify database."
        } else {
          "Could not find an entry for the key `" + key + "` in language `" + selected_lang + "` at the linguify database."
        }
        error_message = error_message + " Also, the fallback language `" + fallback_lang + "` does not contain the key `" + key + "`."
        panic(error_message)
      })
    }

    // if no fallback language is set
    return if-auto-then(default, {
      let error_message = if lang_not_found {
        "Could not find language `" + selected_lang + "` in the linguify database."
      } else {
        "Could not find an entry for the key `" + key + "` in language `" + selected_lang + "` at the linguify database."
      }
      error_message = error_message + " Also, no fallback language is set."
      panic(error_message)
    })
  }
}
