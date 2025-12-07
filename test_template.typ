#import "@preview/touying:0.6.1": *

// Function to create a slides template
#let create-slides-template(
  // Required fields
  logo: none,
  logosize: none,
  university: none,
  title: none,
  authors: none,
  // Optional fields
  faculty: none,
  subtitle: none,
  course-name: none,
  course-id: none,
  illustrations: none,
  project-name: none,
  github: none,
  github-link: none,
  date: none,
  // Background options
  default-background: none, // Can be image path or color
  // Slide options
  aspect-ratio: "16-9",
  footer: none,
) = {
  (
    logo: logo,
    logosize: logosize,
    university: university,
    title: title,
    authors: authors,
    faculty: faculty,
    subtitle: subtitle,
    course-name: course-name,
    course-id: course-id,
    illustrations: illustrations,
    project-name: project-name,
    github: github,
    github-link: github-link,
    date: date,
    default-background: default-background,
    aspect-ratio: aspect-ratio,
    footer: footer,
  )
}

// State for background management
#let slide-background = state("slide-background", ())

// Function to set background for subsequent slides
#let set-background(background) = {
  slide-background.update(background)
}

// Function to reset to default background
#let reset-background() = {
  slide-background.update(())
}

// Custom slide method with background support
#let slide-with-background(title: auto, background: auto, ..args) = {
  // Determine which background to use
  let current-background = if background != auto {
    background
  } else if slide-background.get() != () {
    slide-background.get()
  } else {
    none
  }

  // Store the title for header
  let store-title = if title != auto { title } else { none }

  touying-slide-wrapper(self => {
    // Update store with title
    if store-title != none {
      self.store.title = store-title
    }

    // Handle background
    let background-content = if current-background != none {
      if (
        type(current-background) == "string" and current-background.ends-with((".png", ".jpg", ".jpeg", ".svg", ".gif"))
      ) {
        // Image background
        image(current-background, width: 100%, height: 100%)
      } else {
        // Color background
        rect(fill: current-background, width: 100%, height: 100%)
      }
    } else {
      none
    }

    // Header configuration
    let header(self) = {
      set align(top)
      show: components.cell.with(fill: rgba(0, 0, 0, 0.7), inset: 0.8em)
      set align(horizon)
      set text(fill: white, size: 0.8em)

      grid(
        columns: 3,
        gutter: 1cm,
        [
          #if self.store.title != none {
            utils.call-or-display(self, self.store.title)
          } else {
            " "
          }
        ],
        [
          #set align(center)
          #if self.info.institution != none {
            self.info.institution
          } else {
            " "
          }
        ],
        [
          #set align(right)
          #if self.info.date != none {
            utils.display-info-date(self)
          } else {
            " "
          }
        ],
      )
    }

    // Footer configuration
    let footer(self) = {
      set align(bottom)
      show: components.cell.with(fill: rgba(0, 0, 0, 0.7), inset: 0.5em)
      set text(fill: white, size: 0.7em)

      grid(
        columns: 3,
        gutter: 1cm,
        [
          #if self.info.author != none {
            self.info.author
          } else {
            " "
          }
        ],
        [
          #set align(center)
          #context utils.slide-counter.display() + " / " + utils.last-slide-number
        ],
        [
          #set align(right)
          #if self.info.title != none {
            self.info.title
          } else {
            " "
          }
        ],
      )
    }

    // Configure page with background, header, and footer
    let page-config = if background-content != none {
      config-page(
        fill: background-content,
        header: header,
        footer: footer,
      )
    } else {
      config-page(
        header: header,
        footer: footer,
      )
    }

    self = utils.merge-dicts(self, page-config)
    touying-slide(self: self, ..args)
  })
}

// Title slide method
#let title-slide(..args) = {
  touying-slide-wrapper(self => {
    let info = self.info + args.named()

    // Use default background for title slide if available
    let bg-content = if self.store.default-background != none {
      let bg = self.store.default-background
      if type(bg) == "string" and bg.ends-with((".png", ".jpg", ".jpeg", ".svg", ".gif")) {
        image(bg, width: 100%, height: 100%)
      } else if bg != none {
        rect(fill: bg, width: 100%, height: 100%)
      } else {
        none
      }
    } else {
      none
    }

    let body = {
      set align(center + horizon)

      // Background for title slide
      if bg-content != none {
        set page(fill: bg-content)
      }

      v(20%)

      // Title content
      block(
        fill: rgba(0, 0, 0, 0.8),
        width: 80%,
        inset: 2em,
        radius: 1em,
        [
          #set text(size: 2.5em, fill: white, weight: "bold")
          #info.title

          #if info.subtitle != none {
            set text(size: 1.5em, weight: "normal")
            linebreak()
            info.subtitle
          }
        ],
      )

      v(2em)

      // Authors and institution
      block(
        fill: rgba(0, 0, 0, 0.8),
        width: 60%,
        inset: 1.5em,
        radius: 0.5em,
        [
          #set text(fill: white, size: 1.2em)
          #if info.author != none {
            info.author
            linebreak()
          }
          #if info.institution != none {
            info.institution
            linebreak()
          }
          #if info.date != none {
            utils.display-info-date(self)
          }
        ],
      )

      // GitHub info
      if self.store.github != none {
        v(1em)
        block(
          fill: rgba(0, 0, 0, 0.8),
          width: 40%,
          inset: 1em,
          radius: 0.5em,
          [
            #set text(fill: white, size: 1em)
            #if self.store.github-link != none {
              [GitHub: #link(self.store.github-link)[#self.store.github]]
            } else {
              [GitHub: #self.store.github]
            }
          ],
        )
      }
    }

    // Configure title slide page
    self = utils.merge-dicts(
      self,
      config-page(
        header: none,
        footer: none,
      ),
    )
    touying-slide(self: self, body)
  })
}

// Section slide method
#let section-slide(self: none, body) = {
  touying-slide-wrapper(self => {
    let main-body = {
      set align(center + horizon)
      set text(size: 2.5em, fill: white, weight: "bold")
      block(
        fill: rgba(0, 0, 0, 0.8),
        width: 80%,
        inset: 2em,
        radius: 1em,
        body,
      )
    }

    self = utils.merge-dicts(
      self,
      config-page(
        header: none,
        footer: none,
      ),
    )
    touying-slide(self: self, main-body)
  })
}

// Focus slide method
#let focus-slide(body) = {
  touying-slide-wrapper(self => {
    self = utils.merge-dicts(
      self,
      config-page(
        fill: rgb("#1e3a8a"),
        margin: 2em,
        header: none,
        footer: none,
      ),
    )
    set text(fill: white, size: 2em)
    touying-slide(self: self, align(horizon + center, body))
  })
}

// Main theme function
#let university-slides-theme(
  template,
  ..args,
) = {
  set text(size: 20pt)

  show: touying-slides.with(
    config-page(
      paper: "presentation-" + template.aspect-ratio,
      margin: (top: 3em, bottom: 3em, x: 2em),
    ),
    config-common(
      slide-fn: slide-with-background,
      new-section-slide-fn: section-slide,
    ),
    config-methods(
      alert: utils.alert-with-primary-color,
    ),
    config-colors(
      primary: rgb("#1e3a8a"),
      secondary: rgb("#dc2626"),
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#000000"),
    ),
    config-store(
      title: none,
      footer: template.footer,
      default-background: template.default-background,
      github: template.github,
      github-link: template.github-link,
    ),
    config-info(
      title: template.title,
      subtitle: template.subtitle,
      author: if template.authors != none {
        template.authors.map(a => if "name" in a and a.name != none { a.name } else { "" }).join(", ")
      } else {
        ""
      },
      date: if template.date != none { template.date } else { datetime.today() },
      institution: if template.university != none {
        if template.faculty != none {
          template.university + " - " + template.faculty
        } else {
          template.university
        }
      } else {
        ""
      },
    ),
    ..args,
  )
}

// Main function to create slides
#let make-slides(template, body) = {
  // Initialize background state with template's default background
  slide-background.update(template.default-background)

  university-slides-theme(template)
  body
}

// Example usage
#let example-slides() = {
  let template = create-slides-template(
    university: "University Name",
    title: "Presentation Title",
    authors: (
      (name: "John Doe", affiliation: "Faculty of Science"),
      (name: "Jane Smith", affiliation: "Faculty of Engineering"),
    ),
    faculty: "Faculty of Science",
    subtitle: "A Comprehensive Study",
    project-name: "Research Project",
    github: "username/repo",
    github-link: "https://github.com/username/repo",
    date: "2024-01-01",
    default-background: blue.lighten(20%), // Default background color
    aspect-ratio: "16-9",
  )

  make-slides(template)[
    #title-slide()

    = Introduction

    == First Slide

    This is a slide with *important* information.

    #lorem(40)

    == Second Slide

    #set-background(red.lighten(20%))
    [
    This slide has a red background.
    ]

    #alert[This text is highlighted!]

    = Methodology

    == Third Slide

    #reset-background()
    [
    Back to default background.
    ]

    #focus-slide[
      Key point to focus on!
    ]
  ]
}

// Uncomment to test
#example-slides()
