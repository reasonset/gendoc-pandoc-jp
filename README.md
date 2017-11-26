# GenDoc Pandoc

Pandocを用いてドキュメントを生成します。


## Description

Pandocの複雑なオプションを簡単に取り扱うためのユーティリティスクリプトです。

このスクリプトは日本語環境を優先して調整してあります。

## Install

gendoc-pandoc.zshを実行可能なディレクトリにコピーしてください。

## Usage

### Files

gendoc-pandoc.zshは`~/.config/yek/gendoc-pandoc.zsh`があればそれを読み、
次に`./.gendoc-pandoc.zsh`を読み込みます。

これらのファイルによって変数を定義することができます。

これらの設定ファイルは必須ではありませんが、設定ファイルを使用しない場合、フォーマットに`html`を指定する際にはカレントディレクトリに`markdown.css`ファイルを配置する必要があります。
または`html`のかわりに`htmlsimple`を使用してください。

設定ファイルは環境や用途に合わせた調整であり、*configサンプルを使用するよりもデフォルトのほうが確実に動きます。*

### Command

```bash
gendoc-pandoc.zsh <format> <file>
```

formatとして次のものが指定できます。

|format|動作|
|---------|----------------|
|`html`|HTMLファイルを出力します。|
|`htmlsimple`|CSSを使わずstandaloneなHTMLファイルを出力します。設定ファイルの内容は無視されます。|
|`tex`|TeXで出力します。|
|`texpdf`|TeX経由でPDF出力します。`--pdf-engine`として`lualatex`を使用します。|
|`reveal`|reveal.jsスライドとして出力します。カレントディレクトリにreveal.jsフォルダがある必要があります。|


## Configuration

変数をセットすることで振る舞いや設定を変更することができます。

|パラメータ|デフォルト|効果|
|--------|---------|-----------------------|
|`standalone`|yes|HTMLファイルで完全なHTMLを生成します。`-s`に変換されますが、TeXを使う場合はこのオプションによらず設定されます。|
|`embed_relay`|yes|HTMLを使う場合に`--self-contained`に変換されます。CSSや画像などをdataスキームでHTMLファイルに埋め込みます。|
|`toc`|yes|目次を生成します。`--toc`に変換されます。|
|`toc_in`||連想配列です。`toc`が`no`の場合に、ここで値にyesを指定されたキーのフォーマットでのみ`--toc`が適用されます。`toc_in[texpdf]=yes`のように使用します。フォーマットはコマンドの第一引数と同じです。|
|`wrap`||`--wrap`オプションを指定します。値をオプションの値として使用します。|
|`column`||`--column`オプションを指定します。`texpdf`でテーブルが右に突き抜けてしまう場合に有効です。環境変数`$GENDOC_COLUMN`を指定した場合でも適用されます。値をオプションの値として使用します。|
|`tex_geo`|`a4paper`|TeXにおいて用紙フォーマットを指定します。|
|`tex_margin`|`1in`|TeXにおいてページマージンを指定します。|
|`tex_docclass`|`ltjsarticle`|TeXにおいてドキュメントクラスを指定します。LuaTeXのものを用いることができます。|
|`tex_font`||和文フォント(通常)を指定します。`tex_mainfont`または`tex_mainjfont`も許容します。|
|`tex_sansfont`||和文フォント(ゴシック体)を指定します。`tex_sansjfont`も許容します。|
|`tex_monofont`||和文フォント(等幅)を指定します。`tex_monojfont`も許容します。|
|`tex_font_en`||欧文フォント(通常)を指定します。`tex_mainfont_en`も許容します。|
|`tex_sansfont_en`||欧文フォント(サンセリフ)を指定します。|
|`tex_monofont_en`||欧文フォント(モノスペース)を指定します。|
|`dest_dir`||出力ディレクトリを指定します。指定しない場合、ソースと同じディレクトリに出力します。|
|`listings`|no|TeXにおいてlistingsパッケージを使用します。ブロックコードの整形と機能が改善します。ただし、適切に機能するには設定が必要で、`tex_headers`で指定する必要があるでしょう。またはYAMLヘッダーの`header-includes`で指定してください。`listings-templates`ディレクトリにはいくつかのサンプルとなるヘッダファイルが含まれています。|
|`crossref`|no|pandoc-crossrefを使用します。|
|`tex_headers`||TeXの追加ヘッダファイルを指定する配列です。`tex_headers+=(path/to/file.tex)`のように指定してください。配列への追加であれば複数回指定することができます。|
|`reveal_theme`|`white`|reveal.jsのテーマを指定します。|
|`reveal_slidelevel`|`2`|reveal.jsにおけるスライドレベルを指定します。この値は無効かもしれません。|
|`html_css`|`./markdown.css`|HTML出力をする際に使用するCSSファイルを指定します。|

## Depends

- zsh
- pandoc
- texlive (`tex`及び`texpdf`のため)
- texlive-langjapanese (`tex`及び`texpdf`で日本語を扱うため)
- pandoc-crossref (crossrefを使う場合)