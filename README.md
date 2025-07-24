# interview_prep
This repo is in preparation for an interview I have upcoming at a large payment and transaction company. The position will focus on using machine learning to identify fraud. As a part of the team (25 people distributed across the globe) I would be an individual contributor focused on detecting fraud. The position is 60-70% technical work and 30-40% meeting with stakeholders to understand current business needs. They are looking for someone with a more "sciency" background and can do things like write white-papers. Sounds fun! 

In this repo I am collecting relevant literature on the current space of fraud detection and summarizing those papers. 

I also worked on building an xgboost (preferred in the position) model with a pracitce dataset (https://www.kaggle.com/competitions/ieee-fraud-detection/data) in python. The dataset was huge! ~470 features and ~500,000 examples and only ~3% were fraud. I did feature selection by removing features with more than 50% missing data in the fraud and non-fraud categories and dropped additional features based on collinearity. I also explored over-undersampling with SMOTEtomek. Both approaches worked well but using xgboost with high weighting towards the minor category did ever so slightly better. Both models were able to get good precision 0.91-0.93 on the minor category but both had lower recall 0.66-0.71.

