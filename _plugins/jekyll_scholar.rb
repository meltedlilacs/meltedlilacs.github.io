require 'jekyll/scholar'
require 'uri'

# monkeypatch links to actually work goddamnit
# https://github.com/mfenner/mfenner.github.io/blob/source/_plugins/jekyll_scholar.rb
# https://github.com/inukshuk/jekyll-scholar/blob/main/lib/jekyll/scholar/plugins/markdown_links.rb
# https://github.com/inukshuk/jekyll-scholar/issues/30

URL_PATTERN = Regexp.compile([
  '\\\\href\\\\{([^\\\\}]+)\\\\}\\\\{([^\\\\}]+)\\\\}',
  URI.regexp(['http', 'https', 'ftp'])
].join('|'))

module Jekyll
  class Scholar
    class MarkdownCustom < BibTeX::Filter
      def apply(value)
        value.to_s.gsub(URL_PATTERN) {
          if $1
            # "[#{$2}](#{$1})"
            "<a href=\"#{$1}\" target=\"_blank\">#{$2}</a>"
          else
            # "[#{$&}](#{$&})"
            "<a href=\"#{$&}\" target=\"_blank\">#{$&}</a>"
          end
        }
      end
    end
  end
end