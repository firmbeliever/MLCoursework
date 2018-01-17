import csv
import json
import time
import tweepy


# You must use Python 2.7.x
# Rate limit chart for Twitter REST API - https://developer.twitter.com/en/docs/basics/rate-limiting.html

def loadKeys(key_file):
    # : put your keys and tokens in the keys.json file,
    #       then implement this method for loading access keys and token from keys.json
    # rtype: str <api_key>, str <api_secret>, str <token>, str <token_secret>

    # Load keys here and replace the empty strings in the return statement with those keys
    keys = json.load(open('keys.json'))
    apikey = keys['api_key']
    apisec = keys['api_secret']
    token = keys['token']
    tokensec = keys['token_secret']

    return apikey, apisec, token, tokensec

# Q1.b.(i) - 5 points
def getPrimaryFriends(api, root_user, no_of_friends):
    # : implement the method for fetching 'no_of_friends' primary friends of 'root_user'
    # rtype: list containing entries in the form of a tuple (root_user, friend)
    primary_friends = []
    success = False
    trycount = 1
    # Add code here to populate primary_friends
    while (success == False) and (trycount < 4):
        try:
            for frId in tweepy.Cursor(api.friends_ids, screen_name = root_user).items(no_of_friends):
                frUser = api.get_user(user_id = frId).screen_name
                primary_friends.append((root_user, str(frUser)))
            success = True
        except:
            #print 'sleeping in 1 at ' + time.asctime(time.localtime())
            time.sleep(15 * 60) #sleep if we got exception, but only do this a max of 3 times in case of larger issue
            trycount += 1 
            #print 'done sleeping in 1 at ' + time.asctime(time.localtime())

    return primary_friends

# Q1.b.(ii) - 7 points
def getNextLevelFriends(api, friends_list, no_of_friends):
    # : implement the method for fetching 'no_of_friends' friends for each entry in friends_list
    # rtype: list containing entries in the form of a tuple (friends_list[i], friend)
    next_level_friends = []

    for friend in friends_list:
        frList = getPrimaryFriends(api, friend, no_of_friends)
        next_level_friends += frList
    # Add code here to populate next_level_friends
    return next_level_friends

# Q1.b.(iii) - 7 points
def getNextLevelFollowers(api, followers_list, no_of_followers):
    # : implement the method for fetching 'no_of_followers' followers for each entry in followers_list
    # rtype: list containing entries in the form of a tuple (follower, followers_list[i])    
    next_level_followers = []

    # Add code here to populate next_level_followers

    for rootFr in followers_list:
        success = False
        trycount = 1
        while (success == False) and (trycount < 4):
            try:
                for follID in tweepy.Cursor(api.followers_ids, screen_name = rootFr).items(no_of_followers):
                    follower = api.get_user(user_id = follID).screen_name
                    next_level_followers.append((str(follower), rootFr))
                success = True
            except:
                #print 'sleeping in 3 at ' + time.asctime(time.localtime())
                time.sleep(15 * 60)
                trycount += 1
                #print 'done sleeping in 3 at ' + time.asctime(time.localtime())

    return next_level_followers

# Q1.b.(i),(ii),(iii) - 4 points
def GatherAllEdges(api, root_user, no_of_neighbours):
    # :  implement this method for calling the methods getPrimaryFriends, getNextLevelFriends
    #        and getNextLevelFollowers. Use no_of_neighbours to specify the no_of_friends/no_of_followers parameter.
    #        NOT using the no_of_neighbours parameter may cause issues with grading.
    #        Accumulate the return values from all these methods.
    # rtype: list containing entries in the form of a tuple (Source, Target). Refer to the "Note(s)" in the 
    #        Question doc to know what Source node and Target node of an edge is in the case of Followers and Friends. 
    all_edges = [] 
    #Add code here to populate all_edges
    step1 = getPrimaryFriends(api, root_user, no_of_neighbours)
    
    #for the next 2 calls, make just a list of primary friends, which is the second value in each tuple
    primFriends = [fr for rt, fr in step1]
    
    step2 = getNextLevelFriends(api, primFriends, no_of_neighbours)    
    step3 = getNextLevelFollowers(api, primFriends, no_of_neighbours)
    
    all_edges = step1 + step2 + step3
    return all_edges


# Q1.b.(i),(ii),(iii) - 5 Marks
def writeToFile(data, output_file):
    # write data to output_file
    # rtype: None
    with open(output_file, 'wb') as outfile:
        wrtr = csv.writer(outfile)
        for edge in data:
            wrtr.writerow(edge)
    return




"""
You may modify testSubmission()
for your testing purposes
but it will not be graded.

It is highly recommended that
you DO NOT put any code outside testSubmission().

Note that your code should work as expected
for any value of ROOT_USER.
"""

def testSubmission():
    KEY_FILE = 'keys.json'
    OUTPUT_FILE_GRAPH = 'graph.csv'
    NO_OF_NEIGHBOURS = 20
    ROOT_USER = 'PoloChau'

    api_key, api_secret, token, token_secret = loadKeys(KEY_FILE)

    auth = tweepy.OAuthHandler(api_key, api_secret)
    auth.set_access_token(token, token_secret)
    api = tweepy.API(auth)

    edges = GatherAllEdges(api, ROOT_USER, NO_OF_NEIGHBOURS)

    writeToFile(edges, OUTPUT_FILE_GRAPH)
    

if __name__ == '__main__':
    testSubmission()

