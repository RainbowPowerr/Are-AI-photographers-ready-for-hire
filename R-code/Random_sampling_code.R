

# simulation 

# a vector with the promt-names
promt <- c("weather", "bankruptcy", "houseing")

# sample n=1000 with euqal prob for the different prompts
set.seed(96)
prompt_sample <- sample(x = promt, size = 1000, replace = TRUE, 
                        prob = c((1/3), (1/3), (1/3)) 
)

# sample n = 1000 for the other variables
guidance <- round(runif(n = 1000, min = 1, max = 20), digits = 1) # rounded to one decimal

xtra_prompt <-  rbinom(n = 1000, size = 1, prob = 0.5)

guide_image <-  rbinom(n = 1000, size = 1, prob = 0.5) # NOTE! This variable is not used in the thesis!

inf_steps_log_sample<- runif(n = 1000, min = log(50), max = log(250)) # the loged values are uniform dist

inf_steps<- round(exp(inf_steps_log_sample), digits = 0) # raise e to the power of the values to remove the log transformation
# this makes lower values of inf_steps more probable (i.e we have a skewed distribution)
# There is more info in the lower values that the higher values -> easier to extrapolate info from high values
# round the numbers to closest integer.

hist(exp(inf_steps_log_sample)) # visualise the skewed dist for inf_steps

# save in a df
df <- data.frame(prompt = prompt_sample,
                 guidance = guidance,
                 inf_steps = inf_steps,
                 xtra_prompt = xtra_prompt,
                 guide_image_bin = guide_image)

# create a help variable that tells which (if any) guide image should be used (NOTE! This variable is not used in the thesis!)
df$image <- NA
df$image[df$prompt == "weather" & df$guide_image_bin == 1] <- "forest"
df$image[df$prompt == "bankruptcy" & df$guide_image_bin == 1] <- "boxes"
df$image[df$prompt == "houseing" & df$guide_image_bin == 1] <- "coinstack"
df$image[ df$guide_image_bin == 0] <- "none"

#creating an index
df$index <- NA
df$index <- 0:999

# remove images that do not contain the variable guide_image (Since the variable is not included in the thesis)
index<- df$index[df$image == "none"]

# Create new df without "guide_image"
index_id<- df$index[df$image == "none"]
prompt_id<- df$prompt[df$image == "none"]
guidance_id<- df$guidance[df$image == "none"]
inf_steps_id<- df$inf_steps[df$image == "none"]
xtra_prompt_id<- df$xtra_prompt[df$image == "none"]

df_index <- data.frame(index = index_id,
                       prompt = prompt_id,
                       guidance = guidance_id,
                       inf_steps = inf_steps_id,
                       xtra_prompt = xtra_prompt_id)

# save df as a .csv
write.csv(df_index, file = "image_data_with_index.csv")
