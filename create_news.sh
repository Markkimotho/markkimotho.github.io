#!/usr/bin/bash

# Function to display the menu and get the user's choice
display_menu() {
  echo "Select the type of news to create:"
  echo "1. Inline News"
  echo "2. News with Long Details"
  echo "3. Exit"
  read -p "Enter your choice (1/2/3): " choice
  echo
}

# Function to create inline news
create_inline_news() {
  echo "Creating Inline News..."

  # Ask for the title of the news
  read -p "Enter the title for the news (e.g., 'A simple inline announcement'): " title

  # Automatically get the current date in the required format
  date=$(date +'%b %d, %Y')

  # Find the next available announcement number
  next_number=$(ls _news/announcement_*.md | wc -l)
  next_number=$((next_number + 1))

  # Generate the file name
  file_name="announcement_${next_number}.md"

  # Create the Markdown file with the user-provided content
  cat <<EOL > "_news/$file_name"
---
layout: post
date: $(date -d "$date" +%Y-%m-%d\ %H:%M:%S-0400)
inline: true
related_posts: false
---

$title

EOL

  # Open the newly created file in VS Code for editing
  code "_news/$file_name"

  echo "Inline news '$file_name' created successfully."
  exit 0  # Exit the script after creating the news
}

# Function to create news with long details
create_news_with_long_details() {
  echo "Creating News with Long Details..."

  # Ask for the title of the news
  read -p "Enter the title for the news (e.g., 'A long announcement with details'): " title

  # Automatically get the current date in the required format
  date=$(date +'%b %d, %Y')

  # Find the next available announcement number
  next_number=$(ls _news/announcement_*.md | wc -l)
  next_number=$((next_number + 1))

  # Generate the file name
  file_name="announcement_${next_number}.md"

  # Create the Markdown file with the user-provided content
  cat <<EOL > "_news/$file_name"
---
layout: post
title: "$title"
date: $(date -d "$date" +%Y-%m-%d\ %H:%M:%S-0400)
inline: false
related_posts: false
---

Announcements and news can be much longer than just quick inline posts. In fact, they can have all the features available for the standard blog posts. See below.

---

Jean shorts raw denim Vice normcore, art party High Life PBR skateboard stumptown vinyl kitsch. Four loko meh 8-bit, tousled banh mi tilde forage Schlitz dreamcatcher twee 3 wolf moon. Chambray asymmetrical paleo salvia, sartorial umami four loko master cleanse drinking vinegar brunch. <a href="https://www.pinterest.com">Pinterest</a> DIY authentic Schlitz, hoodie Intelligentsia butcher trust fund brunch shabby chic Kickstarter forage flexitarian. Direct trade <a href="https://en.wikipedia.org/wiki/Cold-pressed_juice">cold-pressed</a> meggings stumptown plaid, pop-up taxidermy. Hoodie XOXO fingerstache scenester Echo Park. Plaid ugh Wes Anderson, freegan pug selvage fanny pack leggings pickled food truck DIY irony Banksy.

#### Hipster list

<ul>
    <li>brunch</li>
    <li>fixie</li>
    <li>raybans</li>
    <li>messenger bag</li>
</ul>

Hoodie Thundercats retro, tote bag 8-bit Godard craft beer gastropub. Truffaut Tumblr taxidermy, raw denim Kickstarter sartorial dreamcatcher. Quinoa chambray slow-carb salvia readymade, bicycle rights 90's yr typewriter selfies letterpress cardigan vegan.

---

Pug heirloom High Life vinyl swag, single-origin coffee four dollar toast taxidermy reprehenderit fap distillery master cleanse locavore. Est anim sapiente leggings Brooklyn ea. Thundercats locavore excepteur veniam eiusmod. Raw denim Truffaut Schlitz, migas sapiente Portland VHS twee Bushwick Marfa typewriter retro id keytar.

> We do not grow absolutely, chronologically. We grow sometimes in one dimension, and not in another, unevenly. We grow partially. We are relative. We are mature in one realm, childish in another.
> —Anais Nin

Fap aliqua qui, scenester pug Echo Park polaroid irony shabby chic ex cardigan church-key Odd Future accusamus. Blog stumptown sartorial squid, gastropub duis aesthetic Truffaut vero. Pinterest tilde twee, odio mumblecore jean shorts lumbersexual.

EOL

  # Open the newly created file in VS Code for editing
  code "_news/$file_name"

  echo "News with long details '$file_name' created successfully."
  exit 0  # Exit the script after creating the news
}

# Main loop
while true; do
  display_menu

  case $choice in
    1)
      create_inline_news
      ;;
    2)
      create_news_with_long_details
      ;;
    3)
      echo "Exiting..."
      exit 0  # Exit if the user selects 'Exit'
      ;;
    *)
      echo "Invalid choice, please try again."
      ;;
  esac
done
