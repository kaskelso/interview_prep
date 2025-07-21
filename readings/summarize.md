# Paper #1: Credit Card Fraud Detection: A Realistic Modeling
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

Cost-based methods assign a cost to missing fraudlent charges proportional to the transaction amount. They generate a lot of false positives

Concept drift:
1) valid transactions change over time
2) fraud transactions change over time

Concept drift adaptation categories: active and passive 

Active: monitors incoming data to look at changes in distributions or clustering, after enough change their is a trigger to update the classifier

Passive: classifier is updated after a certain amount of new data becomes available 

The next big challenge is Alert–Feedback Interaction and Sample Selection. This means that because investigators can only check a small number of high risk charges meaning biased sampling accumulates in both classes. This can be addressed by semisupervised weighting of samples that resembel examples in the test data. Although, this seems like it would result in a model that doesn't generalize well. 

They break the problem into two categories: classifying based on alerts Ft and one classifying on delayed supervised samples Dt, and then aggregating the posterior of those for PKt (+|x i ) to determine alerts. 

Aggregation classifier posterior

PAt (+|x) = αPFt (+|x) + (1 − α)PDt (+|x)

PFt (+|x) is the probability of the feedback model and PDt (+|x) is the probability of the delayed sample model. α is just an assigned weight balancing the contribution of either model. 

Next they use two methods; a windowed classifier and an ensemble method. I'm guessing the windowed is looking a chunks of examples over time windows where the ensemble takes everything? Either way they both look like tree-based methods. 

Testing these datasets, AW worked well for maximizing recent high risk cards, whereas R trained on all samples daily was a better classifier generally. 


Concept drift: Super cool! The show a static classifier, windowed classifier, and the aggregate method. The windowed one starts doing worse over time because it loses what is lost previously and drifts off target. 

They also investigated SSB using reweighting, got a little confused here but it looks like the punchline is the classifier not corrected for SSB works just as well. 

Conclusions: training models with higher weight toward feedbacks is important for precision. Best to train on feedbacks and delayed datasets then aggregate. 


# Paper #2 Learning from Imbalanced Data
He et al. 2009

This paper covers conceptual challenges in classifications of unbalanced datasets

heterogenous vs homogeneous concepts for classification:

homogeneous means that there are discrete classes without "subconcepts" (i.e., clustering within main cluster) and little noise. Hetergenous means concepts have subconcepts that can create further layers of class imbalances and challenge the learning process. In hetergenous situations decision trees can make "small disjuncts" which are rules covering a small set of data. From either noise or imbalanced subconcepts it can hinder the ability to learn and classify. 

Challenges with oversampling minority class and undersampling majority class:

oversampling creates ties among examples and can lead to overfitting. undersampling can remove important examples in the majority leading to reduced learning on the majority class. 





