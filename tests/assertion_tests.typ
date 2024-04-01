#import "../lib/linguify.typ": *

#let db = toml("lang.toml")

#let test_data = {
  assert(db != none)
  assert(db.at("lang", default: none) != none )

  set-database(db)
  reset-database()

  [run `test_db` successfully]
}

#let test_get_text = {
  // English (en)
  assert(get_text(db.lang, "apple","en") == "Apple")
  assert(get_text(db.lang, "pear","en") == "Pear")
  assert(get_text(db.lang, "banana","en") == "Banana")

  assert(get_text(db.lang, "red","en") == "red")
  assert(get_text(db.lang, "green","en") == "green")
  assert(get_text(db.lang, "yellow","en") == "yellow")

  assert(get_text(db.lang, "test", "en") == none)

  // German (de)
  assert(get_text(db.lang, "apple","de") == "Apfel")
  assert(get_text(db.lang, "pear","de") == "Birne")
  assert(get_text(db.lang, "banana","de") == "Banane")

  assert(get_text(db.lang, "red","de") == none)
  assert(get_text(db.lang, "green","de") == none)
  assert(get_text(db.lang, "yellow","de") == none)

  assert(get_text(db.lang, "test", "de") == none)

  [run `test_get_text` successfully]
}


#let test__linguify = {
  reset-database()

  // English (en)
  set text(lang: "en")
  context {
    assert(_linguify("apple", from: db) == ok("Apple"))
    assert(_linguify("pear", from: db)== ok("Pear"))
    assert(_linguify("banana", from: db) == ok("Banana" ))

    assert(_linguify("red", from: db) == ("ok":"red"))
    assert(_linguify("green", from: db) == ok("green"))
    assert(_linguify("yellow", from: db) == ok("yellow"))

    assert(_linguify("test", from: db).error != none)
   }

  // German (de)
  set text(lang: "de")
  context {
    assert(_linguify("apple", from: db) == ok("Apfel"))
    assert(_linguify("pear", from: db) == ok("Birne"))
    assert(_linguify("banana", from: db) == ok("Banane")) 

    // keys not inside db - will fallback to en
    assert(_linguify("red", from: db) == ok("red"))
    assert(_linguify("green", from: db) == ok("green"))
    assert(_linguify("yellow", from: db) == ok("yellow"))

    assert(_linguify("test", from: db).error != none)
  }

  // Spanish (es) ! lang not inside db wil fallback to en
  set text(lang: "es")
  context {
    assert(_linguify("apple", from: db) == ok("Apple"))
    assert(_linguify("pear", from: db) == ok("Pear"))
    assert(_linguify("banana", from: db) == ok("Banana")) 

    assert(_linguify("red", from: db) == ok("red"))
    assert(_linguify("green", from: db) == ok("green"))
    assert(_linguify("yellow", from: db) == ok("yellow"))

    assert(_linguify("test", from: db).error != none)
  }

  [run `test__linguify` successfully]
}


#let test__linguify_auto_db = {
  set-database(db)
    // English (en)
  set text(lang: "en")
  context {
    assert(_linguify("apple") == ok("Apple"))
    assert(_linguify("pear")== ok("Pear"))
    assert(_linguify("banana") == ok("Banana"))

    assert(_linguify("red") == ok("red"))
    assert(_linguify("green") == ok("green"))
    assert(_linguify("yellow") == ok("yellow"))

    assert(_linguify("test").error != none)
   }

  // German (de)
  set text(lang: "de")
  context {
    assert(_linguify("apple") == ok("Apfel"))
    assert(_linguify("pear") == ok("Birne"))
    assert(_linguify("banana") == ok("Banane") )

    // keys not inside db - will fallback to en
    assert(_linguify("red") == ok("red"))
    assert(_linguify("green") == ok("green"))
    assert(_linguify("yellow") == ok("yellow"))

    assert(_linguify("test").error != none)
  }

  // Spanish (es) ! lang not inside db wil fallback to en
  set text(lang: "es")
  context {
    assert(_linguify("apple") == ok("Apple"))
    assert(_linguify("pear") == ok("Pear"))
    assert(_linguify("banana") == ok("Banana") )

    assert(_linguify("red") == ok("red"))
    assert(_linguify("green") == ok("green"))
    assert(_linguify("yellow") == ok("yellow"))

    assert(_linguify("test").error != none)
  }

  [run `test__linguify_auto_db` successfully]
}

#let test_args_in_dict_mode = {
  context {
    assert(_linguify("apple") ==  ok("Apple"))
    assert(_linguify("apple", args:(name:"test")).error != none)
    assert(_linguify("apple", args:none).error != none)
    assert(_linguify("apple", args:(:)).error != none)
    assert(_linguify("apple", args:"").error != none)
    assert(_linguify("apple", args:1).error != none)
  }

  [run `test_args_in_dict_mode` successfully]
}


= Run tests (#datetime.today().display())

- #test_data
- #test_get_text
- #test__linguify
- #test__linguify_auto_db
- #test_args_in_dict_mode
