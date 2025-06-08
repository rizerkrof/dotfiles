(setq elfeed-db-directory "~/.config/emacs/elfeed")

(use-package
 elfeed
 :config
 (setq
  elfeed-feeds
  '(("https://theweekinchess.com/twic-rss-feed" chess)

    ("https://news.un.org/feed/subscribe/en/news/topic/climate-change/feed/rss.xml"
     news
     climate
     world)
    ("https://www.france24.com/en/rss" news world)
    ("https://rss.nytimes.com/services/xml/rss/nyt/World.xml"
     news
     world)
    ("https://globalnews.ca/feed/" news world)
    ("https://globalnews.ca/environment/feed/" news climate world)
    ("https://api.blast-info.fr/rss.xml" news climate world)
    ("https://www.france24.com/en/france/rss" news france)
    ("https://www.mediapart.fr/articles/feed" news france)
    ("https://www.ouest-france.fr/rss/france" news france)

    ("https://feeds.simplecast.com/54nAGcIl" podcast)
    ("https://podcastfeeds.nbcnews.com/HL4TzgYC" podcast)

    ("https://allthatsinteresting.com/feed" random)
    ("https://feeds.feedburner.com/TodayIFoundOut" random)
    ("https://nowiknow.com/feed/" random)
    ("https://www.justfactsdaily.com/feed" random)

    ("https://www.reddit.com/r/linux.rss" linux)))

 (custom-set-faces
  '(elfeed-search-unread-title-face
    ((t (:inherit success :weight normal))))
  '(elfeed-search-title-face
    ((t (:inherit font-lock-comment-face :weight normal))))
  '(elfeed-search-date-face ((t (:inherit default :weight normal))))
  '(elfeed-search-feed-face
    ((t (:inherit font-lock-keyword-face :weight bold))))
  '(elfeed-search-tag-face
    ((t (:inherit font-lock-type-face :weight bold)))))

 (setq elfeed-search-filter "@2-weeks-ago +unread"))
