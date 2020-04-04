library(tidyverse)

cutoffs <- tibble(grade = LETTERS[c(1:4, 6)], min = c(.9, .8, .7, .6, -Inf), max = c(Inf, .9, .8, .7, .6), col =  rainbow(5)) %>%
  mutate(mid = .5*(min + max), mid = ifelse(is.infinite(mid), .75 + sign(max + min) * .2, mid))

grades <- read_csv("data/2020-04-04T1248_Grades-STAT-218-150.1201.csv") %>%
  mutate_at(-c(1:5), as.numeric) %>%
  filter(Student != "Points Possible" & Student != "Test Student")

grades %>%
  filter(`Exam 2 (668356)` > 0) %>%
  ggplot(aes(x = `Exam 2 (668356)`/79*100)) + geom_histogram(fill = "grey", color = "black") +
  scale_x_continuous("Exam 2 (%)") + scale_y_continuous("# Students") + ggtitle("Exam 2 Scores")


grades %>%
  filter(`Exam 2 (668356)` > 0) %>%
ggplot(aes(y = `Exam 2 (668356)`/79*100, x = `Exam 1 (657475)`/65*100)) + geom_point(shape = 1) +
  scale_x_continuous("Exam 1 Score") + scale_y_continuous("Exam 2 Score") +
  ggtitle("Exam Performance") +
  geom_abline(slope = 1, intercept = 0) +
  coord_fixed()

max_score <- 100
ggplot() +
  ggtitle("Current Overall Grade Distribution") +
  scale_x_continuous("Current Score") + scale_y_continuous("# Students") +
  geom_rect(data = cutoffs, aes(xmin = min*max_score, xmax = max*max_score, ymin = 0, ymax = Inf, fill = col), alpha = .2) +
  scale_fill_identity() +
  geom_text(data = cutoffs, aes(x = mid*max_score, y = 16, label = grade))+
  geom_histogram(data = grades, aes(x = `Unposted Current Score`), fill = "grey", color = "black", breaks = seq(48, 102, 2))
