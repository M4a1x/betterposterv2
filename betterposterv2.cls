%% betterposterv2.cls
%% A Modern, Simplified LaTeX class for the "Better Poster v2" layout
%% Author: Research Assistant
%% Date: 2026-01-21

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{betterposterv2}[2026/01/21 v2.1 Simplified Better Poster Class]

% --- 1. Base Class & Engine ---
% We use scrartcl (KOMA-Script article) as the base.
% - a0paper: Sets the size.
% - fontsize=25pt: Sets the base font size large enough for A0.
\LoadClass[fontsize=25pt, parskip=half, a0paper]{scrartcl}

% Check for LuaLaTeX/XeLaTeX for modern font support
\RequirePackage{iftex}

% --- 2. Essential Layout Packages ---
\RequirePackage{geometry}       % For margins
\RequirePackage{xcolor}         % For colors
\RequirePackage{graphicx}       % For images
\RequirePackage{calc}           % For size calculations
\RequirePackage{scrlayer-scrpage} % KOMA-Script headers/footers

% --- 3. Typography & Fonts ---
\RequirePackage{microtype}      % Improves text spacing/appearance

% Font Loading: Prefer Fira Sans (Modern, Open Source), fallback to Helvetica
\ifboolexpr{bool{luatex} or bool{xetex}}{
    \RequirePackage{fontspec}
    % Try loading Fira Sans
    \IfFontExistsTF{Fira Sans}{
        \setsansfont{Fira Sans}[
            UprightFont=*-Regular,
            BoldFont=*-SemiBold,
            ItalicFont=*-Italic,
            BoldItalicFont=*-SemiBoldItalic
        ]
        % Use Fira Sans as the main font for the poster
        \setmainfont{Fira Sans}
    }{
        % Fallback if Fira Sans is not installed
        \setsansfont{Arial}
        \setmainfont{Arial}
    }
}{
    % PDFLaTeX fallback
    \RequirePackage[T1]{fontenc}
    \RequirePackage{helvet}
    \renewcommand{\familydefault}{\sfdefault}
}

% --- 4. Colors ---
\definecolor{bpDark}{HTML}{2E2E2E}       % Dark header/footer
\definecolor{bpLightGrey}{HTML}{F3F3F3}  % Page background
\definecolor{bpDarkerGrey}{HTML}{E6E7E8} % "Background" box color
\definecolor{bpWhite}{HTML}{FFFFFF}      % Content box color

\pagecolor{bpLightGrey}

% --- 5. Page Geometry ---
% We set the margins for the *content* area. 
% The Header and Footer will be drawn outside these margins.
\geometry{
    top=16cm,      % Space for the top header
    bottom=13cm,   % Space for the bottom footer
    left=5cm,      % Left content margin
    right=5cm,     % Right content margin
    headheight=15cm, % Height of the header bar
    headsep=1cm,     % Gap between header and content
    footskip=1cm     % Gap between content and footer
}

% --- 6. Content Boxes (tcolorbox) ---
\RequirePackage{tcolorbox}
\tcbuselibrary{skins, raster}

% A. Wide Box (Grey Background) - for "Background", "Limitation"
\newtcolorbox{bpwidebox}[1]{
    colback=bpDarkerGrey,
    colframe=bpDarkerGrey,
    width=\linewidth,    % Ensure it fills the text area
    arc=0mm,
    boxrule=0pt,
    left=1.5cm, right=1.5cm, top=1.5cm, bottom=1.5cm,
    title={\textbf{#1}}, % Bold title
    fonttitle=\Large\color{black},
    attach title to upper={\hspace{0.5em}}, % Run-in title
    after skip=1.5cm
}

% B. Standard White Box - for "Methods", "Results"
\newtcolorbox{bpwhitebox}[1][]{
    colback=bpWhite,
    colframe=bpWhite,
    arc=4mm,             % Rounded corners
    boxrule=0pt,
    left=1.5cm, right=1.5cm, top=1.5cm, bottom=1.5cm,
    fonttitle=\bfseries\Large\color{black},
    coltitle=black,
    detach title,        % Title is not in a separate bar
    before upper={\ifx\tcbtitle\empty\else{\Large\bfseries\tcbtitle\par\medskip}\fi},
    #1
}

% C. Column Layout (The Fix)
% We use 'tcbraster' to handle columns automatically.
\newenvironment{bpcolumns}[1][2]{%
    \begin{tcbraster}[
            raster columns=#1,
            raster equal height=rows, % Make boxes same height
            raster column skip=1.5cm, % Gap between columns
            raster width=\linewidth   % STRICTLY enforce width to prevent stacking
        ]
        }{%
    \end{tcbraster}
}

% D. Section Header (Simple text)
\newcommand{\bpsection}[1]{%
    \par\vspace{0.5cm}{\Huge\bfseries\color{black} #1}\par\vspace{0.8cm}%
}

% --- 7. Header & Footer Implementation ---

% Variables to store user input
\newcommand{\@mainfinding}{Insert Main Finding Here}
\newcommand{\mainfinding}[1]{\renewcommand{\@mainfinding}{#1}}

\newcommand{\@footercontent}{}
\newcommand{\footercontent}[1]{\renewcommand{\@footercontent}{#1}}

% Clear default headers
\clearpairofpagestyles

% A. Define the Background Layers (The Dark Bars)
\DeclareNewLayer[
    background,
    topmargin,
    mode=picture,
    contents={\color{bpDark}\rule{\paperwidth}{15cm}} % 15cm high dark bar
]{layer.header.bg}

\DeclareNewLayer[
    background,
    bottommargin,
    mode=picture,
    contents={\color{bpDark}\rule{\paperwidth}{13cm}} % 13cm high dark bar
]{layer.footer.bg}

% B. Define the Content Layers (The Text/Images)
% Top Header Text
\DeclareNewLayer[
    foreground,
    topmargin,
    contents={%
            \parbox[c][15cm][c]{\paperwidth}{%
                \hspace{5cm} % Left margin alignment
                \parbox{\dimexpr\paperwidth-10cm\relax}{%
                    \color{white}\bfseries\fontsize{80}{95}\selectfont
                    \raggedright
                    \@mainfinding
                }
            }
        }
]{layer.header.content}

% Bottom Footer Content
\DeclareNewLayer[
    foreground,
    bottommargin,
    contents={%
            \parbox[c][13cm][c]{\paperwidth}{%
                \hspace{5cm} % Left margin alignment
                \parbox{\dimexpr\paperwidth-10cm\relax}{%
                    \color{white}
                    \@footercontent
                }
            }
        }
]{layer.footer.content}

% Add layers to the page style
\AddLayersToPageStyle{scrheadings}{
    layer.header.bg,
    layer.header.content,
    layer.footer.bg,
    layer.footer.content
}
\pagestyle{scrheadings}

% --- 8. Title Block Redefinition ---
\renewcommand{\maketitle}{
    \begingroup
    \raggedright
    \color{black}
    \fontsize{50}{65}\selectfont
    \@title \par
    \endgroup
    \vspace{2cm}
}

\endinput