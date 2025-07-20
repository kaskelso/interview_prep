Paper #1: Credit Card Fraud Detection: A Realistic Modeling
and a Novel Learning Strategy Pozzolo et al. 2018

Notes: 

Detecting credit card fraud challenges:
1) concept drift (fraud changes over time)
2) class imbalance (far more normal transactions then fraduelent)
3) Verification latencey (delay in verifying fraud because professionals contact suspicious purchases) 

Pipeline for labeled datasets: automatic tools flag suspicious purchases with alerts -> investigator contacts customer confirms or denies purchase -> transaction labled

Large challenge in literature is many systems assume no verification latency. In the real world most transactions aren't checked and large delay between alert and customer verification. 

Literature also uses ROC curves for ranking, but precision (reducing false postive rate) is emphasized for companies. Makes sense since because with the large class imbalance you'd run into the false positive paradox (https://en.wikipedia.org/wiki/Base_rate_fallacy)

ROC example from (https://www.evidentlyai.com/classification-metrics/explain-roc-curve): 
![alt text](https://github.com/kaskelso/interview_prep/blob/main/readings/662c42679571ef35419c9935_647607123e84a06a426ce627_classification_metrics_014-min.png)

Layers of real world fraud detection system (FDS)

1) terminal: intial layer with security, correct pin, suffifcient funds, etc.
2) transaction blocking rules: essentially a bunch of if else statements to block obiviously dodgey things. Example in paper is if website and unsecured then deny transaction. These rules have to be very precise and then after passing the purchase is compared to the customers previous purchase history
3) Scoring rules: again a bunch of if else statements involving scoring the transaction based on previous behavior. Example in paper is a transaction that took place  in another continent 1 hour after previous purchase
4) Data driven model: data driven classifer to analyze many feature vectors to determine fraud (paper focuses on this, and probably what I will as well in this position!)
5) investigators, final layer where humans check and generate the labeled datasets

Feature vectors of transactions: merchant ID, cardholder ID, purchase amount, date, and time. Other features are added the aggregation functions like: average expenditure of the customer every week/month, the average number of transactions per day or in the same shop, the average transaction amount, and the location of the last purchase

The layers that can be updated rapidly is 1-3. 4 requires new labeled data to be retrained. 

Ok so they model investigator checking like this

At = {x i ∈ Tt s.t. r (x i ) ≤ k}

Where x i ∈ Tt is a specific tranasaction at Tt, r (x i ) is the rank of the transaction according to PKt (+|x i ) (probability it is fraud given the transaction), k is maximum number of transactions that can be checked daily. Basically, transactions become alerts at time t if risk score is 1 to number can be checked daily. 

Then they model feedback (labeled data) as:

Ft = {(x i , y i ) s.t. x i is from cards(At )}

Bascially, number of feedbacks depends of set of k controlled cards at At. 

Next they assume a constant latency

Dt −δ = {(x i , y i ), x i ∈ Tt −δ}.

Is this where all non-disputed transactions are labeled as geninune after some time period. So if δ is 2 at day 10 we get labels from day 8. 

Next there is alert precision

Pk (t) = |TPk (t)| / k 

This is the proportion of fraud in the alerts. But it is more accurate to reframe as cards, since multiple alerts can be from the same card:

CPk (t) = |C+t | / k

|C+t | is the set of correctly identified cards at time t. Then they normalize this amount to account for days when there is less than k fraudulent cards.

Two methods for dealing with cost imbalance:
1) resampling
2) cost-based methods

Resampling includes SMOTETomek (down sample majority class while resampling minority by generating synthetic data from knn)














