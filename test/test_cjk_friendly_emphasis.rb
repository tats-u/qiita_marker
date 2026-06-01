# frozen_string_literal: true

require "test_helper"

class TestCjkFriendlyEmphasis < Minitest::Test
  def test_extension_registered
    assert_includes QiitaMarker.extensions, "cjk_friendly_emphasis"
  end

  def test_basic_cjk_emphasis
    result = QiitaMarker.render_html("これは**太字**です", :DEFAULT, [:cjk_friendly_emphasis])
    assert_equal "<p>これは<strong>太字</strong>です</p>\n", result
  end

  def test_cjk_emphasis_with_punctuation_closing
    result = QiitaMarker.render_html("これは**私のやりたかったこと。**だからするの。", :DEFAULT, [:cjk_friendly_emphasis])
    assert_equal "<p>これは<strong>私のやりたかったこと。</strong>だからするの。</p>\n", result
  end

  def test_cjk_emphasis_with_cjk_punctuation_brackets
    result = QiitaMarker.render_html("太郎は**「こんにちは」**といった", :DEFAULT, [:cjk_friendly_emphasis])
    assert_equal "<p>太郎は<strong>「こんにちは」</strong>といった</p>\n", result
  end

  def test_cjk_emphasis_adjacent_to_ascii
    result = QiitaMarker.render_html("Go**「初心者」**を対象とした記事です。", :DEFAULT, [:cjk_friendly_emphasis])
    assert_equal "<p>Go<strong>「初心者」</strong>を対象とした記事です。</p>\n", result
  end

  def test_cjk_emphasis_multiple
    result = QiitaMarker.render_html("**C#**や**F#**は**「.NET」**というプラットフォーム上で動作します。", :DEFAULT, [:cjk_friendly_emphasis])
    assert_equal "<p><strong>C#</strong>や<strong>F#</strong>は<strong>「.NET」</strong>というプラットフォーム上で動作します。</p>\n", result
  end

  def test_cjk_emphasis_fullwidth_parens
    result = QiitaMarker.render_html(".NET**（.NET Frameworkは不可）**では、", :DEFAULT, [:cjk_friendly_emphasis])
    assert_equal "<p>.NET<strong>（.NET Frameworkは不可）</strong>では、</p>\n", result
  end

  def test_cjk_emphasis_with_links
    result = QiitaMarker.render_html("**[製品ほげ](./product-foo)**と**[製品ふが](./product-bar)**をお試しください", :DEFAULT, [:cjk_friendly_emphasis])
    assert_equal "<p><strong><a href=\"./product-foo\">製品ほげ</a></strong>と<strong><a href=\"./product-bar\">製品ふが</a></strong>をお試しください</p>\n", result
  end

  def test_cjk_emphasis_with_yen_sign
    result = QiitaMarker.render_html("税込**¥10,000**で入手できます。", :DEFAULT, [:cjk_friendly_emphasis])
    assert_equal "<p>税込<strong>¥10,000</strong>で入手できます。</p>\n", result
  end

  def test_cjk_emphasis_with_circled_number
    result = QiitaMarker.render_html("正解は**④**です。", :DEFAULT, [:cjk_friendly_emphasis])
    assert_equal "<p>正解は<strong>④</strong>です。</p>\n", result
  end

  def test_cjk_emphasis_fullwidth_comma
    result = QiitaMarker.render_html("**真，**她", :DEFAULT, [:cjk_friendly_emphasis])
    assert_equal "<p><strong>真，</strong>她</p>\n", result
  end

  def test_cjk_emphasis_cjk_only
    result = QiitaMarker.render_html("**真**她", :DEFAULT, [:cjk_friendly_emphasis])
    assert_equal "<p><strong>真</strong>她</p>\n", result
  end

  def test_cjk_emphasis_supplementary_plane
    result = QiitaMarker.render_html("𰻞𰻞**（ビャンビャン）**麺", :DEFAULT, [:cjk_friendly_emphasis])
    assert_equal "<p>𰻞𰻞<strong>（ビャンビャン）</strong>麺</p>\n", result
  end

  def test_cjk_emphasis_ascii_parens
    result = QiitaMarker.render_html("𰻞𰻞**(ビャンビャン)**麺", :DEFAULT, [:cjk_friendly_emphasis])
    assert_equal "<p>𰻞𰻞<strong>(ビャンビャン)</strong>麺</p>\n", result
  end

  def test_cjk_emphasis_variation_selector
    # U+FE00 variation selector after 塚
    result = QiitaMarker.render_html("大塚︀**(U+585A U+FE00)** 大塚**(U+FA10)**", :DEFAULT, [:cjk_friendly_emphasis])
    assert_equal "<p>大塚︀<strong>(U+585A U+FE00)</strong> 大塚<strong>(U+FA10)</strong></p>\n", result
  end

  # Strikethrough tests with CJK-friendly emphasis
  def test_strikethrough_cjk_basic
    result = QiitaMarker.render_html("これは~~取消~~です", :DEFAULT, [:strikethrough, :cjk_friendly_emphasis])
    assert_equal "<p>これは<del>取消</del>です</p>\n", result
  end

  def test_strikethrough_cjk_with_punctuation
    result = QiitaMarker.render_html("これは~~私のやりたかったこと。~~だからするの。", :DEFAULT, [:strikethrough, :cjk_friendly_emphasis])
    assert_equal "<p>これは<del>私のやりたかったこと。</del>だからするの。</p>\n", result
  end

  def test_strikethrough_cjk_with_brackets
    result = QiitaMarker.render_html("太郎は~~「こんにちは」~~といった", :DEFAULT, [:strikethrough, :cjk_friendly_emphasis])
    assert_equal "<p>太郎は<del>「こんにちは」</del>といった</p>\n", result
  end

  def test_strikethrough_cjk_multiple
    result = QiitaMarker.render_html("~~C#~~や~~F#~~は~~「.NET」~~というプラットフォーム上で動作します。", :DEFAULT, [:strikethrough, :cjk_friendly_emphasis])
    assert_equal "<p><del>C#</del>や<del>F#</del>は<del>「.NET」</del>というプラットフォーム上で動作します。</p>\n", result
  end

  # Ensure standard behavior is preserved without the extension
  def test_without_extension_cjk_punctuation_not_emphasized
    result = QiitaMarker.render_html("これは**私のやりたかったこと。**だからするの。", :DEFAULT, [])
    assert_equal "<p>これは**私のやりたかったこと。**だからするの。</p>\n", result
  end

  def test_without_extension_standard_emphasis_works
    result = QiitaMarker.render_html("this is **bold** text", :DEFAULT, [])
    assert_equal "<p>this is <strong>bold</strong> text</p>\n", result
  end
end
