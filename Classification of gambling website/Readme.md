READ ME

This project implements an un-supervised Machine Learning Algorithm, "One Class SVM". 
The project is split into 2 parts. 

In the first part the a list of known gambling websites are hunted and stored in a text file
A python script is written to visit access this text file and visit each website individually and scrape text data. 
The scrapped data is stored in a pickle file to be utilized in the second part

In the second part, the stored data is accessed and utilized for training of our classifier. 
Inorder to vectorize find similarities between the stored website text TFID Vectorizer is used. It measures how 
important a term is within a document relative to a collection of documents. One class SVM is then implemented which 
is  a unsupervised machine learning algorithm that uses a hypersphere to encompass all of the known instances. It classifies 
new instances as 1 if they fall within the hyper sphere and -1 if they fall outside. It is a outlier detection method and we 
consider non gambling websites as outliers in this scenario.

Parameters for files:
webSiteClassifier.py 
INPUT: URL of a website 
OUTPUT : Gambling/ Non Gambling classification
