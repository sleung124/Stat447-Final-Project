# Stat447-Final-Project

Repository for STAT 447 final project. For now, idea is to make an adaptation of simulated annealing by casting part of the iteration process as an optimal transport problem, and solving the system with linear optimization. Benchmark algorithm against MH. 

UPDATE:

Simply write algorithm for traversing integer space to see which posterior to sample from. Working on discrete distribution space for now.

ROUGH STEPS:

1) Initialize posterior for each index $i; i \in \{1,\cdots,n\}$: $$\bar\pi(x, i) = \pi_i(x) \propto \gamma(x) / Z$$

2) Solve for kernel to sample from: $$\pi(i) = \sum_{j\in\text{indexes}}\pi(j)K(i|j)$$
From above: we have $n$ equations with $n$ different $K(i|j)$'s.

3) Pick which index to go, holding $X$ fixed, through sampling kernel that's selected from the objective function:
  
$$f_{obj} = \text{argmax}_j \mathbb{E}[d(i,j)]$$

This is the same as:

$$f_{obj} = \sum_i \pi_i \sum_j k_{ij}d(i,j)$$

With $d(.)$ as a distance metric. Choose kernel that maximizes expected distance.

4) Sample new index $i*$ from selected kernel above

5) Repeat.


Questions:

- The $K$ matrix is the output of linear optimization. The input would be the $\pi_i$'s, and we keep the transition probabilities variable. For the matrix of transition probabilities, would each column be it's own transition probability in this case? 
