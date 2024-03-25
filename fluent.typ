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

/// Constructs the data dict described in `linguify.typ`
#let ftl_data(
  path,
  languages
) = {
  let data = (:)
  for lang in languages {
    let lang_section = (
      __type: "ftl",
      data: str(read(path + "/" + lang + ".ftl"))
    )
    data.insert(lang, lang_section)
  }
  data
}

