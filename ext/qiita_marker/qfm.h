#ifndef QFM_H
#define QFM_H

#ifdef __cplusplus
extern "C" {
#endif

/** Use <pre><code data-metadata="x"> tags for code blocks instead of <pre><code
 * class="language-x">. **/
#define CMARK_OPT_CODE_DATA_METADATA (1 << 25)

/* Prevent parsing Qiita-style Mentions as emphasis. */
#define CMARK_OPT_MENTION_NO_EMPHASIS (1 << 26)

/* Render autolinks with class name  */
#define CMARK_OPT_AUTOLINK_CLASS_NAME (1 << 27)

/* Use CJK-friendly emphasis rules.
 * See https://github.com/tats-u/markdown-cjk-friendly */
#define CMARK_OPT_CJK_FRIENDLY_EMPHASIS (1 << 28)

#ifdef __cplusplus
}
#endif

#endif
