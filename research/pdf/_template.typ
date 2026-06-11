// Pandoc-compatible typst template
#let conf(
  title: none,
  subtitle: none,
  authors: (),
  keywords: (),
  date: none,
  abstract: none,
  abstract-title: none,
  thanks: none,
  lang: "en",
  region: "US",
  margin: (top: 0.75in, bottom: 0.75in, left: 0.85in, right: 0.85in),
  paper: "us-letter",
  font: (),
  fontsize: 10pt,
  mathfont: (),
  codefont: (),
  linestretch: auto,
  sectionnumbering: none,
  pagenumbering: none,
  linkcolor: auto,
  citecolor: auto,
  filecolor: auto,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  cols: 1,
  doc,
) = {
  set document(
    title: if title != none { title } else { none },
  )

  // Page setup
  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
    number-align: center,
    header: context {
      if counter(page).get().first() > 1 [
        #set text(8pt, fill: luma(120))
        #smallcaps(if title != none { title } else { [] })
        #h(1fr)
      ]
    },
  )

  // Typography — use system serif
  set text(
    font: if font != () { font } else { ("Iowan Old Style", "Palatino", "Georgia") },
    size: fontsize,
    lang: lang,
  )

  set par(
    leading: 0.58em,
    justify: true,
    first-line-indent: 0em,
    spacing: 0.65em,
  )

  // Headings
  set heading(numbering: sectionnumbering)
  show heading.where(level: 1): it => {
    set text(14pt, weight: "bold")
    v(0.7em)
    block(it)
    v(0.25em)
  }
  show heading.where(level: 2): it => {
    set text(11.5pt, weight: "bold")
    v(0.55em)
    block(it)
    v(0.15em)
  }
  show heading.where(level: 3): it => {
    set text(10.5pt, weight: "bold")
    v(0.4em)
    block(it)
    v(0.1em)
  }
  show heading.where(level: 4): it => {
    set text(10pt, weight: "bold", style: "italic")
    v(0.3em)
    block(it)
    v(0.08em)
  }

  // Tables — compact and clean
  set table(
    stroke: (x, y) => {
      if y == 0 { (bottom: 0.8pt + luma(100)) }
      else { (bottom: 0.3pt + luma(200)) }
    },
    inset: (x: 5pt, y: 3.5pt),
  )
  show table: set text(9pt)
  show table.cell.where(y: 0): set text(weight: "bold", size: 8.5pt)

  // Block quotes
  show quote.where(block: true): it => {
    block(
      width: 100%,
      inset: (left: 14pt, top: 5pt, bottom: 5pt, right: 6pt),
      stroke: (left: 2.5pt + luma(170)),
      fill: luma(250),
    )[
      #set text(9.5pt, fill: luma(30))
      #set par(leading: 0.52em)
      #it.body
    ]
  }

  // Code blocks
  show raw.where(block: true): it => {
    block(
      width: 100%,
      fill: luma(246),
      inset: 6pt,
      radius: 2pt,
      stroke: 0.3pt + luma(200),
    )[#set text(8.5pt); #it]
  }

  show raw.where(block: false): it => {
    box(
      fill: luma(240),
      inset: (x: 3pt, y: 1pt),
      radius: 1.5pt,
    )[#set text(9pt); #it]
  }

  // Lists — tight
  set list(indent: 10pt, body-indent: 5pt, spacing: 0.4em)
  set enum(indent: 10pt, body-indent: 5pt, spacing: 0.4em)

  // Links
  show link: set text(fill: rgb("#1a5276"))

  // Definition terms
  show terms.item: it => block(breakable: false)[
    #text(weight: "bold")[#it.term]
    #block(inset: (left: 1.5em, top: -0.4em))[#it.description]
  ]

  // Title block
  if title != none {
    align(center)[
      #v(0.3in)
      #text(17pt, weight: "bold")[#title]
      #if subtitle != none {
        v(0.08in)
        text(12pt, fill: luma(60))[#subtitle]
      }
      #if date != none {
        v(0.08in)
        text(9.5pt, fill: luma(100))[#date]
      }
      #v(0.25in)
    ]
    line(length: 100%, stroke: 0.5pt + luma(180))
    v(0.15in)
  }

  // Body
  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}
