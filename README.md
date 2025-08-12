# interview_prep
This repo is in preparation for an interview I have upcoming at a large payment and transaction company. The position will focus on using machine learning to identify fraud. As a part of the team (25 people distributed across the globe) I would be an individual contributor focused on detecting fraud. The position is 60-70% technical work and 30-40% meeting with stakeholders to understand current business needs. They are looking for someone with a more science background that can do things like write white-papers. Sounds fun!

In this repo I am collecting relevant literature on the current space of fraud detection and summarizing those papers. I have also added SQL and Python answers from practice questions I did on DataLemur which is leetcode for data science.

I also worked on building an xgboost (preferred in the position) model with a practice dataset (https://www.kaggle.com/competitions/ieee-fraud-detection/data) in python. The dataset was tricky! ~470 features and ~500,000 examples and only ~3% were fraud. Metadata on features is poor (or non-existent) so I did feature selection by removing features with more than 50% missing data in the fraud and non-fraud categories and dropped additional features based on collinearity. In my model I adjusted the weight of the minority category using scale_pos_weight and also explored the use SMOTEtomek. Both approaches worked well but using xgboost with high weighting towards the minority category did slightly better, with a higher recall and F1 score.

UPDATE: I tried imputing with KNN imputer instead of just median when using SMOTEtomek. KNN imputer takes a long time on this dataset (so wouldn’t be practical on very large datasets) and didn't improve the model.

