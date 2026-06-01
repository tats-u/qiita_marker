# frozen_string_literal: true

require "test_helper"

class TestCjkFriendlyEmphasis < Minitest::Test
  def setup
    @parse_opts = [:DEFAULT, :CJK_FRIENDLY_EMPHASIS]
  end

  def test_japanese_closing_punctuation
    # Issue: closing ** after 。 is not recognized without CJK-friendly emphasis
    text = "**このアスタリスクは強調記号として認識されず、そのまま表示されます。**この文のせいで。"
    result = QiitaMarker.render_html(text, @parse_opts)

    assert_includes(result, "<strong>")
    assert_includes(result, "</strong>")
  end

  def test_japanese_closing_punctuation_default_fails
    # Without CJK-friendly, this should NOT produce <strong>
    text = "**このアスタリスクは強調記号として認識されず、そのまま表示されます。**この文のせいで。"
    result = QiitaMarker.render_html(text, :DEFAULT)

    refute_includes(result, "<strong>")
  end

  def test_chinese_parenthesis
    text = "**这是强调（括号）**是的"
    result = QiitaMarker.render_html(text, @parse_opts)

    assert_includes(result, "<strong>")
    assert_includes(result, "</strong>")
  end

  def test_korean_emphasis
    text = "스크립트**안녕**하세요"
    result = QiitaMarker.render_html(text, @parse_opts)

    assert_includes(result, "<strong>")
  end

  def test_opening_after_japanese_punctuation
    text = "この文のせいで。**このアスタリスクは強調記号として認識されない**"
    result = QiitaMarker.render_html(text, @parse_opts)

    assert_includes(result, "<strong>")
  end

  def test_english_not_affected
    text = "Hello **world** there"
    result_default = QiitaMarker.render_html(text, :DEFAULT)
    result_cjk = QiitaMarker.render_html(text, @parse_opts)

    assert_equal(result_default, result_cjk)
  end

  def test_single_asterisk_emphasis
    text = "これは*強調*です。"
    result = QiitaMarker.render_html(text, @parse_opts)

    assert_includes(result, "<em>")
    assert_includes(result, "</em>")
  end

  def test_render_doc_with_option
    text = "**これはテスト。**はい"
    doc = QiitaMarker.render_doc(text, @parse_opts)
    result = doc.to_html

    assert_includes(result, "<strong>")
  end
end
