select r.name,wt.k,wt.v,string_agg(wt.way_id::text,',' order by wt.way_id)
from highways h
inner join regions r on st_intersects(r.linestring,h.linestring)
inner join way_tags wt on wt.way_id=h.id and wt.k in ('name','name:uk','name:ru')
where 
(wt.k='name:uk' or wt.k='name' and r.relation_id not in (72639,71973,71971,1574364)) and
wt.v not similar to 
  '([АаБбВвГгҐґДдЕеЄєЖжЗзиІіїЇЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщьЮюЯя0-9XVI’«»"''\- \.]+)(вулиця|провулок|площа|проспект|бульвар|узвіз|міст|проїзд|набережна|шосе|алея|в’їзд|тупик|спуск|майдан|підйом|лінія|дорога|шляхопровід|автомагістраль)'
or
wt.k='name:ru' and
wt.v not similar to 
  '([АаБбВвГгДдЕеЁёЖжЗзИиЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщъыьЭэЮюЯя0-9XVI«»"\- \.]+)(улица|переулок|площадь|проспект|бульвар|спуск|мост|проезд|набережная|шоссе|аллея|въезд|тупик|спуск|майдан|подъём|линия|дорога|путепровод|автомагистраль)'
or wt.k='name' 
and wt.v not similar to 
  '([АаБбВвГгҐґДдЕеЄєЁёЖжЗзИиІіїЇЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщъыьЭэЮюЯя0-9XVI’«»"''\- \.]+)(вулиця|провулок|площа|проспект|бульвар|узвіз|міст|проїзд|набережна|шосе|алея|в’їзд|тупик|спуск|майдан|підйом|лінія|дорога|шляхопровід|автомагістраль|улица|переулок|площадь|проспект|бульвар|спуск|мост|проезд|набережная|шоссе|аллея|въезд|тупик|спуск|майдан|подъём|линия|дорога|путепровод|автомагистраль)'
group by r.name,wt.k,wt.v
order by r.name,wt.k,wt.v;

select r.name,wt.k,wt.v,string_agg(wt.way_id::text,',' order by wt.way_id)
from ways h
inner join regions r on st_intersects(r.linestring,h.linestring)
inner join way_tags wt on wt.way_id=h.id and wt.k in ('addr:street')
where 
r.relation_id not in (72639,71973,71971,1574364) and
wt.v not similar to 
  '([АаБбВвГгҐґДдЕеЄєЖжЗзиІіїЇЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщьЮюЯя0-9XVI’«»"''\- \.]+)(вулиця|провулок|площа|проспект|бульвар|узвіз|міст|проїзд|набережна|шосе|алея|в’їзд|тупик|спуск|майдан|підйом|лінія|дорога|шляхопровід|автомагістраль|квартал|сквер)'
or 
wt.v not similar to 
  '([АаБбВвГгҐґДдЕеЄєЁёЖжЗзИиІіїЇЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщъыьЭэЮюЯя0-9XVI’«»"''\- \.]+)(вулиця|провулок|площа|проспект|бульвар|узвіз|міст|проїзд|набережна|шосе|алея|в’їзд|тупик|спуск|майдан|підйом|лінія|дорога|шляхопровід|автомагістраль|улица|переулок|площадь|проспект|бульвар|спуск|мост|проезд|набережная|шоссе|аллея|въезд|тупик|спуск|майдан|подъём|линия|дорога|путепровод|автомагистраль|квартал|сквер)'
group by r.name,wt.k,wt.v
order by r.name,wt.k,wt.v;