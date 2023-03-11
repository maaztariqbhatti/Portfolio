"""
Note: This classifier works only for those websites that do not require javaScript to be enabled
        Please provide link in quotation marks in the terminal
This code classifies a given website in the argument into  gambling or non gambling website
It uses OneClassSVM algorithm to classify text extracted from html page of the given website
For training purpose the data scraped from known gambling websites is used
For feature extraction TFID vectorizer function form sklearn package is used
"""
import sys
from bs4 import BeautifulSoup
import requests
import pickle
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.svm import OneClassSVM

#Get link from the arg
if (len(sys.argv) > 1):
    website = str(sys.argv[1])

#If no link given test with the hardcoded link link given below
else:
    website = "https://nj.betrivers.com/?page=landing&btag=a_333b_3813c_1EVMELNUJNDOJFJT&siteid=333#home"

# Check if the text is a website to avoid errors when getting html
if "https://" in website:
    # Get webpage html
    req = requests.Session()
    htmlPage = req.get(website)

    # Load webpage to soup object to extract information using html tags
    soup = BeautifulSoup(htmlPage.text, "html.parser")

    # Extract text from soup object
    test = soup.get_text()

    #Get stored data from different gambling websites
    with open("websiteData", "rb") as fp:  # Unpickling
        train = pickle.load(fp)

    #Implementation of One Class SVM
    #Vectorizer tokenizes the words after pre processing the text
    """
    TfID vectorizer measures the originality of the word by comparing the number of times a word appears in a 
    website with the number of websites the word appears in
    It uses the formulae : Term Frequency x Inverse Document Frequency
    stop_words= 'english' :parameter ensures that useless words that repeat frequently and are not hlepful in classificaiton are removed
    """
    vectorizer = TfidfVectorizer(stop_words= 'english')

    #Tranform to  vectors
    train_vectors = vectorizer.fit_transform(train)
    test_vectors = vectorizer.transform([test])

    #Use One class SVM to classify
    """
    One class SVM is a unsupervised machine learning algorithm that uses a hypersphere to encompass all of the known
    instances. It classifies new instances as 1 if they fall within the hyper sphere and -1 if they fall outside. 
    It is a outlier detection method and we consider non gambling websites as outliers in this scenario
    """
    model = OneClassSVM(gamma='auto')
    model.fit(train_vectors)

    #If prediction is 1 the website is similar to the training data meaning it is a gambling website
    #Otherwise it is a non gambling website
    test_predictions = model.predict(test_vectors)

#Output
if test_predictions == 1:
    print("Gambling website")
else:
    print("Non-gambling website")














