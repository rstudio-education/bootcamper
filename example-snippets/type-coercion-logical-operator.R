library(tidyverse)

df <- tibble(x = 0:5, y = 1:6, z = -2:3)

# x or y is greater than or equal to 1 - WORKS
df %>%
  filter(x >= 1 | y >= 1)

# x or y is greater than or equal to 1 - WORKS
df %>%
  filter(x | y)

# x or z is greater than or equal to 1 - WORKS
df %>%
  filter(x >= 1 | z >= 1)

# x or z is greater than or equal to 1 - DOESN'T WORK
df %>%
  filter(x | z)
