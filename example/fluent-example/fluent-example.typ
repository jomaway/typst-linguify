#import "../../linguify.typ": *
#import "lib.typ": *

// Please compile this example in the root directory of the project
// i.e. using `--root=".../typst-linguify"` option

Heres a simple example of how to use the `linguify` package to load translations from a #link("https://projectfluent.org/")[#underline[Fluent]] file.

#v(1em)

#code(```typ
#import "../../linguify.typ": *
#let languages = (
  "en",
  "zh-CN",
  "ja"
)
#linguify_set_database("./example/fluent-example/L10n", languages: languages)
= #linguify("title")

= #linguify("title", lang: "zh-CN")

// Args are supported
#linguify("hello", args: ("name": "Alice & Bob",))

#set text(lang: "ja")

// It is also possible to set the language using
#linguify_update_args(("name": "Carlo & David"))

#linguify("hello")

= #linguify("title")

```)

#v(1em)

while the fluent files are kept in `L10n` directory and named with the language code, e.g. `en.ftl` and `zh-CN.ftl`.

You have to maintain the language list used in database initialization since Typst currently does not list files in a directory. Of course, you can use an external YAML or JSON file to store the language list and load it in the script if it is necessary.

