// linguify

/// None or dictionary of the following structure:
/// default-lang: "en"
/// en: *en-data*
/// de: *de-data*
/// ...
#let database = state("linguify-database", none);


/// set the default linguify database
#let set_database(data) = {
  assert.eq(type(data), dictionary, message: "expected data to be a dictionary, found " + type(data))
  database.update(data);
}

/// add data to the current database
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

/// Helper function. 
/// if the value is auto "ret" is returned else the value self is returned
#let if-auto-then(val,ret) = {
  if (val == auto){
    ret
  } else { 
    val 
  }
}

/// fetch a string in the required lang.
///
/// - key (string): The key at which to retrieve the item.
/// - from (dictionary): database to fetch the item from. If auto linguify's global database will used.
/// - lang (string): the language to look for, if auto use `context text.lang` (default)
/// - default (any): A default value to return if the key is not part of the database.
/// -> content
#let linguify(key, from: auto, lang: auto, default: auto) = {
  context {
    let database = if-auto-then(from,database.get())

    // check if database is not empty. Means no data dictionary was specified.
    assert(database != none, message: "linguify database is empty.")
    // get selected language.
    let selected_lang = if-auto-then(lang, text.lang)
    let lang_not_found = not selected_lang in database
    let fallback_lang = database.at("default-lang", default: none)

    // if available get the language section from the database if not try to get the fallback_lang entry.
    let lang_section = database.at(
      selected_lang,
      default: if (fallback_lang != none) { database.at(fallback_lang, default: none) } else { none }
    )

    // if lang_entry exists 
    if ( lang_section != none ) {
      // check if the value exits.
      let value = lang_section.at(key, default: none)
      if (value == none) {
        // info: fallback lang will not be used if given lang section exists but only a key is missing.
        // use this for a workaround: linguify("key", default: linguify("key", lang: "en", default: "key"));
        if (fallback_lang != none) {
          // check if fallback lang exists in database
          assert(database.at(fallback_lang, default: none) != none, message: "fallback lang (" + fallback_lang + ") does not exist in linguify database")
          // check if key exists in fallback lang.
          assert(database.at(fallback_lang).at(key, default: none) != none, message: "key (" +  key + ") does not exist in fallback lang section.")
          return database.at(fallback_lang).at(key)
        }
        if (default != auto) {
          return default
        } else {
          if lang_not_found {
            panic("Could not find an entry for the key (" +  key + ") in the fallback section (" + fallback_lang + ") at the linguify database.")
          } else {
            panic("Could not find an entry for the key (" +  key + ") in the section (" + selected_lang + ") at the linguify database.")
          }
        }
      } else {
        return value
      }
    } else {
      if fallback_lang == none or selected_lang == fallback_lang {
        panic("Could not find a section for the language (" + selected_lang + ") in the linguify database.")
      } else {
        panic("Could not find a section for the language (" + selected_lang + ") or fallback language (" + fallback_lang + ") in the linguify database.")
      }
    }
  }
}
