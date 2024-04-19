# write objective function with entropy regularization
# function should be maximized
objective_function <- function(posteriors, dist, lambda = 0.1, epsilon = 1e-100) {
  ind = length(posteriors)
  posteriors[posteriors==0] = epsilon
  temp = matrix(NA, nrow = ind, ncol = ind)
  for (col in 1:ind) {
    for (row in 1:ind) {
      temp[row, col] = dist(row, col)
    }
  }
  return(-1*(temp * posteriors - lambda * sum(posteriors * log(posteriors))))
}