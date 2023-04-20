# Simple Multinomial Logit Model

- clone or `devtools::install_github("ivt-baug-ethz/simple_mnl")`
- `browseVignettes("simple_mnl")`

All coded in R. This should illustrate the mechanics of discrete choice modeling. More complicated models are not much more difficult to code (however usually envolve taking random draws since there exists no closed-form solution for the likelihood function (integral). Not too difficult though and the idea remains the same! :)

By the way the `mixl` package does more or less exactly this but codes the log lik function in C++ with the `Rcpp` package and parallelizes the computations (since the LL for each individal can be computed independently (however, in this simple MNL example, the vectorized computation is probably not much slower). Also the neat thing about mixl is the way one can specify utilities (as string) which are then parsed to the corresponding indirect utilities V.

If you know some C++ try to write the `loglik` function with `Rcpp::cppFunction` and check the performance gain!
