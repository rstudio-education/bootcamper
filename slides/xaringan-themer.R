# load packages ----------------------------------------------------------------

library(xaringanthemer)

# set colors -------------------------------------------------------------------
mono_accent(
  base_color         = "#015382",
  header_font_google = google_font("Raleway"),
  text_font_google   = google_font("Raleway", "300", "300i"),
  code_font_google   = google_font("Fira Code"),
  text_font_size     = "24px",
  outfile            = "slides/xaringan-themer.css"
)
