# png_parser
This script filters the .png pictures by the number of colors in three folders. It was written as an assistant for the utility ImageMagic.convert. What in total allows you to parse pictures from a .psd

How to use: 
sudo apt install ImageMagic

convert test.psd path/out.png

sudo chmod +x pngfilter.sh //give the file the necessary rights

./pngfilter.sh -d path_to_png -f path_where_to_put -cc 123 //-cc -- custom parameter
