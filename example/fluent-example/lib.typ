// Copied from https://github.com/typst-doc-cn/tutorial/blob/main/src/mod.typ

#let exec-code(cc, res: none, scope: (:), eval: eval) = {

  rect(width: 100%, inset: 10pt, {
    // Don't corrupt normal headings
    set heading(outlined: false)

    if res != none {
      res
    } else {
      eval(cc.text, mode: "markup", scope: scope)
    }
  })
}

// al: alignment
#let code(cc, code-as: none, res: none, scope: (:), eval: eval, exec-code: exec-code, al: left) = {
  let code-as = if code-as == none {
    cc
  } else {
    code-as
  }

  let vv = exec-code(cc, res: res, scope: scope, eval: eval)
  if al == left {
    layout(lw => style(styles => {
      let width = lw.width * 0.5 - 0.5em
      let u = box(width: width, code-as)
      let v = box(width: width, vv)

      let u-box = measure(u, styles);
      let v-box = measure(v, styles);

      let height = calc.max(u-box.height, v-box.height)
      stack(
        dir: ltr,
        {
          set rect(height: height)
          u
        }, 1em, {
          rect(height: height, width: width, inset: 10pt, vv.body)
        }
      )
    }))
  } else {
    code-as
    vv
  }
}
