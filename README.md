# Stat447-Final-Project

Repository for STAT 447 final project. For now, idea is to make an adaptation of simulated annealing by casting part of the iteration process as an optimal transport problem, and solving the system with linear optimization. Benchmark algorithm against MH. 

UPDATE:

Simply write algorithm for traversing integer space to see which posterior to sample from. Working on discrete distribution space for now.

ROUGH STEPS:

1) Initialize posterior for each index $i; i \in \{1,\cdots,n\}$: $$\bar\pi(x, i) = \pi_i(x) \propto \gamma(x) / Z$$

2) Solve for kernel to sample from: $$\pi(i) = \sum_{j\in\text{indexes}}\pi(j)K(i|j)$$
From above: we have $n$ equations with $n$ different $K(i|j)$'s.

3) Pick which index to go, holding $X$ fixed, through the object function: $$f_{obj} = \sum_{j\in\text{indexes}}\pi(i)K(j|i)\cdot d(i, j)$$
With $d(.)$ as a distance metric. Choose kernel that maximizes expected distance (HOW TO DO??)

4) Sample new index $i*$ from selected kernel above

5) Repeat.