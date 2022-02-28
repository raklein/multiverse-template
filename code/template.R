# Blank template for 'multiverse' package to implement 
# 15 default degrees of freedom

# install.packages("devtools")
# devtools::install_github("MUCollective/multidy")

library("multiverse") # package was renamed multidy but currently still called as multiverse I think
library("tidyverse") #required
library("gganimate") # to visualize with animation
library("foreign") #to import spss file
library("effsize") # to get cohen d in the reproduction
library("cowplot") # for specification curve vis
library("haven") # read spss files

# Load sample data
# set use.value.labels to TRUE to see value labels
# reading in the ML1 dataset to experiment with
dat <- read_sav("data/Full_Dataset_De-Identified.sav")

# Let's use 'flag priming increases conservatism' as an example

#flagdv1 to flagdv8 are 8 questions each participant was asked where higher = more conservative
# flagtimeestimate1:flagtimeestimate4 indicates participant saw a flag (exp)
# noflagtimeestimate1:noflagtimeestimate4 indicates participant was in control

#combine into one column, and create index for IV

dat$flagcond <- NA

dat$flagcond[!is.na(dat$flagtimeestimate1)] <- "flag"
dat$flagcond[!is.na(dat$noflagtimeestimate1)] <- "control"

dat$flagcond <- as.factor(dat$flagcond)

# average the flagdv estimates for a basic DV
# dat <- dat %>% 
#   rowwise() %>% 
#   dplyr::mutate(flagdv_avg = mean(c(flagdv1, 
#                                 flagdv2, 
#                                 flagdv3, 
#                                 flagdv4, 
#                                 flagdv5, 
#                                 flagdv6, 
#                                 flagdv7, 
#                                 flagdv8), na.rm = TRUE))

# initialize multiverse
M <- multiverse()

# add data to multiverse
inside(M, df <- dat)

#### Implementing DFs ####
# Some dfs out of order because they need to be coded before/after something else

#### df_a1_missing_data: Varying how missing data were handled ####

# Dataset-wide missingness (NA to this dataset, too large)

# Missingness in DVs
# simulate some missing data first
dat$flagdv1[1:100] <- NA
dat$flagdv1[1000:1100] <- NA
dat$flagdv2[1000:1100] <- NA
dat$flagdv3[2000:2200] <- NA

inside(M, df <- df %>%
         filter( branch(missing_data,
                        "missing_dv_1" ~ TRUE, # no exclusions
                        "missing_dv_2" ~ !is.na(flagdv1) & # exclude if any dv NA
                                         !is.na(flagdv2) &
                                         !is.na(flagdv3) &
                                         !is.na(flagdv4) &
                                         !is.na(flagdv5) &
                                         !is.na(flagdv6) &
                                         !is.na(flagdv7) &
                                         !is.na(flagdv8)
                        )
         )
)

#### df_a6_outcome_scoring: Varying how the outcome variable(s) was/were computed. ####
#TODO: I'M NOT SURE IF THIS PART IS WORKING PROPERLY
inside(M, df <- df %>%
         mutate(flagdv = branch(dv_calculation,
                                "dv_calc_1" ~ (flagdv1 + flagdv2 + flagdv3)/3,
                                "dv_calc_2" ~ (flagdv1 + flagdv2)/2,
                                "dv_calc_3" ~ (flagdv1 + flagdv2 + flagdv3 + flagdv4 + flagdv5 + flagdv6 + flagdv7 + flagdv8)/8)
                
         )
)

#### df_a2_preprocessing: Varying aspects of data pre-processing such as transforming or recoding variables ####
# inside(M, df <- df %>%
#          mutate(flagdv = branch(dv_preprocessing,
#                             "dv_preprocessing_1" ~ flagdv,
#                             "dv_preprocessing_2" ~ log(flagdv))
#            
#          )
# )


#### df_a4_outlier_treatment: Varying how outliers on the Independent or Dependent variables were treated (e.g., dropped, transformed), or the criteria for labelling data as outliers ####

#### df_a7d4_outcome_construct_switching: ####
#### df_a8d1_manipulated_iv_switching: ####
#### df_a9d1_dropping_ivs: Dropping or collapsing across manipulated variables####
#### df_a10d2_covariates_predictors: Covariates or predictors added/removed from the model ####
#### df_a11_iv_scoring: Varying how the independent variable was scored or defined. ####

#### df_a12d5_participant_removal ####
# add optional exclusion based on age
# TODO: How to handle NA age cases
inside(M, df <- df %>%
         filter( branch(age_exclusions,
                        "age_excl_1" ~ TRUE, # no exclusions based on age
                        "age_excl_2" ~ age >= 18 & age <= 24,
                        "age_excl_3" ~ age >= 18 & age <= 23,
                        "age_excl_4" ~ age >= 18 & age <= 22,
                        "age_excl_5" ~ age >= 18 & age <= 21)
         )
)

# Gender exclusion default options
inside(M, df <- df %>%
         filter( branch(gender_exclusions,
                        "gender_excl_1" ~ TRUE,
                        "gender_excl_2" ~ sex == "f", #women only
                        "gender_excl_3" ~ sex == "m") #men only
         )
)

#### df_a15_inference_criteria: Varying the inference criteria being used (e.g., p < .05 vs p < .1; freq vs bayes) ####

# Raw code of multiverse specs
code(M)
parameters(M)
# Table to all specification combos
multiverse::expand(M) %>% select(-.code)

# number of specifications
multiverse::expand(M) %>% nrow()

#### MODELING ####

# # Leaving this block as an example of a single analysis, in case next branching
# block is too confusing. This block would repeat the same lm call for each 
# data processing step

# inside(M, 
#        fit_example <-lm( flagdv ~ flagcond, data = df )
#        )
# 
# inside(M,
#        summary_example <- fit_example %>% 
#         broom::tidy( conf.int = TRUE )
#        )
# 
# execute_multiverse(M)
# 
# results_table <- multiverse::expand(M) %>%
#   select(-.code) %>%
#   mutate( summary = map(.results, "summary_example" ) ) %>%
#   unnest( cols = c(summary) )

#### Branching analytic models ####

#### df_a3_nonparametric: Varying whether non-parametric statistics were used ####
#### df_a13_statistical_model: Varying the statistical model being used (e.g., regression, mixed models) ####
#### df_a14_estimation_software_parameters: Varying aspects of the statistical model such as how variance is being modeled ####

#### df_a5d3_outcome_switching: Varying which outcomes or dependent variables were included in the analysis ####
# This analysis block allows us to branch between dependent variables
# (here, each of the 8 questions assessing conservative political leaning
# analyzed separately or as an average)

inside(M,
       fit_example <- lm(branch(dependent_variable,
                                "flagdv1" ~ flagdv1, # list dependent variables
                                "flagdv2" ~ flagdv2,
                                "flagdv3" ~ flagdv3,
                                "flagdv4" ~ flagdv4,
                                "flagdv5" ~ flagdv5,
                                "flagdv6" ~ flagdv6,
                                "flagdv7" ~ flagdv7,
                                "flagdv8" ~ flagdv8,
                                "flagdv_composite" ~ flagdv) ~
                           flagcond, data = df)
)

inside(M,
       summary_example <- fit_example %>% 
         broom::tidy( conf.int = TRUE )
)

execute_multiverse(M)

results_table <- multiverse::expand(M) %>%
  select(-.code) %>%
  mutate( summary = map(.results, "summary_example" ) ) %>%
  unnest( cols = c(summary) )

#### visualization ####

# animated viz 
p <- multiverse::expand(M) %>%
  mutate( summary = map(.results, "summary_example") ) %>%
  unnest( cols = c(summary) ) %>%
  
  filter( term != "(Intercept)" ) %>%
  ggplot() + 
  geom_vline( xintercept = 0,  colour = '#979797' ) +
  geom_point( aes(x = estimate, y = term)) +
  geom_errorbarh( aes(xmin = conf.low, xmax = conf.high, y = term), height = 0) +
  transition_manual( .universe )

animate(p)

# Histogram of p-values

multiverse::expand(M) %>%
  mutate( index = seq(1:nrow(.)) ) %>%
  mutate( 
    summary_example = map(.results, "summary_example" )
  ) %>%
  select( summary_example ) %>%
  gather( "analysis", "result" ) %>%
  unnest(result) %>%
  filter( term != "(Intercept)") %>%
  ggplot() +
  geom_histogram(aes(x = p.value), bins = 100, fill = "#ffffff", color = "#333333") +
  geom_vline( xintercept = 0.05, color = "red", linetype = "dashed") +
  facet_wrap(~ analysis, scales = "free", nrow = 3)

# Specification curve 

data.spec_curve <- multiverse::expand(M) %>%
  mutate( summary_example = map(.results, "summary_example") ) %>%
  unnest( cols = c(summary_example) ) %>%
  filter( term != "(Intercept)" ) %>%
  select( .universe, !! names(parameters(M)), estimate, p.value ) %>%
  arrange( estimate ) %>%
  mutate( .universe = 1:nrow(.))

p1 <- data.spec_curve %>%
  gather( "parameter_name", "parameter_option", !! names(parameters(M)) ) %>%
  select( .universe, parameter_name, parameter_option) %>%
  mutate(
    parameter_name = factor(str_replace(parameter_name, "_", "\n"))
  ) %>%
  ggplot() +
  geom_point( aes(x = .universe, y = parameter_option, color = parameter_name), size = 0.5 ) +
  labs( x = "universe #", y = "option included in the analysis specification") + 
  facet_grid(parameter_name ~ ., space="free_y", scales="free_y", switch="y") +
  theme(strip.placement = "outside",
        strip.background = element_rect(fill=NA,colour=NA),
        panel.spacing.x=unit(0.15,"cm"), 
        strip.text.y = element_text(angle = 180, face="bold", size=10), 
        panel.spacing = unit(0.25, "lines")
  )

p2 <- data.spec_curve %>%
  ggplot() +
  geom_point( aes(.universe, estimate, color = (p.value < 0.05)), size = 0.25) +
  labs(x = "", y = "regression coefficient")

cowplot::plot_grid(p2, p1, axis = "bltr",  align = "v", ncol = 1, rel_heights = c(1, 3))
