#set page(margin: (x: 0.5in, y: 0.5in), paper: "us-letter")
#set text(font: "Helvetica Neue", size: 8.5pt)
#set par(leading: 0.5em)

// ── Title ──
#align(center)[
  #text(size: 16pt, weight: "bold")[The Bishop's School — Class of 2026]
  #v(2pt)
  #text(size: 11pt, fill: rgb("#444"))[College Decisions Ranked by US News 2026]
  #v(2pt)
  #text(size: 8pt, fill: rgb("#666"))[
    Source: \@tbs26decisions Instagram · 108 posts · 106 unique students · 58 schools
  ]
]

#v(6pt)
#line(length: 100%, stroke: 0.5pt + rgb("#ccc"))
#v(4pt)

// ── Helper: section heading ──
#let section(title) = {
  v(8pt)
  text(size: 11pt, weight: "bold", fill: rgb("#1a1a1a"))[#title]
  v(3pt)
}

// ── Helper: compact table ──
#let col-school = 28%
#let col-rank = 5%
#let col-n = 4%
#let col-students = 63%

// ════════════════════════════════════════════════════
#section[National Universities]

#table(
  columns: (auto, col-school, col-rank, col-n, 1fr),
  align: (right, left, right, center, left),
  stroke: none,
  inset: (x: 3pt, y: 2.5pt),
  fill: (_, row) => if row == 0 { rgb("#f0f0f0") } else if calc.odd(row) { rgb("#fafafa") } else { white },
  table.hline(stroke: 0.7pt),

  [*\#*], [*School*], [*Rank*], [*N*], [*Students*],

  table.hline(stroke: 0.4pt),

  [1], [Harvard University], [3], [3], [Ariadne Georgiou (Gov & Ethnicity, Migration, Rights), Yina Shate (History of Science), Sydney Mafong (Human Bio, Behavior & Evolution / Spanish)],
  [2], [Stanford University], [4], [5], [Allison Moores (Biomedical Computation), Sophie Zeng (Symbolic Systems), Ryan Shi (Symbolic Systems), Lisa Pan (MS&E / Psychology), Tyler Chang (Neurobiology / Symbolic Systems)],
  [3], [Yale University], [4], [1], [Caleb Tang (Neuroscience)],
  [4], [University of Chicago], [6], [6], [Austin Hill (Business Econ), Zack Chen (Business Econ), Melanie Yau (Political Science), Calista Upton (Business Econ), Bella Bravo (Neuroscience), Charlie Ahn (Economics)],
  [5], [Johns Hopkins University], [7], [1], [Dom Simopoulos (Economics / Finance)],
  [6], [Northwestern University], [7], [1], [James O'Brien (Theater / Political Science)],
  [7], [Duke University], [8], [4], [Sophie Arrowsmith (Public Policy), Francie Vano (Public Policy), Wyatt Stone (Mechanical Eng), Riley Ross (Public Policy)],
  [8], [University of Pennsylvania], [9], [2], [Tom Lowe (Economics), Kailin Xuan (Cognitive Science)],
  [9], [Caltech], [11], [1], [Grace Yao (Computation and Neural Systems)],
  [10], [Cornell University], [12], [3], [Eleanor Meyer (Biology / Linguistics), Ella Xing (ME / Public Policy), Juliette Eastman-Pinto (Industrial & Labor Relations)],
  [11], [Brown University], [13], [2], [Colton Bell (Economics), Sabrina Feldman (Behavioral Decision Science)],
  [12], [Dartmouth College], [14], [1], [Clyde Kates (Business / Economics)],
  [13], [Columbia University], [15], [1], [Audrey Donnelly (Biology)],
  [14], [UC Berkeley], [15], [7], [Lotte Lightner (Economics), Jackson Weisser (CS), Isabel Zorrilla (Psychology / Dance), Marina Da Matta (Env Sci / Bio), Naveen Hernandez (Chemistry), Chris Tao (EE), Amy Yan (MCB)],
  [15], [UCLA], [17], [1], [Ayanna Hickey (Biology)],
  [16], [Carnegie Mellon University], [20], [1], [Millie Gan (Behavioral Economics)],
  [17], [University of Michigan], [20], [5], [Theo Johnson (Psychology), Surina Verma (Neuroscience / Bio), Kali Mahone (Biopsych / Neuro), Emma Banaie (Political Science), Evan Hamadeh (MCDB)],
  [18], [Washington U in St. Louis], [20], [1], [Eliana Leff (Comp Lit & Thought, Pre-Law)],
  [19], [Emory University], [24], [1], [Hailey Zheng (Neuroscience)],
  [20], [Georgetown University], [24], [1], [Brad Ladrido (Public Policy)],
  [21], [USC], [28], [1], [Ayla Johnson (AI for Business)],
  [22], [University of Florida], [28], [1], [Jayden Zou (Finance)],
  [23], [UC San Diego], [29], [1], [Giles Beamer (Cognitive Science)],
  [24], [New York University], [32], [3], [Chloe Hinder (Biology), Jack Rudy (Film & TV), Kaylee Yen (Undecided)],
  [25], [UC Irvine], [32], [2], [JT Moss (Business / Econ), Aileen Shin (Psychology)],
  [26], [Boston College], [36], [3], [Joy Xu (Psych, Pre-Med), Aidan Skoblar (Bio, Pre-Med), Kalia Roper (Neuro, Pre-Med)],
  [27], [Tufts University], [36], [2], [Anna Yang (International Relations), Jinhoo Jake Kim (Fashion Photo / Biochem)],
  [28], [U of Illinois Urbana-Champaign], [36], [1], [Abigail Wei (Computer Engineering)],
  [29], [UC Santa Barbara], [40], [2], [Gustav Westlake (Biochemistry), Reese Newlin (CCS Biology)],
  [30], [Rutgers University], [42], [1], [Jacob Popplewell (Business)],
  [31], [University of Rochester], [46], [1], [Isabelle Torralba (Psychology)],
  [32], [Northeastern University], [46], [3], [Elena Monico (Psychology), Ella Kaminsky (Business Admin), Bex Balsdon (Theater)],
  [33], [Purdue University], [46], [1], [Cole Hager (Aerospace Engineering)],
  [34], [Wake Forest University], [47], [1], [Stevie Turquand (Philosophy)],
  [35], [Lehigh University], [56], [1], [Helios Hernandez (Business / Biology)],
  [36], [George Washington University], [59], [1], [Kayla Pfefferman (Marketing)],
  [37], [Penn State University], [60], [1], [Ava Brocious (History)],
  [38], [Santa Clara University], [64], [5], [Connor Gutierrez (Finance), Brandon Agbayani (Business Econ), Paige Meyers (Bio, Pre-Med), Stella McGuinness (Psychology), Ryland Le (Finance)],
  [39], [University of Miami], [64], [1], [Javi Serhan (Finance)],
  [40], [Tulane University], [73], [2], [Chloe Chereque (Psychology / Business), Brady Fagan (Intl Business)],
  [41], [UC Riverside], [75], [1], [Paula Venancio (Media / Cultural Studies)],
  [42], [Texas Christian University], [89], [2], [Grace Dempsey (Education), Griff Hemerick (Business)],
  [43], [CU Boulder], [97], [2], [Amelie Francois (Aerospace Eng), Diego Mireles (MCDB, Pre-Med)],
  [44], [University of Tennessee], [102], [1], [Clay Peckham (Journalism and Media)],
  [45], [University of Alabama], [105], [1], [Penelope Fountain (Comm Studies, Pre-Law)],
  [46], [Brigham Young University], [110], [1], [Claire Stallings (Economics)],
  [47], [Chapman University], [110], [1], [Gabby Gallus (Psychology)],
  [48], [University of Utah], [134], [3], [Addie West (Business), Miles Miller (Finance / Real Estate), Kyle Rippel (Mechanical Eng)],
  [49], [U of Hawaii at Manoa], [192], [1], [Loic Smedra (Biological Engineering)],

  table.hline(stroke: 0.7pt),
)

// ════════════════════════════════════════════════════
#section[National Liberal Arts Colleges]

#table(
  columns: (auto, col-school, col-rank, col-n, 1fr),
  align: (right, left, right, center, left),
  stroke: none,
  inset: (x: 3pt, y: 2.5pt),
  fill: (_, row) => if row == 0 { rgb("#f0f0f0") } else if calc.odd(row) { rgb("#fafafa") } else { white },
  table.hline(stroke: 0.7pt),

  [*\#*], [*School*], [*Rank*], [*N*], [*Students*],
  table.hline(stroke: 0.4pt),

  [1], [Williams College], [1], [1], [Rebecca Liu (Biochemistry & Molecular Biology)],
  [2], [Claremont McKenna College], [7], [1], [Lukas Minasian (Economics)],
  [3], [Davidson College], [14], [2], [Oliver Baum (Chemistry), Marly Berlin (PPE)],
  [4], [Grinnell College], [17], [1], [Eric Li (History)],
  [5], [Scripps College], [37], [1], [Katie Johnson (International Relations)],
  [6], [Occidental College], [42], [1], [TJ Gibbons (Economics)],

  table.hline(stroke: 0.7pt),
)

// ════════════════════════════════════════════════════
#section[Regional / Specialty]

#table(
  columns: (auto, col-school, col-rank, col-n, 1fr),
  align: (right, left, right, center, left),
  stroke: none,
  inset: (x: 3pt, y: 2.5pt),
  fill: (_, row) => if row == 0 { rgb("#f0f0f0") } else if calc.odd(row) { rgb("#fafafa") } else { white },
  table.hline(stroke: 0.7pt),

  [*\#*], [*School*], [*Rank*], [*N*], [*Students*],
  table.hline(stroke: 0.4pt),

  [1], [Cal Poly SLO], [1], [2], [Ashton Bishop (Business), Elliott Duehr (Liberal Studies)],
  [2], [Babson College], [—], [1], [Chris Ryan (Business)],

  table.hline(stroke: 0.7pt),
)

// ════════════════════════════════════════════════════
#section[International]

#table(
  columns: (auto, col-school, col-n, 1fr),
  align: (right, left, center, left),
  stroke: none,
  inset: (x: 3pt, y: 2.5pt),
  fill: (_, row) => if row == 0 { rgb("#f0f0f0") } else if calc.odd(row) { rgb("#fafafa") } else { white },
  table.hline(stroke: 0.7pt),

  [*\#*], [*School*], [*N*], [*Students*],
  table.hline(stroke: 0.4pt),

  [1], [University of Toronto], [1], [Jack Jin (Undecided)],

  table.hline(stroke: 0.7pt),
)

// ════════════════════════════════════════════════════
#v(10pt)
#line(length: 100%, stroke: 0.5pt + rgb("#ccc"))
#v(6pt)

#columns(2, gutter: 14pt)[

  #text(size: 10pt, weight: "bold")[HYPSM + Ivy League]
  #v(2pt)

  #table(
    columns: (1fr, auto),
    align: (left, right),
    stroke: none,
    inset: (x: 2pt, y: 1.5pt),
    [Harvard], [*3*],
    [Stanford], [*5*],
    [Yale], [*1*],
    [Princeton], [0],
    [MIT], [0],
  )
  #text(size: 8pt, fill: rgb("#444"))[
    *HYPSM total: 9* (8.5% of class) \
    Ivy League total: *13* · Ivy+ (+ Stanford, Duke): *22*
  ]

  #v(8pt)
  #text(size: 10pt, weight: "bold")[Top Schools by Count]
  #v(2pt)

  #set text(size: 7.5pt)
  #table(
    columns: (1fr, auto, auto),
    align: (left, left, right),
    stroke: none,
    inset: (x: 2pt, y: 1.5pt),
    fill: (_, row) => if calc.odd(row) { rgb("#fafafa") } else { white },
    [UC Berkeley], [███████], [7],
    [UChicago], [██████], [6],
    [Stanford], [█████], [5],
    [Michigan], [█████], [5],
    [Santa Clara], [█████], [5],
    [Duke], [████], [4],
    [Harvard], [███], [3],
    [Cornell], [███], [3],
    [Boston College], [███], [3],
    [NYU], [███], [3],
    [Northeastern], [███], [3],
    [Utah], [███], [3],
  )

  #colbreak()

  #text(size: 10pt, weight: "bold")[UC Schools (14 total)]
  #v(2pt)
  #set text(size: 8pt)

  #table(
    columns: (1fr, auto),
    align: (left, right),
    stroke: none,
    inset: (x: 2pt, y: 1.5pt),
    [UC Berkeley], [7],
    [UC Irvine], [2],
    [UCSB], [2],
    [UCSD], [1],
    [UC Riverside], [1],
    [UCLA], [1],
  )

  #v(8pt)
  #text(size: 10pt, weight: "bold")[Athletes (15 of 106 — 14%)]
  #v(2pt)
  #set text(size: 7.5pt)
  #table(
    columns: (1fr, auto),
    align: (left, right),
    stroke: none,
    inset: (x: 2pt, y: 1.5pt),
    fill: (_, row) => if calc.odd(row) { rgb("#fafafa") } else { white },
    [Water Polo], [5],
    [Baseball], [1],
    [Volleyball], [1],
    [Softball], [1],
    [Track & Field], [1],
    [Lacrosse], [1],
    [Football], [1],
    [Golf], [1],
    [Field Hockey], [1],
    [D3 unspecified], [1],
  )

  #v(8pt)
  #text(size: 10pt, weight: "bold")[By Category]
  #v(2pt)
  #set text(size: 8pt)
  #table(
    columns: (1fr, auto, auto, auto),
    align: (left, right, right, right),
    stroke: none,
    inset: (x: 2pt, y: 1.5pt),
    fill: (_, row) => if row == 0 { rgb("#f0f0f0") } else { white },
    [*Category*], [*Schools*], [*Students*], [*%*],
    [National Universities], [49], [95], [89.6],
    [Liberal Arts Colleges], [6], [7], [6.6],
    [Regional / Specialty], [2], [3], [2.8],
    [International], [1], [1], [0.9],
    [*Total*], [*58*], [*106*], [*100*],
  )
]

#v(6pt)
#line(length: 100%, stroke: 0.3pt + rgb("#ddd"))
#v(2pt)
#set text(size: 6.5pt, fill: rgb("#888"))
Generated from 106 unique students (108 Instagram posts). Rankings: US News & World Report 2026. Ranks for Duke (8), UPenn (9), Brown (13), Dartmouth (14), UF (28), Wake Forest (47), Lehigh (56), Penn State (60), Tulane (73), TCU (89), Alabama (105), Williams LAC (1), Davidson LAC (14), Grinnell LAC (17), Occidental LAC (42) are estimates from US News 2025 where 2026 data unavailable.
