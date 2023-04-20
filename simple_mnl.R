library(mixl)

rm(list = ls())



data("Train", package="mlogit")

loglik <- function(param) {
  U_A <- param["B_price"] * Train$price_A / 1000 + param["B_time"] * Train$time_A / 60
  U_B <- param["asc"] + param["B_price"] * Train$price_B / 1000 + param["B_timeB"] * Train$time_B / 60
  
  # helpers
  Y_A <- exp(U_A)
  Y_B <- exp(U_B)
  denominator <- Y_A + Y_B
  c_A <- as.numeric(Train$choice == "A")  # is 1 if A is chosen, 0 otherwise
  c_B <- as.numeric(Train$choice == "B")  # is 1 if B is chosen, 0 otherwise (1-c_A)
  
  Pint <- (Y_A / denominator)^c_A * (Y_B / denominator)^c_B
  sum(log(Pint))
}

param <- c(1, 1, 1, 1)
param <- setNames(param, c("asc", "B_price", "B_time", "B_timeB"))

m <- maxLik::maxLik(loglik, start = param, method = "BFGS")
summary(m)


# mixl comparison
Train$ID <- Train$id
Train$CHOICE <- as.numeric(Train$choice)

mnl_test <- "
	U_A = @B_price * $price_A / 1000 + @B_time * $time_A / 60;
	U_B = @asc + @B_price * $price_B / 1000 + @B_timeB * $time_B / 60;
	"

model_spec <- mixl::specify_model(mnl_test, Train, disable_multicore=T)

#only take starting values that are needed
est <- stats::setNames(c(1, 1, 1, 1), c("asc", "B_price", "B_time", "B_timeB"))
availabilities <- mixl::generate_default_availabilities(
  Train, model_spec$num_utility_functions)

model <- mixl::estimate(model_spec, est, Train, availabilities = availabilities)
summary(model)