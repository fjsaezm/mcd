# Introduction

Consider a set of variables $X_1,\dots,X_n$, we will define a model that will consider the joint probability density function of the variables

$$
P(X_1,\dots,X_n)
$$

There are a few forms of representing this

- Bayesian Networks, which are represented by directed graphs in which each node represents conditional probabilities, and the edges represent dependencies. (Drawing from the blackboard)

- Markov Networks. In this case, we have undirected graphs, where the edges are _factors_ (tables of probability)

Bayesian networks have the _factors_ in the nodes, while Markov networks have the factors in the edges.

Our goal will be to make inference about variables using the available information. Sometimes, making inference is understood as **marginalizing the joint distribution**.

$$
P(A) = \sum_{B,C} P(A,B,C) = \sum_{B,C}P(A) P(B|A)P(C|B,A)
$$

There are different algorithms to compute this probabilities, such as _variable elimination_ or _message-passing_.

Also, there are different ways of **reasoning**, such as

- Causal reasonament, which studies causalities
- Evidencial reasonament

With all this types of reasoning, we are assuming **two main points**:

- That we have all the information about both the structure of the network and the _factors_ or probabilities.

Having both the network structure and the probabilities of each of the factors, we can marginalize to obtain the joint probability distributions. However, we can consider a case where we do **not** know the structure of the network but we know the probabilities of the factors. This is also a _branch_ of study, which we will not go deep in. A last case is the one where we **know** the structure of the network, but we are **lacking** parts of the table which we would like to infere. This is the case that we will focus in this course.

## Example

Consider the following random variable, modeling the probability of obtaining heads or tails in a coinflip

$$
v^n =\begin{cases}
1 & \text{heads}\\
0 & \text{tails}
\end{cases}
$$

However, our coin might have different weights for each of the outcomes (biased coin). For instance, consider that $\theta = P(\text{heads}) = P(v^n = 1| \theta)$. Hence, $P(\text{tails}) = 1-\theta$. In this case, our goal would be to **determine** $\theta$.

If we tossed the coin $n$ times, and **we knew the probability** $\theta$, the coin tosses would be **independent**. However, if we **do not know** the probability $\theta$, the coin tosses **would be dependent** since the **outcome** of the experiment affects $\theta$. (Diagrams from the blackboard). In this case, the joint probability would be

$$
P(\theta,v^1,\dots,v^n) = P(\theta)\prod_{i=1}^n P(v^i|\theta)
$$

Estimations of the parameters are sometimes done using the empirical distribution function. However, there are other methods of estimating the joint pdf, such as _maximum likelihood estimation_.

## Maximum likelihood estimation

We define the **likelihood** of the data as

$$
L(\theta;D) = P(D|\theta) = \prod_{j=1}^N P(v^j|\theta)
$$

Maximum likelihood estimation determines the likelihood function and tries to find (or approximate) a maximum of it.

We can generalize our previous coin toss example. Consider that we obtained $M_h$ heads and $M_t$ tails in our coin toss problem. In this case, our likelihood function would be

$$
L(\theta; M_h,M_t) = \theta^{M_h} (1-\theta)^{M_t}
$$

The most common approach is to apply the logarithm to the likelihood function, which is a monotonous increasing function, to convert the product into sums, and then maximize the **log-likelihood**. In the previous example, our log-likelihood would be

$$
\ell = \log L(\theta; M_h,M_t) = M_h \log \theta + M_t \log (1-\theta)
$$


Consider the case of a three node bayesian network, with joint pdf:
$$
P(A,B,Y) = P(A)P(B|A)P(Y|A,B).
$$

We would like to obtain the probabilities in a table in each case. Extracting data is to observe \(N\) realizations of an experiment. We would like to use this data to determine
$\theta_A,\theta_B,\theta_{Y|A,B}$. Recall that these $\theta$s **are not distribution parameters but computed probabilities of observations**. We estimate this parameter set:
$$
\Theta = \{\theta_A,\theta_B,\theta_{Y|A,B}\}
$$
considering that we have to compute $\theta_a$ for all $a \in Values(A)$, $theta_b$ for all $b \in Values(B)$ and $\theta_{y|a,b}$ for all $a\in Values(A), b \in Values(b)$ and $y \in Values(Y)$

Let us compute the likelihood of this $\Theta$:
\begin{align*}
L(\Theta,D) & = P(D|\Theta) \\
& = \prod_{j=1}^N P(a[j],b[j],y[j]|\Theta) \\
& = \prod_{j=1}^N P(a[j]|\Theta) P(b[j]|\Theta)P(y[j]|a[j],b[j],\Theta)\\
& = \prod_{j=1}^N P(a[j]|\Theta_A) P(b[j]| \Theta_B)P(y[j] | a[j],b[j],\Theta_{Y|A,B})\\
& = \prod_{j=1}^N L(\theta_A,D) L(\theta_B,D) L(\theta_{Y|A,B},D)
\end{align*}

So we have expressed the likelihood of the parameters $\Theta$ as the product of the likelihood of the individual parameters $\theta_i$. We can extend this to a more teneral case.

**Proposition.-** Let $X_1, \dots, X_K$ be random variables with a bayesian network dependence. Let $D$ be a sample. Let $\tilde U = \text{Par}_g(X_i)$. Then,
\begin{align*}
L(\Theta,D) & = \prod_{j=1}^N P(\tilde x[j]|\Theta)\\
& = \prod_{j=1}^N \prod_{i=1}^{K} P(x[j]| \tilde u_i[j],\Theta_i)\\
& = \prod_{i=1}^{K} L(\Theta_i| D)
\end{align*}

**Proposition.-**
The MLE of the general case of a bayesian network is given by:
$$
\Theta_{x|\tilde u} = \frac{M[X = x, \tilde U = \tilde u]}{M[\tilde U = \tilde u]}
$$
where $M$ is the counting function.