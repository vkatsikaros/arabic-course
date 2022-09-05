#!/usr/bin/env bash

# page 1
convert -density 400 my_vocabulary_duo.pdf[0] -crop  625x3625+$((0*625+400))+401 -quality 99 flash_cards/page0_col0.jpg
convert -density 400 my_vocabulary_duo.pdf[0] -crop  625x3625+$((1*625+400))+401 -quality 99 flash_cards/page1_col3.jpg
convert -density 400 my_vocabulary_duo.pdf[0] -crop  625x3625+$((2*625+430))+401 -quality 99 flash_cards/page0_col1.jpg
convert -density 400 my_vocabulary_duo.pdf[0] -crop  625x3625+$((3*625+400))+401 -quality 99 flash_cards/page1_col2.jpg

convert -density 400 my_vocabulary_duo.pdf[1] -crop  625x3625+$((0*625+400))+401 -quality 99 flash_cards/page0_col2.jpg
convert -density 400 my_vocabulary_duo.pdf[1] -crop  625x3625+$((1*625+400))+401 -quality 99 flash_cards/page1_col1.jpg
convert -density 400 my_vocabulary_duo.pdf[1] -crop  625x3625+$((2*625+430))+401 -quality 99 flash_cards/page0_col3.jpg
convert -density 400 my_vocabulary_duo.pdf[1] -crop  625x3625+$((3*625+400))+401 -quality 99 flash_cards/page1_col0.jpg
# page 1 end

# special case
convert -density 400 my_vocabulary_duo.pdf[2] -crop  625x3625+$((0*625+400))+401 -quality 99 flash_cards/page2_col0.jpg
convert -density 400 my_vocabulary_duo.pdf[2] -crop  625x3625+$((1*625+400))+401 -quality 99 flash_cards/page3_col3.jpg
convert -density 400 my_vocabulary_duo.pdf[2] -crop  625x3625+$((2*625+430))+401 -quality 99 flash_cards/page2_col1.jpg
convert -density 400 my_vocabulary_duo.pdf[2] -crop  625x3625+$((3*625+400))+401 -quality 99 flash_cards/page3_col2.jpg

convert +append flash_cards/page0*.jpg flash_cards/s1.jpg
convert +append flash_cards/page1*.jpg flash_cards/s2.jpg

convert +append flash_cards/page2*.jpg flash_cards/s3.jpg
convert +append flash_cards/page3*.jpg flash_cards/s4.jpg

#convert -border 350 -bordercolor white flash_cards/s*.jpg flash_cards/cards.pdf
convert -border 350 -bordercolor white flash_cards/s*.jpg \
  -fill none -stroke black \
  -draw "stroke-dasharray 2 20  path 'M $((0*625+350)),400 L $((0*625+350)),4000'" \
  -draw "stroke-dasharray 2 20  path 'M $((1*625+350)),400 L $((1*625+350)),4000'" \
  -draw "stroke-dasharray 2 20  path 'M $((2*625+350)),400 L $((2*625+350)),4000'" \
  -draw "stroke-dasharray 2 20  path 'M $((3*625+350)),400 L $((3*625+350)),4000'" \
  -draw "stroke-dasharray 2 20  path 'M $((4*625+350)),400 L $((4*625+350)),4000'" \
  flash_cards/cards.pdf
#rm flash_cards/page*.jpg
