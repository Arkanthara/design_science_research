#import "@preview/touying:0.6.1": *
#import themes.university: *

#let author = "Blabla"

#let custom-university-theme = university-theme.with(
  aspect-ratio: "16-9",
  progress-bar: true,

  config-methods(
    init: (self: none, body) => {
      set text(fill: self.colors.text, size: 25pt)
      show footnote.entry: set text(size: .6em)
      show strong: self.methods.alert.with(self: self)
      show heading.where(level: self.slide-level + 1): set text(1.4em, fill: self.colors.secondary-dark)
      show heading.where(level: self.slide-level + 2): set text(1.2em, fill: self.colors.tertiary-dark)
      body
    },
  ),

  header-right: image("img/unige_catppuccin.svg", height: 80%),
  header: self => {
    v(0.5em)
    h(0.5em)
    set text(1.5em)
    utils.display-current-heading(level: 2)
  },

  footer-columns: (30%, 1fr, 30%),
  footer-a: self => {
    set text(1.5em, fill: self.colors.neutral, weight: "bold")
    author
  },
  footer-b: self => {
    set text(1.5em, fill: self.colors.neutral, weight: "bold")
    utils.display-current-heading(level: 1)
  },
  footer-c: self => {
    h(1fr)
    set text(1.5em, fill: self.colors.neutral, weight: "bold")
    utils.display-info-date(self)
    h(1fr)
    context utils.slide-counter.display() + " / " + utils.last-slide-number
    h(1fr)
  },

  config-info(
    title: [Advanced Topics in Computer Science],
    subtitle: [A Deep Dive into Algorithms],
    author: text(rgb("#cad3f5"))[#author],
    date: datetime.today(),
    institution: [XYZ University],
  ),

  // === MACCHIATO BACKGROUND GRADIENT ===
  config-page(
    fill: gradient.linear(
      rgb("#24273a"), // Base
      rgb("#363a4f"), // Surface0
      angle: 35deg,
    ),
    margin: (top: 3.5em),
  ),

  config-common(auto-offset-for-heading: false),

  // === CATPPUCCIN MACCHIATO COLOR PALETTE ===
  config-colors(
    // --- Neutral scale (Base → Text)
    neutral: rgb("#24273a"), // Base
    neutral-dark: rgb("#1e2030"), // Mantle
    neutral-darker: rgb("#181926"), // Crust
    neutral-darkest: rgb("#0f1018"), // deeper shade for contrast

    neutral-light: rgb("#363a4f"), // Surface0
    neutral-lighter: rgb("#494d64"), // Surface1
    neutral-lightest: rgb("#5b6078"), // Surface2

    // Light text scale
    text: rgb("#cad3f5"), // Text
    text-dim: rgb("#a5adcb"), // Subtext0
    text-dimmer: rgb("#939ab7"), // Overlay2
    //
    // --- Primary scale (Mauve)
    primary: rgb("#c6a0f6"),
    primary-dark: rgb("#a984e6"),
    primary-darker: rgb("#8c6cd1"),
    primary-darkest: rgb("#6e53ad"),

    primary-light: rgb("#d7b8f9"),
    primary-lighter: rgb("#e6cffd"),
    primary-lightest: rgb("#f4eaff"),

    // --- Secondary scale (Pink)
    secondary: rgb("#f5bde6"),
    secondary-dark: rgb("#d9a2ca"),
    secondary-darker: rgb("#b885ac"),
    secondary-darkest: rgb("#916986"),

    secondary-light: rgb("#f9cdee"),
    secondary-lighter: rgb("#fbe0f6"),
    secondary-lightest: rgb("#fff1fb"),

    // --- Tertiary scale (Blue)
    tertiary: rgb("#8aadf4"),
    tertiary-dark: rgb("#7695e6"),
    tertiary-darker: rgb("#5d7bcc"),
    tertiary-darkest: rgb("#4a63a8"),

    tertiary-light: rgb("#a8c3ff"),
    tertiary-lighter: rgb("#c7d6ff"),
    tertiary-lightest: rgb("#e5ecff"),
  ),
)
