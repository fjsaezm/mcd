rnucleo <- function(n, muestra, h){
  # genera n observaciones de una distribución correspondiente a un estimador
  # del núcleo (calculado con 'muestra') con núcleo gaussiano y parámetro de suavizado h
  y = sample(muestra, n, rep = TRUE) + rnorm(n, sd = h)
  return(y)
}

alpha <- 3
beta <- 6
n <- 10000
sample <- rbeta(n,alpha,beta)

muestra <- faithful$eruptions
estimador_nucleo <- density(muestra)
h <- estimador_nucleo$bw
hist(muestra)
datos <- rnucleo(10000, muestra, h)
hist(datos, freq = FALSE)
lines(estimador_nucleo$x, estimador_nucleo$y)
