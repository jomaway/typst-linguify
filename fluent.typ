#let ftl = plugin("./linguify_fluent_rs/linguify_fluent_rs.wasm")

#let get_message(ftl_str, msg_id, args: none) = {
  if args == none {
    args = (:)
  }
  str(
    ftl.get_message(bytes(ftl_str), bytes(msg_id), bytes(json.encode(args, pretty: false)))
  )
}

/// returns a bool
#let has_message(ftl_str, msg_id) = {
  str(ftl.has_id(bytes(ftl_str), bytes(msg_id))) == "true"
}

/// Constructs the data dict needed in `linguify.typ`
/// - `path` (str): the path to the directory containing the ftl files
/// - `languages` (array): the list of languages to load
///
/// Returns a `str`, use `eval` to convert it to a dict
///
/// ## Example:
/// ```typst
/// eval(ftl_data("path/to/ftl", ("en", "fr")))
/// ```
#let ftl_data(
  path,
  languages
) = {
  assert.eq(type(path), str, message: "expected path to be a string, found " + type(path))
  assert.eq(type(languages), array, message: "expected languages to be an array, found " + type(languages))

  ```Typst
  let import_ftl(path, langs) = {
    let data = (
      conf: (
        data_type: "ftl",
        ftl: (
          languages: langs
        ),
      ),
      lang: (:)
    )
    for lang in langs {
      data.lang.insert(lang, str(read(path + "/" + lang + ".ftl")))
    }
    data
  }
  import_ftl(
    "```.text + path + ```",
    (```.text + (languages.map((x) => {"\"" + str(x) + "\", "}).sum()).trim(" ") + ```)
  )
  ```.text
}

