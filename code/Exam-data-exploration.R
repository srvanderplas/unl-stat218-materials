library(tidyverse)
library(httr)

# GET("http://stapi.co/api/v1/rest/ship?")

alcohol <- read_csv(here::here("data/open_units.csv"),
                    col_names = c("Product", "Brand", "Category", "Style",
                                  "Quantity", "Quantity Units", "Volume", "Package",
                                  "ABV", "Units", "Units.precise", "Units.per.100mL")) %>%
  mutate(Style_simple = str_extract(Style, "IPA|Lager|Ale|Cider|Beer|Wine|Stout"),
         Style_simple = ifelse(is.na(Style_simple), "Other", Style_simple))
ggplot(alcohol, aes(x = Style_simple, y = ABV, color = Category )) + geom_boxplot() + geom_jitter()


bob_ross <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-08-06/bob-ross.csv") %>%
  janitor::clean_names() %>%
  separate(episode, into = c("season", "episode"), sep = "E") %>%
  mutate(season = str_extract(season, "[:digit:]+")) %>%
  mutate_at(vars(season, episode), as.integer)

bob_ross %>%
  pivot_longer(cols = -c(1:3), names_to = "feature", values_to = "present") %>%
  group_by(feature) %>% summarize(pct = mean(present)) %>% arrange(desc(pct))

bob_ross %>% group_by(season, episode, title) %>%
  filter(!guest) %>%
  mutate(has_tree = tree | conifer | deciduous | trees | palm_trees,
         both = deciduous * conifer,
         deciduous_only = deciduous * !conifer * !palm_trees,
         conifer_only = conifer * !deciduous * !palm_trees,
         palm_only = palm_trees * !conifer * !deciduous,
         unspecified = (tree | trees) * (!conifer) * (!deciduous) * (!palm_trees)) %>%
  ungroup() %>%
  select(has_tree:unspecified) %>%
  summarize_each(sum)
sum(!bob_ross$guest)


# Squirrels in NYC

https://github.com/mine-cetinkaya-rundel/nycsquirrels18
