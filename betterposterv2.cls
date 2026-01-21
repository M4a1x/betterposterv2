%% betterposterv2.cls
%% A Modern, Simplified LaTeX class for the "Better Poster v2" layout
%% Author: Research Assistant
%% Date: 2026-01-21

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{betterposterv2}[2026/01/21 Better Poster v2 Class]

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
\RequirePackage{caption}        % For \captionof command

% --- 3. Modern LaTeX3 Commands ---
\RequirePackage{xparse}         % For modern command definitions

% --- 4. Typography & Fonts ---
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
        \setmainfont{Fira Sans}[
            UprightFont=*-Regular,
            BoldFont=*-SemiBold,
            ItalicFont=*-Italic,
            BoldItalicFont=*-SemiBoldItalic
        ]
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

% --- 5. Colors ---
\definecolor{bpDark}{HTML}{2E2E2E}       % Dark header/footer
\definecolor{bpLightGrey}{HTML}{F3F3F3}  % Page background
\definecolor{bpDarkerGrey}{HTML}{E6E7E8} % "Background" box color
\definecolor{bpWhite}{HTML}{FFFFFF}      % Content box color

\pagecolor{bpLightGrey}

% --- 6. Page Geometry ---
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

% --- 7. Content Boxes (tcolorbox) ---
\RequirePackage{tcolorbox}
\tcbuselibrary{skins, raster}

% A. Wide Box (Grey Background) - for "Background", "Limitation"
\newtcolorbox{bpwidebox}[1]{
    colback=bpDarkerGrey,
    colframe=bpDarkerGrey,
    width=\linewidth,
    arc=0mm,
    boxrule=0pt,
    left=1.5cm, right=1.5cm, top=1.5cm, bottom=1.5cm,
    title={\textbf{#1}},
    fonttitle=\Large\color{black},
    attach title to upper={\hspace{0.5em}},
    after skip=1.5cm
}

% B. Standard White Box - for "Methods", "Results"
\newtcolorbox{bpwhitebox}[1][]{
    colback=bpWhite,
    colframe=bpWhite,
    arc=4mm,
    boxrule=0pt,
    left=1.5cm, right=1.5cm, top=1.5cm, bottom=1.5cm,
    fonttitle=\bfseries\Large\color{black},
    coltitle=black,
    detach title,
    before upper={\ifx\tcbtitle\empty\else{\Large\bfseries\tcbtitle\par\medskip}\fi},
    #1
}

% C. Column Layout
\NewDocumentEnvironment{bpcolumns}{O{2}}{%
    \begin{tcbraster}[
            raster columns=#1,
            raster equal height=rows,
            raster column skip=1.5cm,
            raster width=\linewidth
        ]
        }{%
    \end{tcbraster}
}

% D. Section Header
\NewDocumentCommand{\bpsection}{m}{%
    \par\vspace{0.5cm}{\Huge\bfseries\color{black} #1}\par\vspace{0.8cm}%
}

% --- 8. Header & Footer Implementation ---

% Variables to store user input using modern command definitions
\NewDocumentCommand{\mainfinding}{m}{%
    \gdef\@mainfinding{#1}%
}
\NewDocumentCommand{\@mainfinding}{}{Insert Main Finding Here}

\NewDocumentCommand{\footercontent}{m}{%
    \gdef\@footercontent{#1}%
}
\NewDocumentCommand{\@footercontent}{}{}

% Clear default headers
\clearpairofpagestyles

% A. Define the Background Layers (The Dark Bars)
\DeclareNewLayer[
    background,
    topmargin,
    mode=picture,
    contents={\color{bpDark}\rule{\paperwidth}{15cm}}
]{layer.header.bg}

\DeclareNewLayer[
    background,
    bottommargin,
    mode=picture,
    contents={\color{bpDark}\rule{\paperwidth}{13cm}}
]{layer.footer.bg}

% B. Define the Content Layers (The Text/Images)
% Top Header Text
\DeclareNewLayer[
    foreground,
    topmargin,
    contents={%
            \parbox[c][15cm][c]{\paperwidth}{%
                \hspace{5cm}%
                \parbox{\dimexpr\paperwidth-10cm\relax}{%
                    \color{white}\bfseries\fontsize{80}{95}\selectfont
                    \raggedright
                    \@mainfinding
                }%
            }%
        }
]{layer.header.content}

% Bottom Footer Content
\DeclareNewLayer[
    foreground,
    bottommargin,
    contents={%
            \parbox[c][13cm][c]{\paperwidth}{%
                \hspace{5cm}%
                \parbox{\dimexpr\paperwidth-10cm\relax}{%
                    \color{white}%
                    \@footercontent
                }%
            }%
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

% --- 9. Title Block Redefinition ---
\RenewDocumentCommand{\maketitle}{}{%
    \begingroup
    \raggedright
    \color{black}%
    \fontsize{50}{65}\selectfont
    \@title\par
    \endgroup
    \vspace{2cm}%
}

\endinput