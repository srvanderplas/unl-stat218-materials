library(tidyverse)

set.seed(1029479)
study <- tibble(
  indiv = 1:30,
  overall_stress = rnorm(30, mean = 12, sd = 3),
  puppy_response = rnorm(30, mean = -4, sd = 1),
  walk_response = rnorm(30, mean = 0, sd = 1)
) %>%
  mutate(adorable = round(overall_stress + puppy_response),
         walk = round(overall_stress + walk_response)) %>%
  select(-overall_stress, -matches("response")) %>%
  select(1, 3, 2) %>%
  write_tsv(path = "data/OfficeStressPaired.tsv")

sum_stats <-  sprintf("Mean D: %0.2f\n   SD D: %0.2f", mean(study$walk - study$adorable), sd(study$walk - study$adorable))

ggplot(study, aes(x = walk - adorable)) + geom_bar() +
  xlab("Difference in Stress Level: (Walk - Cute)") +
  annotate("text", x = Inf, y = Inf, label = sum_stats, hjust = 1, vjust = 1) +
  ylab("# Participants") + ggtitle("Office Stress: Do Cute Animal Pictures Help?")
