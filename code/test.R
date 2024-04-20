# Tests to ensure that the algorithm works as planned
# all test functions should return boolean values

# Global balance check. 
# Due to underflow, we check for values to be within a tiny error bound
check_global_balance <- function(posteriors, transition.matrix, epsilon = 1e-10) {
  return(sum(posteriors - crossprod(posteriors, transition.matrix) < epsilon))
}

# Check that the cross product of the posteriors and the transition matrix 
# have probabilities that sum to one
check_valid_crossprod <- function(posteriors, transition.matrix, epsilon = 1e-10) {
  return(sum(crossprod(posteriors, transition.matrix)) - 1 < epsilon)
}

# Check that the solution found is better than the baseline transition prob. 
# generated from pi-stacking
check_baseline <- function(posteriors, transition.matrix, dist) {
  ind = length(posteriors)
  baseline.matrix = matrix(rep(posteriors, ind), nrow=ind, byrow = TRUE)
  
  dist.mat = matrix(NA, nrow = ind, ncol = ind)
  for (col in 1:ind) {
    for (row in 1:ind) {
      dist.mat[row, col] = dist(row, col)
    }
  }
  
  baseline.score = sum(crossprod(posteriors, dist.mat * baseline.matrix))
  current.score = sum(crossprod(posteriors, dist.mat * transition.matrix))
  return(current.score > baseline.score)
}

# Run all checks
check_all <- function(posteriors, transition.matrix, dist, epsilon=1e-10) {
  gb = check_global_balance(posteriors, transition.matrix, epsilon)
  cp = check_valid_crossprod(posteriors, transition.matrix, epsilon)
  bl = check_baseline(posteriors, transition.matrix, dist)
  if (!gb) print("Global Balance does not hold!")
  if (!cp) print("Cross Product of Posterior and Transition Matrix does not sum to 1!")
  if (!bl) print("Solution is not better than pi-stacking solution!!")
  return(gb && cp && bl)
}
