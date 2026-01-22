
# betterposterv2

A modern LaTeX class for building “Better Poster v2”-style scientific posters, with ETH-inspired color schemes as the current defaults.

- Class file: [betterposterv2.cls](betterposterv2.cls)
- Example poster: [poster.tex](poster.tex)

## Overview

This project provides a single class, `betterposterv2`, that focuses on:

- a prominent **main finding** in the header,
- a simple grid-based **content box** layout,
- a structured footer with optional QR code, affiliations, logo, portrait, etc.

The shipped preset uses an ETH-like palette, but the design is intended to be *neutral*: colors can be switched via options or overridden individually.

## Requirements

- A reasonably modern TeX distribution (TeX Live / MiKTeX).
- **LuaLaTeX** (recommended) or **XeLaTeX** for font support (the class is set up for modern OpenType fonts via `fontspec` / `unicode-math`).
- Core packages are loaded by the class (notably `geometry`, `scrlayer-scrpage`, `tcolorbox`, `fontspec`, `unicode-math`, `hyperref`, …).

If you compile with pdfLaTeX, the class will fall back, but modern font features will be limited. This has not been extensively tested with old TeX versions.

## Quick start

1. Put [betterposterv2.cls](betterposterv2.cls) next to your `poster.tex` file
2. Start from the example in [poster.tex](poster.tex).

Minimal example (adapted from [poster.tex](poster.tex)):

```tex
\documentclass{betterposterv2}

\mainfinding{You can easily spend a day creating a LaTeX Layout, when you should actually work}
\title{Investigating procrastination and layout quality}

\authors{Tess Tomorrow, Drew One-More-Minute Deferral}
\affiliations{Department of Procrastination Studies, University of Uncertainty}
\publicationyear{2026}
% Optional:
% \qrcode{path/to/qr-code}
% \logo{path/to/logo}
% \portrait{path/to/photo}

\begin{document}
\maketitle

\begin{bpbox}[bpcolor=grey, title={Background}]
	...
\end{bpbox}

\begin{bpcolumns}[2]
	\begin{bpbox}[title={Result 1}, bptitlebg=transparent]
		...
	\end{bpbox}
	\begin{bpbox}[title={Result 2}, bptitlebg=transparent]
		...
	\end{bpbox}
\end{bpcolumns}

\bpsection{Methods}
\begin{bpbox}[title={}]
	...
\end{bpbox}
\end{document}
```

### Compile

Using LuaLaTeX directly:

```sh
lualatex poster.tex
```

If you use `latexmk`:

```sh
latexmk -lualatex -interaction=nonstopmode -halt-on-error poster.tex
```

## Class options

Defined in [betterposterv2.cls](betterposterv2.cls). See also [poster.tex](poster.tex):

- `colorscheme=default|green|blue|red|purple`
- `fontsize=42pt` (and similar sizes supported by KOMA-Script)
- `papersize=a0paper|a1paper|...`
- `orientation=portrait|landscape`
- `debug=true|false` (enables `showframe` + KOMA draft markers)

## Customization

### Geometry

Override header/footer heights and margins (see [poster.tex](poster.tex)):

- `\SetHeaderHeight{20cm}`
- `\SetFooterHeight{10cm}`
- `\SetSideMargin{3cm}`

### Colors

The class applies a scheme at end of preamble via `\SetColorScheme{...}` (see [betterposterv2.cls](betterposterv2.cls)). You can also override individual roles:

- `\SetPageColor{<color>}`
- `\SetHeaderColor{<color>}`, `\SetHeaderTextColor{<color>}`
- `\SetFooterColor{<color>}`, `\SetFooterTextColor{<color>}`
- `\SetLightBoxColor{<color>}`, `\SetDarkBoxColor{<color>}`

### Content building blocks

- `\mainfinding{...}`: header statement
- `\title{...}` + `\maketitle`: title block
- `bpbox` environment: content boxes (based on `tcolorbox`)
- `bpcolumns` environment: grid layout for multiple columns
- Footer fields: `\authors`, `\affiliations`, `\publicationyear`, optional `\qrcode`, `\logo`, `\portrait`

## Project status

This class is functional but not “finished”. The current focus is a clean baseline and an ETH-inspired default palette.

Contributions are welcome, especially:

- additional color schemes,
- typographic improvements,
- better defaults for different paper sizes/orientations,
- code review and simplification of the class internals.

## Contributing

- Open issues for bugs, layout problems, and feature requests.
- Pull requests are welcome for incremental, well-scoped changes (new color schemes are a great starting point).
- Keep changes compatible with LuaLaTeX/XeLaTeX workflows.

## Credits / Inspiration

The layout approach is inspired by Mike Morrison’s *“Better Poster”* concept ([v2, Portrait](https://osf.io/ef53g/files/g6xsm)). This repository is an independent LaTeX implementation and is *not* an official ETH or betterposter template.

## License

See [LICENSE.md](LICENSE.md).
