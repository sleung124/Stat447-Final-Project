library("lpSolve")
library("extraDistr")

# Generate objective matrix. Turning this matrix into a vector
# is handled by the actual optimization function. This function 
# returns a matrix so that it's easier to see step-by-step what's
# going on. 
objective_matrix <- function(posteriors, dist) {
  ind <- length(posteriors)
  temp <- matrix(NA, nrow = ind, ncol = ind)
  for (col in 1:ind) {
    for (row in 1:ind) {
      temp[row, col] = dist(row, col)
    }
  }
  return(temp*posteriors)
}

# helper function for proper indexing of ones_mat in constraint matrix
# by construction, num_of_cols is always a perfect square
one_mat_index <- function(row, num_of_cols) {
  lst = 1:num_of_cols
  vals = lst %% sqrt(num_of_cols) == row - 1
  return(lst[vals])
}

# Generate constraint matrix for linear optimization problem
constraint_matrix <- function(posteriors) {
  # number of parameters = n **2 
  ind = length(posteriors)
  con_mat = matrix(0, nrow = ind, ncol = ind ** 2)
  ones_mat = matrix(0, nrow = ind, ncol = ind ** 2)
  for (row in 1:ind) {
    con_mat[row,1:ind + (row-1)*ind] = posteriors
    ones_mat[row,one_mat_index(row, ind ** 2)] = 1
    # ones_mat[row,1:ind + (row-1)*ind] = rep(1, ind)
  }
  return(rbind(con_mat, ones_mat))
  # return(con_mat)
}

# The actual linear optimization. Returns Kernel to potentially sample from. 
lp_optimize <- function(direction = "max", int.vec = c(), posteriors, dist) {
  # create inputs for lp function to intake
  f.obj = as.vector(objective_matrix(posteriors = posteriors,
                                     dist = dist))
  f.con = constraint_matrix(posteriors)
  f.con.dim = dim(f.con)
  f.dir = rep("=", f.con.dim[[1]])
  f.rhs = c(posteriors, rep(1, f.con.dim[[1]] / 2))
  # f.dir = rep("=", length(posteriors))
  # f.rhs = posteriors
  
  return(lp(direction = direction, 
            objective.in = f.obj, 
            const.mat = f.con,
            const.dir = f.dir,
            const.rhs = f.rhs,
            int.vec = int.vec))
}

# row = where i am
# col = where i am going
get_solution_matrix <- function(sol, length) matrix(sol$solution, nrow=length)

# simulate next index
next_index <- function(curr_index, posteriors, dist){
  sol = lp_optimize(posteriors = posteriors, 
                    dist = dist)
  # sol.mat = matrix(sol$solution, nrow=length(posteriors), byrow = TRUE)
  sol.mat = get_solution_matrix(sol, length(posteriors))
  # print(sol.mat[curr_index,])
  target_dist = sol.mat[curr_index,]
  return(rcat(1, target_dist))
}