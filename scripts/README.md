Fetches recent tweets from the given accounts. It finds the arabic words, excludes common words, location names, people names. It produces:
* a latex output of the words for studying
* or the words and stats about them (mainly for debugging)

Run with:
```
perl twitter_top_words.pl
--consumer-key string \
--consumer-secret string \
--access-token string \
--access-token-secret string \
--accounts comma_separated_list \
--latex > test.tex && xelatex test.tex && xelatex test.tex && evince test.pdf
```

`twitter-perl` is a cleaner rewrite of `twitter_top_words.pl`.
* get_tweets gets tweets
* process_tweets reads the arabic text, cleans any "stopwords", and calculates some statistics about words (for all tweets and per tweet)
* TODO
