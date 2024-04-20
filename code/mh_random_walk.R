# prior
# rho_k = p_k(1-p_k)
n = 20
# p_ks = 0:n/n

# likelihood
n_trials = 3
n_successes = 3

# gamma
gamma <- function(p) {
  if (p < 0 || p > 1) return(0)
  p*(1-p)*dbinom(n_successes, n_trials, p) 
}  


# propose to either move 1 up or down on discrete space.
# if proposed moves are out of bounds, decide between staying or moving instead. 
proposal <- function(current_point, n_states) {
  possible_moves = c(max(0, current_point - 1), min(n_states, current_point + 1))
  return(possible_moves[[rbinom(1,1,0.5) + 1]])
}

# metropolis-hastings random walk on discrete space
# n_states does not account for 0-indexing
mh_random_walk <- function(gamma, n_states, initial_point = round(n/2), n_iters = 3000) {
  samples = numeric(n_iters)
  # dim = length(initial_point)
  current_point = initial_point
  for (i in 1:n_iters) {
    # proposal = rnorm(dim, mean = current_point)
    proposal = proposal(current_point, n_states)
    ratio = gamma(proposal/n) / gamma(current_point/n)
    if (runif(1) < ratio) {
      current_point = proposal
    } 

    samples[i] = current_point
  }
  return(samples)
}

# function to call to sample
mh_sampling <- function(initial_point, n_iters) {
  return(mh_random_walk(gamma = gamma, 
                        n_states = n,
                        initial_point = initial_point,
                        n_iters = n_iters))
}
