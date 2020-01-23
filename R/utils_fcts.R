# # Regex to locate links in text
# find_link <- regex("
#                    \\[   # Grab opening square bracket
#                    .+?   # Find smallest internal text as possible
#                    \\]   # Closing square bracket
#                    \\(   # Opening parenthesis
#                    .+?   # Link text, again as small as possible
#                    \\)   # Closing parenthesis
#                    ",
#                    comments = TRUE)

# # Function that removes links from text and replaces them with superscripts that are
# # referenced in an end-of-document list.
# sanitize_links <- function(text){
#   if(PDF_EXPORT){
#     str_extract_all(text, find_link) %>%
#       pluck(1) %>%
#       walk(function(link_from_text){
#         title <- link_from_text %>% str_extract('\\[.+\\]') %>% str_remove_all('\\[|\\]')
#         link <- link_from_text %>% str_extract('\\(.+\\)') %>% str_remove_all('\\(|\\)')

#         # add link to links array
#         links <<- c(links, link)

#         # Build replacement text
#         new_text <- glue('{title}<sup>{length(links)}</sup>')

#         # Replace text
#         text <<- text %>% str_replace(fixed(link_from_text), new_text)
#       })
#   }
#   text
# }

# # Take entire positions dataframe and removes the links
# # in descending order so links for the same position are
# # right next to eachother in number.
# strip_links_from_cols <- function(data, cols_to_strip){
#   for(i in 1:nrow(data)){
#     for(col in cols_to_strip){
#       data[i, col] <- sanitize_links(data[i, col])
#     }
#   }
#   data
# }

# Take a position dataframe and the section id desired
# and prints the section to markdown.
print_section <- function(position_data, section_id){
position_data %>%
  filter(section == section_id) %>%
  mutate(end_date = replace_na(end_date,Sys.Date()),
         description = replace_na(description,"")) %>%
  arrange(desc(end_date)) %>%
  mutate(id = 1:n(),
         location = str_c(city_location,
                          ", ",
                          country_location),
         duration = str_c(if_else(end_date==Sys.Date(),
                                              "today",
                                              format.Date(end_date,
                                                          format="%Y-%m")
                                  ),
                          " - ",
                          format.Date(start_date,
                                      format="%Y-%m")
                          )
         ) %>%
  select(title,location,institution,duration,description) %>%
  glue::glue_data(
   "### {title}",
   "\n\n",
   "{institution}",
   "\n\n",
   "{location}",
   "\n\n",
   "{duration}",
   "\n\n",
   "{description}",
   "\n\n\n"
 )
}

# Construct a bar chart of skills
build_skill_bars <- function(skills, out_of = 5){
  bar_color <- "#969696"
  bar_background <- "#d9d9d9"
  skills %>%
    mutate(width_percent = round(100*level/out_of)) %>%
    glue_data(
      "<div class = 'skill-bar'",
      "style = \"background:linear-gradient(to right,",
      "{bar_color} {width_percent}%,",
      "{bar_background} {width_percent}% 100%)\" >",
      "{skill}",
      "</div>"
    )
}
