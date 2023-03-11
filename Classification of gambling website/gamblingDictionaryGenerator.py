"""
This code visits gambling websites specified in the seperate text file and scrapes text from html to store in
a list like structure in a seperate file. The new file is then used by the webSiteClassifier.py to train the One Class
SVM ML model
"""
import sys
from bs4 import BeautifulSoup
import requests
from nltk.tokenize import RegexpTokenizer
import nltk
import pickle

print("Generating dictionary for gambling related websites")
websiteData = []

#Not utilized since the the tokenization and pre processing is taken care of by tfID vectorizer function in webSiteClassifier file
def preProcessing(text):
    #Tokenize the words
    tokens = RegexpTokenizer('\w+').tokenize(text)

    #Lower case words stored in this list
    words = []
    # Loop through list tokens and make every word lower case
    for word in tokens:
        words.append(word.lower())

    #Get english stop words
    stopWords = nltk.corpus.stopwords.words('english')

    # Remove stop characters, stop words and numbers
    refinedWords = []
    for word in words:
        #Not a character
        if len(word) > 1:
            #Not a stop word and not a number
            if word not in stopWords and word.isalpha():
                refinedWords.append(word)

    #Append top words into the list if words are not already present in the l   print
    uniqueTokenizedWords = list(dict.fromkeys(refinedWords))

    return uniqueTokenizedWords

#Read links from text file and store in a list
if (len(sys.argv) > 1):
#If the text file name is given in terminal args use the specified name else use hard coded text file
    gamblingWebSites = open(str(sys.argv[1]), 'r')
else:
    gamblingWebSites = open('GamblingWebsites.txt', 'r')

links = gamblingWebSites.readlines()

#Loop over the links in the text file
for url in links:
    # Check if the text is a website to avoid errors when getting html
    if "https://" in url:
        # Remove \n from the links
        url = url.replace("\n", "")

        # Get webpage html
        htmlPage = requests.get(url)

        # Load webpage to soup object to extract information using html tags
        soup = BeautifulSoup(htmlPage.text, "html.parser")

        # Extract text from soup object
        text = soup.get_text()
        websiteData.append(text)

##Store information in text file using pickle to maintain list structure
with open("websiteData", 'wb') as txtFile:
    pickle.dump(websiteData, txtFile)

print("Data gathered and stored in the file : websiteData")
















