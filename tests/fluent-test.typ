// #include "fluent-test/test.typ"
#import "../lib/linguify.typ": *

#let de = smallcaps("DE:")
#let en = smallcaps("EN:")

#let data = toml("fluent-test-assets/lang.toml")

#let path = if-auto-then(data.ftl.at("path", default: auto), "./L10n")
#for lang in data.ftl.languages {
  let lang_section = read(path + "/" + lang + ".ftl")
  data.lang.insert(lang, lang_section)
}

*Data: *
#box(fill: luma(240), radius: 5pt, inset: 0.8em)[#data]

= Greetings
- #linguify("hello", from: data)  
- #linguify("hello", from: data, args:(name: "Pete"))


= Headings
#set heading(numbering: "1.a.")
```typc
#set heading(numbering: "1.a.")
```

Your document has #context linguify("heading", from: data, args:(headingCount: counter(heading).get().first())).
#block[
  #set text(lang: "de")
  #de Dein Dokument hat #context linguify("heading", from: data, args:(headingCount: counter(heading).get().first())).
]
= Head
Your document has #context linguify("heading", from: data, args:(headingCount: counter(heading).get().first())).
#block[
  #set text(lang: "de")
  #de Dein Dokument hat #context linguify("heading", from: data, args:(headingCount: counter(heading).get().first())).
]

= Head

Your document has #context linguify("heading", from: data, args:(headingCount: counter(heading).get().first())).
#block[
  #set text(lang: "de")
  #de Dein Dokument hat #context linguify("heading", from: data, args:(headingCount: counter(heading).get().first())).
]

