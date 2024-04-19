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
mh_random_walk <- function(gamma, initial_point, n_states, n_iters = 10000) {
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

plot_traces_and_hist = function(samples) {
  layout_mat <- matrix(c(1, 2), nrow = 1, ncol = 2,
                       byrow = TRUE)
  layout(mat = layout_mat,
         heights = c(1),
         widths = c(3, 1), respect =TRUE)
  par(mar = c(2,2,0,0))
  plot(samples, axes = TRUE, type = "o", col = rgb(red = 0, green = 0, blue = 0, alpha = 0.2))
  xhist <- hist(samples, plot = FALSE)
  barplot(xhist$counts, axes = TRUE, space = 0, horiz=TRUE)
}

samples = mh_random_walk(gamma = gamma, 
                         initial_point = round(n/2),
                         n_states = n)
plot_traces_and_hist(samples)

