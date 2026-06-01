# frozen_string_literal: true

require "test_helper"

class TestCjkFriendlyEmphasis < Minitest::Test
  def setup
    @parse_opts = [:DEFAULT, :CJK_FRIENDLY_EMPHASIS]
    @strikethrough_parse_opts = [:DEFAULT, :CJK_FRIENDLY_EMPHASIS, :STRIKETHROUGH_DOUBLE_TILDE]
  end

  def test_option_registered
    assert_includes(QiitaMarker::Config::OPTS[:parse].keys, :CJK_FRIENDLY_EMPHASIS)
    assert_includes(QiitaMarker::Config::OPTS[:render].keys, :CJK_FRIENDLY_EMPHASIS)
  end

  def test_basic_cjk_emphasis
    assert_equal(
      "<p>これは<strong>太字</strong>です</p>\n",
      QiitaMarker.render_html("これは**太字**です", @parse_opts),
    )
  end

  def test_cjk_emphasis_with_punctuation_closing
    assert_equal(
      "<p>これは<strong>私のやりたかったこと。</strong>だからするの。</p>\n",
      QiitaMarker.render_html("これは**私のやりたかったこと。**だからするの。", @parse_opts),
    )
  end

  def test_cjk_emphasis_with_cjk_punctuation_brackets
    assert_equal(
      "<p>太郎は<strong>「こんにちは」</strong>といった</p>\n",
      QiitaMarker.render_html("太郎は**「こんにちは」**といった", @parse_opts),
    )
  end

  def test_cjk_emphasis_adjacent_to_ascii
    assert_equal(
      "<p>Go<strong>「初心者」</strong>を対象とした記事です。</p>\n",
      QiitaMarker.render_html("Go**「初心者」**を対象とした記事です。", @parse_opts),
    )
  end

  def test_cjk_emphasis_multiple
    assert_equal(
      "<p><strong>C#</strong>や<strong>F#</strong>は<strong>「.NET」</strong>というプラットフォーム上で動作します。</p>\n",
      QiitaMarker.render_html("**C#**や**F#**は**「.NET」**というプラットフォーム上で動作します。", @parse_opts),
    )
  end

  def test_cjk_emphasis_fullwidth_parens
    assert_equal(
      "<p>.NET<strong>（.NET Frameworkは不可）</strong>では、</p>\n",
      QiitaMarker.render_html(".NET**（.NET Frameworkは不可）**では、", @parse_opts),
    )
  end

  def test_cjk_emphasis_with_links
    assert_equal(
      "<p><strong><a href=\"./product-foo\">製品ほげ</a></strong>と<strong><a href=\"./product-bar\">製品ふが</a></strong>をお試しください</p>\n",
      QiitaMarker.render_html("**[製品ほげ](./product-foo)**と**[製品ふが](./product-bar)**をお試しください", @parse_opts),
    )
  end

  def test_cjk_emphasis_with_yen_sign
    assert_equal(
      "<p>税込<strong>¥10,000</strong>で入手できます。</p>\n",
      QiitaMarker.render_html("税込**¥10,000**で入手できます。", @parse_opts),
    )
  end

  def test_cjk_emphasis_with_circled_number
    assert_equal(
      "<p>正解は<strong>④</strong>です。</p>\n",
      QiitaMarker.render_html("正解は**④**です。", @parse_opts),
    )
  end

  def test_cjk_emphasis_fullwidth_comma
    assert_equal(
      "<p><strong>真，</strong>她</p>\n",
      QiitaMarker.render_html("**真，**她", @parse_opts),
    )
  end

  def test_cjk_emphasis_cjk_only
    assert_equal(
      "<p><strong>真</strong>她</p>\n",
      QiitaMarker.render_html("**真**她", @parse_opts),
    )
  end

  def test_cjk_emphasis_supplementary_plane
    assert_equal(
      "<p>𰻞𰻞<strong>（ビャンビャン）</strong>麺</p>\n",
      QiitaMarker.render_html("𰻞𰻞**（ビャンビャン）**麺", @parse_opts),
    )
  end

  def test_cjk_emphasis_ascii_parens
    assert_equal(
      "<p>𰻞𰻞<strong>(ビャンビャン)</strong>麺</p>\n",
      QiitaMarker.render_html("𰻞𰻞**(ビャンビャン)**麺", @parse_opts),
    )
  end

  def test_cjk_emphasis_variation_selector
    assert_equal(
      "<p>大塚︀<strong>(U+585A U+FE00)</strong> 大塚<strong>(U+FA10)</strong></p>\n",
      QiitaMarker.render_html("大塚︀**(U+585A U+FE00)** 大塚**(U+FA10)**", @parse_opts),
    )
  end

  def test_render_doc_with_option
    assert_equal(
      "<p><strong>これはテスト。</strong>はい</p>\n",
      QiitaMarker.render_doc("**これはテスト。**はい", @parse_opts).to_html,
    )
  end

  def test_strikethrough_cjk_basic
    assert_equal(
      "<p>これは<del>取消</del>です</p>\n",
      QiitaMarker.render_html("これは~~取消~~です", @strikethrough_parse_opts, [:strikethrough]),
    )
  end

  def test_strikethrough_cjk_with_punctuation
    assert_equal(
      "<p>これは<del>私のやりたかったこと。</del>だからするの。</p>\n",
      QiitaMarker.render_html("これは~~私のやりたかったこと。~~だからするの。", @strikethrough_parse_opts, [:strikethrough]),
    )
  end

  def test_strikethrough_cjk_with_brackets
    assert_equal(
      "<p>太郎は<del>「こんにちは」</del>といった</p>\n",
      QiitaMarker.render_html("太郎は~~「こんにちは」~~といった", @strikethrough_parse_opts, [:strikethrough]),
    )
  end

  def test_strikethrough_cjk_multiple
    assert_equal(
      "<p><del>C#</del>や<del>F#</del>は<del>「.NET」</del>というプラットフォーム上で動作します。</p>\n",
      QiitaMarker.render_html("~~C#~~や~~F#~~は~~「.NET」~~というプラットフォーム上で動作します。", @strikethrough_parse_opts, [:strikethrough]),
    )
  end

  def test_without_option_cjk_punctuation_not_emphasized
    assert_equal(
      "<p>これは**私のやりたかったこと。**だからするの。</p>\n",
      QiitaMarker.render_html("これは**私のやりたかったこと。**だからするの。", :DEFAULT),
    )
  end

  def test_without_option_standard_emphasis_works
    assert_equal(
      "<p>this is <strong>bold</strong> text</p>\n",
      QiitaMarker.render_html("this is **bold** text", :DEFAULT),
    )
  end

  def test_english_not_affected
    assert_equal(
      QiitaMarker.render_html("Hello **world** there", :DEFAULT),
      QiitaMarker.render_html("Hello **world** there", @parse_opts),
    )
  end
end
