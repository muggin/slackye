import tweepy as tp

ckey = "CONSUMER KEY HERE"
csecret = "CONSUMER SECRET HERE"
atoken = "ACCESS TOKEN HERE"
asecret = "ACCESS SECRET HERE"

auth = tp.OAuthHandler(ckey, csecret)
auth.set_access_token(atoken, asecret)

# Construct the API instance
api = tp.API(auth, wait_on_rate_limit_notify=True, wait_on_rate_limit=True)

# Get Kanye timeline
count = 1
tweets = []
for tweet in tp.Cursor(api.user_timeline, id="kanyewest").items(900):
    tweets.append((tweet.text, tweet.retweet_count, tweet.favorite_count))

with open('tweet_dump.csv', 'w') as fd:
    fd.write('text,rt_count, fav_count\n')
    for text, rt, fav in tweets:
        fd.write(u'{},{},{}\n'.format(text, rt, fav).encode('utf-8'))
