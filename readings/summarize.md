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
2) transaction blocking rules: essentially a bunch of if else statements to block obiviously dodgey things. Example in paper is if website and unsecured then deny transaction
3) 
