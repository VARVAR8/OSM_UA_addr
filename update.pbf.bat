md temp
if not exist temp\UA.osm.pbf (binaries\wget.exe http://data.gis-lab.info/osm_dump/dump/latest/UA.osm.pbf -O temp\UA.osm.pbf)
move temp\ua.osm.pbf temp\ua.0.pbf
cd binaries
osmupdate.exe ..\temp\UA.0.pbf ..\temp\ua.osm.pbf --hour --max-merge=2 -v -B=..\poly\ua.poly --complex-ways --keep-tempfiles --tempfiles=..\temp\osmupdate\
cd ..
if exist temp\UA.osm.pbf del temp\ua.0.pbf
if exist temp\ua.0.pbf move temp\ua.0.pbf temp\ua.osm.pbf