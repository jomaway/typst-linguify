#import "@preview/linguify:0.4.0": *
#import "@preview/gentle-clues:0.7.1": abstract

#show raw.where(block: false): it => {
  box(fill: luma(240), radius: 5pt, inset: (x: 3pt), outset: (y:3pt), it)
}

#let l = [_linguify_]

#set text(font: "Rubik", weight: 300)
#set heading(numbering: (..args) => {
  // let nums = args.pos()
  // let level = nums.len()
  // if level == 1 {
  //   [#numbering("1.", ..nums)]
  // }
})


#let lang_data = read("lang.toml")

#set_database(toml("lang.toml")) 

#let pkginfo = toml("../typst.toml").package

// title 
#align(center, text(24pt, weight: 500)[linguify manual])

#abstract[
	#link("https://github.com/jomaway/typst-linguify")[*linguify*] is a package for loading strings for different languages easily.

	Version: #pkginfo.version \
	Authors: #link("https://github.com/jomaway","jomaway") \
	License: #pkginfo.license
]

#outline(depth: 2, indent: 2em)

#v(1cm)

This manual shows a short example for the usage of the `linguify` package inside your document. If you want to *include linguify into your package* make sure to read the #ref(<4pck>, supplement: "section for package authors").

#pagebreak()
= Usage

== Basic Example

*Load language data file:*  #sym.arrow See #ref(<db>, supplement: "database section") for content of `lang.toml`

```typc
#set_database(toml("lang.toml")) 
```

*Example input:* \
```typc
#set text(lang: <LANG-STRING>)
#smallcaps(linguify("abstract"))
=== #linguify("title") 

Test: #linguify("test") 
```
#v(1em)

#let example(lang, info: none) = (lang,[
  #set text(lang: lang)
  #smallcaps(linguify("abstract"))
  === #linguify("title") 
  // #lorem(10)
  
  Test: #linguify("test") 

  #if (info != none ) [
    #set text(style: "italic", fill: blue)
    *Info*: #info 
  ]
])

#table(
  columns: 2,
  inset: 1em,
  align: (center, start),
  table.header([*Lang*],[*Output*]),
  ..example("en"),
  ..example("de"),
  ..example("es", info: [The key "test" is missing in the "es" language section, but as we specified a default-lang in the `conf` it will display the entry inside the specified language section, which is "en" in our case. \
  To *disable* this behavior delete the `default-lang` entry from the `lang.toml`.]),
  ..example("cz",info: [As the lang data does not contain a section for "cz" this entire output will fallback to the default-lang. \
  To *disable* this behavior delete the `default-lang` entry from the `lang.toml`. ]),

)

== Database<db>
The content of the `lang.toml` file, used in the example above looks like this.
#raw(read("lang.toml"))


== Information for package authors.<4pck>

As the database is stored in a typst state, it can be overwritten. This leads to the following problem. If you use #l inside your package and use the `set_database()` function it will probably work like you expect. But if a user imports your package and uses #l for their own document as well, he will overwrite the your database by using `set_database`. Therefore it is recommend to use the `from` argument in the `linguify` function to specify your database directly. 

Example:
```typc
// Load data
#let lang_data = toml("lang.toml")

// Useage 
#linguify("key", from: lang_data)
```

This makes sure the end user still can use the global database provided by #l with `set_database()` and calling. 

#sym.arrow Have a look at the #link("https://github.com/jomaway/typst-gentle-clues", "gentle-clues") package for a real live example.

== Contributing

If you would like to integrate a new i18n solution into #l, you can set the `conf.data_type` described in the #ref(<db>, supplement: "database section"). And then add implementation in the `get-text` function for your data type.

#pagebreak()
= Reference

#import "@preview/tidy:0.2.0"
#let docs = tidy.parse-module(read("../linguify.typ"), name: "Linguify reference")
#tidy.show-module(docs, 
  style: tidy.styles.default,
  show-outline: false,
	sort-functions: none,
)
