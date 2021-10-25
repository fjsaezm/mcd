# Libraries
library(moments)
library(ggplot2)
# Seed and parameters
set.seed(234)
R <- 1000     # número de remuestras
mu <- 0
sigma <- 1
n <- 100
alpha <- 0.05
m <- 100

# Function that generates a sample of size n
# of the given distribution. Can be extended.
generate_sample <- function(distr){
  if(identical(distr,rnorm)){
    return (rnorm(n,mu,sigma))
  }
  else{
    return (rexp(n,rate=1))
  }
}

# Function that computes the confidence interval
# using the hybrid method. Parameters:
# - bootstrap_samples (needed for the final T)
# - original_estimator (taken out of the original sample)
# - bootstrap_estimator (obtained from the samples)
hybrid_ci_gen <- function(bootstrap_samples, original_estimator,bootstrap_estimator){
  # Obtain final T
  T_bootstrap <- sqrt(n) * (bootstrap_estimator - original_estimator)
  
  # Compute confidence interval
  ci_min <- original_estimator -  quantile(T_bootstrap, 1-alpha/2)/sqrt(n)
  ci_max  <- original_estimator -  quantile(T_bootstrap, alpha/2)/sqrt(n)
  interval <-  c(ci_min, ci_max)
  # Obtain accuracy 
  accuracy <-  ci_min < theta & ci_max > theta
  
  return(list(interval,accuracy))
}

# Function that computes the confidence interval
# using the percentile method. Same parameters.
percentile_ci_gen <- function(bootstrap_samples, original_estimator,bootstrap_estimator){
  
  #Obtain confidence interval
  ci_min <- quantile(bootstrap_estimator, alpha/2)
  ci_max <- quantile(bootstrap_estimator,1-alpha/2)
  interval <-  c(ci_min, ci_max)
  # Obtain accuracy 
  accuracy <-  ci_min < theta & ci_max > theta
  
  return(list(interval,accuracy))
}

# Function that computes the confidence interval
# using the normal method. Same parameters.
normal_ci_gen <- function(bootstrap_samples, original_estimator,bootstrap_estimator){
  #Obtain confidence interval
  ci_1 <- original_estimator - qnorm(alpha/2,0,1)*sd(bootstrap_estimator)
  ci_2 <- original_estimator + qnorm(alpha/2,0,1)*sd(bootstrap_estimator)
  ci_min <- min(ci_1,ci_2)
  ci_max <- max(ci_1,ci_2)
  interval <-  c(ci_min, ci_max)
  # Obtain accuracy 
  accuracy <-  ci_min < theta & ci_max > theta
  
  return(list(interval,accuracy))
}

# Function that plot each confidence interval with the real value
# of the parameter and colors in red if the interval does not
# contain the real value
plot_interval <- function(intervals,acc,name){
  df <- data.frame(ic_min <- intervals[,1],
                   ic_max <- intervals[, 2],
                   ind = 1:m,
                   acierto = acc)
  p <- ggplot(df) +
    geom_linerange(aes(xmin = ic_min, xmax = ic_max, y = ind, col = acc)) +
    scale_color_hue(labels = c("NO", "SÍ")) +
    geom_vline(aes(xintercept = theta), linetype = 2) +
    theme_bw() +
    labs(y = 'Muestras', x = 'Intervalos (nivel 0.95)',
         title = sprintf('IC (método bootstrap %s)',name))
  
  print(p)
}

# Function that computes m confidence intervals
# for a given distribution (prefixed) using R bootstrap
# samples for each c.i. using the method given as parameter
compute_ci <- function(distr){
#distr<- rnorm


  hybrid_intervals <- NULL
  hybrid_acc <- NULL
  normal_intervals <- NULL
  normal_acc <- NULL
  percentile_intervals <- NULL
  percentile_acc <- NULL
  
  for (i in 1:m){
    # Obtain original data and original T
    original_data <- generate_sample(distr)
    original_skew <- skewness(original_data)
    
    # Obtain bootstrap sample and bootstrap estimator
    bootstrap_data <- sample(original_data,n*R,rep = TRUE)
    bootstrap_data <- matrix(bootstrap_data, nrow = n)
    bootstrap_skew <- apply(bootstrap_data, 2, skewness)
    
    # Obtain ci and accuracy value for this iteration
    res_hybrid <- hybrid_ci_gen(bootstrap_data, original_skew, bootstrap_skew)
    res_normal <- normal_ci_gen(bootstrap_data, original_skew, bootstrap_skew)
    res_percentile <- percentile_ci_gen(bootstrap_data, original_skew, bootstrap_skew)
  
    hybrid_intervals <- rbind(hybrid_intervals,res_hybrid[[1]])
    hybrid_acc <- rbind(hybrid_acc,res_hybrid[[2]])

    normal_intervals <- rbind(normal_intervals, res_normal[[1]])
    normal_acc <- c(normal_acc,res_normal[[2]])
    
    percentile_intervals <- rbind(percentile_intervals, res_percentile[[1]])
    percentile_acc <- c(percentile_acc, res_percentile[[2]])
    
  }


  hybrid_total_acc <- sum(hybrid_acc == TRUE) / length(hybrid_acc)
  normal_total_acc <- sum(normal_acc == TRUE) / length(normal_acc)
  percentile_total_acc <- sum(percentile_acc == TRUE) / length(percentile_acc)

  print(sprintf("Acc for hybrid: %f", hybrid_total_acc))
  print(sprintf("Acc for normal: %f", normal_total_acc))
  print(sprintf("Acc for percentile: %f", percentile_total_acc))
  
  
  plot_interval(hybrid_intervals,hybrid_acc,"híbrido")
  plot_interval(normal_intervals,normal_acc,"suposicion normal")
  plot_interval(percentile_intervals,percentile_acc,"percentil")

}

  

  

theta <- 0
print("Accuracies for the gaussian distribution")
solutions <- compute_ci(rnorm)

theta <-2
print("Accuracies for the exponential distribution")
solutions <- compute_ci(rexp)



