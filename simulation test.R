setwd("~/Documents/Uppsala universitet/T8 22 HT/Examensarbete/R kod")

# simulation test

# namn på prompt i en vector
promt <- c("A_weather", "B_bankrupt", "C_house")

# sampla n = 10 för de olika parametrarna
set.seed(96)
prompt_sample <- sample(x = promt, size = 10, replace = TRUE, 
                    prob = c((1/3), (1/3), (1/3)) 
                      )

guidance <- round(runif(n = 10, min = 0.5, max = 20), digits = 1) #avrundat till 1 decimal

xtra_prompt <-  rbinom(n = 10, size = 1, prob = 0.5)

guide_image <-  rbinom(n = 10, size = 1, prob = 0.5)

inf_steps_log_sample<- runif(n = 10, min = log(50), max = log(250)) # loggade värden är uniform dist

inf_steps<- round(exp(inf_steps_log_sample), digits = 0) # höjer upp med e för att få bort loggen
# detta gör att låga värden på inf_steps är mer sannolika. (Vi får en skev fördelning)
# finns mer info i låga tal. + lättare att extrapolera de höga talen
# avrundat till närmsta heltal

hist(exp(inf_steps_log_sample))

# spara i en df
df <- data.frame(prompt = prompt_sample,
                 guidance = guidance,
                 inf_steps = inf_steps,
                 xtra_prompt = xtra_prompt,
                 guide_image_bin = guide_image)

# skapa en hjälp-variabel som anger om (och vilken) guidebild som ska användas när
df$image <- NA
df$image[df$prompt == "A_weather" & df$guide_image_bin == 1] <- "tree"
df$image[df$prompt == "B_bankrupt" & df$guide_image_bin == 1] <- "bank"
df$image[df$prompt == "C_house" & df$guide_image_bin == 1] <- "coin"
df$image[ df$guide_image_bin == 0] <- "none"

#inf_steps<- round(runif(n = 100, min = 50, max = 250), digits = 0)

write.csv(df, file = "test_simulation.csv")





















