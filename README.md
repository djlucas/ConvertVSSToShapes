# ConvertVSSToShapes
Convert Visio VSS and VSSX libraries to Dia Shape libraries

Silly scirpt to convert VSS files into Dia Shapes

This is all other people's stuff, but here is a complete conversion script that you can use in Ubuntu WLS, others with prereqs mastered.

1 Install Prereqs:
sudo apt install gsfonts xsltproc libboost-all-dev librevenge-dev libvisio-dev libvisio-tools libemf2svg-dev \
                 libwmf-dev git inkscape build-essential cmake librsvg2-bin

2 Build and install libvisio2svg:
git clone
https://github.com/kakwa/libvisio2svg.git
cd libvisio2svg/
cmake . -DCMAKE_INSTALL_PREFIX=/usr/
make
sudo make install

3 Get the xslt transform for the shape files (I actually include it anyway)
wget https://wiki.gnome.org/Apps/Dia/SvgToShapeXslt?action=AttachFile&do=get&target=svg2shape.xslt

4 Seutp directories...in short, wherver you put the script and the xslt file, create a VSS directory and put all of your VSS and VSSX files in it.

5. Run ./convert-vss.sh
