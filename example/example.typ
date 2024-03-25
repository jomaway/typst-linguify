#import "@local/linguify:0.3.0": *

#show raw.where(block: false): it => {
  box(fill: luma(240), radius: 5pt, inset: 3pt, it)
}

#linguify_set_database(toml("lang.toml"))

= Linguify

#v(1em)
*Load language data file:* \
`#show: linguify_config.with(data: toml("lang.toml"));`
#v(1em)

#smallcaps(linguify("abstract"))
== #linguify("title")
#lorem(40) \ #linguify("test") 


#v(1cm)
`#set text(lang: "de")`


#set text(lang: "de")

#smallcaps(linguify("abstract"))
== #linguify("title") 
#lorem(40) \ #linguify("test")

#v(1cm)
`#set text(lang: "es")`

#set text(lang: "es") // as not all values for the spanish language are translated yet we set fallback to true to suppress errors.

#smallcaps(linguify("abstract"))
== #linguify("title") 
#lorem(40) \ #linguify("test") #sym.arrow.l _this value is missing in the "es" data, but as we specified fallback in the top config it will display the default-lang, which is "en" in our case_

#v(1cm)
`#set text(lang: "cz")`


_Info: as the lang data does not contain an entry to  "cz" this will fallback to the default_lang. Can be disabled by setting `fallback` to false in the config._ 
#set text(lang: "cz")

#smallcaps(linguify("abstract"))
== #linguify("title") 
#lorem(40) \ #linguify("test")
