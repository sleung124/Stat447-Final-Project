library("lpSolve")
library("extraDistr")

# Generate objective matrix. Turning this matrix into a vector
# is handled by the actual optimization function. This function 
# returns a matrix so that it's easier to see step-by-step what's
# going on. 
objective_matrix <- function(indices, posteriors, dist) {
  ind <- length(indices)
  temp <- matrix(NA, nrow = ind, ncol = ind)
  for (col in 1:ind) {
    for (row in 1:ind) {
      temp[row, col] = dist(row, col)
    }
  }
  return(temp*posteriors)
}

# Generate constraint matrix for linear optimization problem
constraint_matrix <- function(posteriors) {
  # number of parameters = n **2 
  ind = length(posteriors)
  con_mat = matrix(0, nrow = ind, ncol = ind ** 2)
  ones_mat = matrix(0, nrow = ind, ncol = ind ** 2)
  for (row in 1:ind) {
    con_mat[row,1:ind + (row-1)*ind] = posteriors
    ones_mat[row,1:ind + (row-1)*ind] = rep(1, ind)
  }
  return(rbind(con_mat, ones_mat))
}

# The actual linear optimization. Returns Kernel to potentially sample from. 
lp_optimize <- function(direction = "max", int.vec = c(), posteriors, realizations, dist) {
  # create inputs for lp function to intake
  f.obj = as.vector(t(objective_matrix(indices = realizations,
                                       posteriors = posteriors,
                                       dist = dist)))
  f.con = constraint_matrix(posteriors)
  f.con.dim = dim(f.con)
  f.dir = rep("=", f.con.dim[[1]])
  f.rhs = c(posteriors, rep(1, f.con.dim[[1]] / 2))
  
  return(lp(direction = direction, 
            objective.in = f.obj, 
            const.mat = f.con,
            const.dir = f.dir,
            const.rhs = f.rhs,
            int.vec = int.vec))
}

# simulate next index
next_index <- function(curr_index, posteriors, realizations, dist){
  sol = lp_optimize(posteriors = posteriors, 
                    realizations = realizations, 
                    dist = dist)
  sol.mat = matrix(sol$solution, nrow=length(posteriors), byrow = TRUE)
  target_dist = sol.mat[curr_index,]
  return(rcat(1, target_dist))
}