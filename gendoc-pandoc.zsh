#!/usr/bin/zsh

# Default options.
typeset -g standalone=yes
typeset -g embed_relay=yes
typeset -g toc=yes
typeset -gA toc_in
unset wrap
unset column
typeset -g tex_geo="a4paper"
typeset -g tex_margin="1in"
typeset -g tex_docclass="ltjsarticle"
unset tex_font
unset tex_mainfont
unset tex_mainjfont
unset tex_sansfont
unset tex_monofont
unset tex_font_en
unset tex_mainfont_en
unset tex_sansfont_en
unset tex_monofont_en
typeset -g listings=no
typeset -ga tex_headers
unset dest_dir
typeset -g crossref=no
typeset -g reveal_theme="white"
typeset -gi reveal_slidelevel=2
typeset -g html_css="./markdown.css"

#### SET OPTIONS ####

set_standalone() {
  if [[ $standalone == yes ]]
  then
    pandoc_opts+=("-s")
  fi
}

set_selfcontained() {
  if [[ $embed_relay == yes ]]
  then
    pandoc_opts+=("--self-contained")
  fi
}

set_toc() {
  if [[ $GENDOC_TOC != no && ( $GENDOC_TOC == yes || $toc == yes || $toc_in[$1] == yes ) ]]
  then
    pandoc_opts+=("--toc")
  fi
}

set_wrap() {
  if [[ -n $wrap ]]
  then
    pandoc_opts+=("--wrap" "$wrap")
  fi  
}


set_column() {
  if [[ -n $column || -n $GENDOC_COLUMN ]]
  then
    pandoc_opts+=("--column" "${GENDOC_COLUMN:-${column}}")
  fi  
}


set_tex() {
  pandoc_opts+=("-s" "-f" "markdown" "-V" "geometry=$tex_geo" -V "geometry:margin=$tex_margin" "-V" "documentclass=$tex_docclass" "--pdf-engine=lualatex")

  if [[ -n "${tex_font:-${tex_mainfont:-${tex_mainjfont}}}" ]]
  then
    pandoc_opts+=("-V" "CJKmainfont=${tex_font:-${tex_mainfont:-${tex_mainjfont}}}")
  fi

  if [[ -n "${tex_sansfont:-${tex_sansjfont}}" ]]
  then
    pandoc_opts+=("-V" "CJKsansfont=${tex_sansfont:-${tex_sansjfont}}")
  fi
  
  if [[ -n "${tex_monofont:-${tex_monojfont}}" ]]
  then
    pandoc_opts+=("-V" "CJKmonofont=${tex_monofont:-${tex_monojfont}}")
  fi

  if [[ -n "${tex_font_en:-${tex_mainfont_en}}" ]]
  then
    pandoc_opts+=("-V" "mainfont=${tex_font_en:-${tex_mainfont_en}}")
  fi

  if [[ -n "${tex_sansfont_en}" ]]
  then
    pandoc_opts+=("-V" "sansfont=${tex_sansfont_en}")
  fi

  if [[ -n "${tex_monofont_en}" ]]
  then
    pandoc_opts+=("-V" "monofont=${tex_monofont_en}")
  fi


  set_toc
  set_wrap
  set_column
  add_texheaders
  use_listings
  use_crossref
  set_files "$filename" $1
}

set_reveal() {
  pandoc_opts+=("-t" "revealjs" "--slide-level=$reveal_slidelevel" "-V" "theme:$reveal_theme" "-s")
  set_selfcontained
  use_crossref
  set_files "$filename" html
}

set_html() {
  pandoc_opts+=("-t" "html5" "-c" "$html_css")
  set_toc
  set_standalone
  set_selfcontained
  use_crossref
  set_files "$filename" html
}

use_crossref() {
  if [[ $crossref == yes ]]
  then
    pandoc_opts+=("--filter" "pandoc-crossref")
  fi
}

use_listings() {
  if [[ $GENDOC_LISTINGS != no && ( $GENDOC_LISTINGS == yes || $listings == yes ) ]]
  then
    pandoc_opts+=(--listings)
  fi
}

add_texheaders() {
  if (( ${#tex_headers} > 0 ))
  then
    for i in "${(@)tex_headers}"
    do
      pandoc_opts+=(-H "$i")
    done
  fi
}

set_files() {
  if [[ -n $outfile && -d $outfile ]]
  then
    pandoc_opts+=("-o" "$outfile/${${1:t}:r}.$2" "$1")
  elif [[ -n $outfile ]]
  then
    pandoc_opts+=("-o" "$outfile" "$1")
  elif [[ -n $dest_dir ]]
  then
    pandoc_opts+=("-o" "$dest_dir/${${1:t}:r}.$2" "$1")
  else
    pandoc_opts+=("-o" "${1:r}.$2" "$1")
  fi
}

#### SET CONFIG ####

if [[ $GENDOC_NORC != yes && -f $HOME/.config/yek/gendoc-pandocrc.zsh ]]
then
  . $HOME/.config/yek/gendoc-pandocrc.zsh
fi

if [[ -f ${GENDOC_ALTRC:-./.gendocrc.zsh} ]]
then
  . ${GENDOC_ALTRC:-./.gendocrc.zsh}
fi

#### PREPARE ####

typeset -ag pandoc_opts=()

#### GO ####

typeset -g mode="$1"
typeset -g filename="$2"
typeset -g outfile="$3"

case "$mode" in
  htmlsimple)
    pandoc_opts=("-s" "-t" "html5")
    set_files "$filename" html
    ;;
  html)
    set_html
    ;;
  slide|reveal)
    set_reveal
    ;;
  texpdf)
    set_tex pdf
    ;;
  tex)
    set_tex tex
    ;;
  *)
    print "Mode $mode is not supported." >&2
    print -l "Currentry supported formats are: " "html" "slide" "texpdf" >&2
    exit 1
esac

pandoc "${(@)pandoc_opts}"



