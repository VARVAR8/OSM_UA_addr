call config.bat

call update.pbf.bat
call load.data.into.db.bat
call find.errors.bat

rem call peirce.bat

call publish.results.now.bat

%psql_exe% -f sql\osm.vacuum.full.sql