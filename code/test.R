# Define parameters
# K <- 3  # Number of categories
# 
# # Transition matrix (example probabilities)
# transition_matrix <- matrix(c(0.6, 0.2, 0.2,
#                               0.1, 0.7, 0.2,
#                               0.3, 0.3, 0.4), nrow = K, byrow = TRUE)
# 
# # Number of iterations
# n_iter <- 1000
# 
# # Initialize variable
# x <- numeric(n_iter)
# 
# # Initial value
# x[1] <- sample(1:K, 1, prob = rep(1/K, K))  # Initial value for X
# 
# # Gibbs sampling iterations
# for (i in 2:n_iter) {
#   # Sample from conditional distribution of X given the previous value of X
#   x[i] <- sample(1:K, 1, prob = transition_matrix[x[i-1], ])
# }
# 
# # Plot the samples
# plot(x, type = "l", xlab = "Iteration", ylab = "X", main = "Gibbs Sampling for Categorical Distribution")
# points(x, col = "blue")
