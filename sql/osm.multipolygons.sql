select '{';
select '"type": "FeatureCollection",';
select '"errorDescr": "Multipolygon end-node",';

select '"features": [';
with a as (
  select rm.relation_id,rm.member_id as way_id
  from relation_tags rt
    inner join relation_members rm on rm.relation_id=rt.relation_id and rm.member_type='W'
  where rt.k='type' and rt.v in ('multipolygon','boundary')
),
c as 
(
  select a.relation_id,
        (select node_id from way_nodes wn where wn.way_id=a.way_id and sequence_id=0) as node_id
  from a
  union all
  select a.relation_id,
        (select node_id from way_nodes wn where wn.way_id=a.way_id order by sequence_id desc limit 1) as node_id
  from a
),
d as (
  select relation_id,node_id
  from c
  group by relation_id,node_id
  having count(*) not in (2,4))
select '{"type":"Feature","properties":{"josm":"r'||d.relation_id||',n'||node_id||'","region":"'||r.name||'"},"geometry":'||st_asgeojson(n.geom,5)||'},'
from d
  inner join nodes n on n.id=node_id
  inner join regions r on r.relation_id=60199 or r.relation_id=d.relation_id or _st_contains(r.linestring, n.geom)
order by 1;

with tab as (
select 'r'||r.id ids,--||string_agg(',w'||w.id, '' order by w.id) ids,
case when r.id in (select relation_id from relation_members group by relation_id having count(*)=1) then 'multipolygon without tags and single member - delete relation' 
     when count(*)>1 and (select min(kv) from (select count(*) kv from way_tags wt where wt.way_id=any(array_agg(w.id)) group by k, v) kv)=count(*) then 'multipolygon without tags, members have identical tags - move tags from ways to relation'
     when count(*)>1 and (select min(kv) from (select count(*) kv from way_tags wt where wt.way_id=any(array_agg(w.id)) group by k, v) kv)<count(*) then 'multipolygon without tags, members have different tags - move appropriate tags to relation'
else null end error,
(select string_agg(kv, ', ' order by kv) from (select k||'='||v kv, count(*) cnt from way_tags wt where wt.way_id=any(array_agg(w.id)) group by k, v) kv where cnt=(select count(*) from relation_members where relation_id=r.id and member_role='outer')) as commonTags,
(select string_agg(kv, ', ' order by kv) from (select k||'='||v kv, count(*) cnt from way_tags wt where wt.way_id=any(array_agg(w.id)) group by k, v) kv where cnt<(select count(*) from relation_members where relation_id=r.id and member_role='outer')) as differTags,
min(st_pointn(w.linestring,2)) as geom
from relations r
inner join relation_tags rt on rt.relation_id=r.id
inner join relation_members rm on rm.relation_id=rt.relation_id and rm.member_role='outer'
left  join ways w on w.id=rm.member_id
where rt.relation_id in (select relation_id from relation_tags rt group by relation_id having count(*)=1 and 'type'=any(array_agg(rt.k)) and 'multipolygon'=any(array_agg(rt.v)))
group by r.id
having sum(case when exists(select * from regions rr where st_contains(rr.linestring, w.linestring)) then 1 else 0 end)>0
order by 1)
select '{"type":"Feature","properties":{"josm":"'||ids||'","error":"'||error||'"},"geometry":'||st_asgeojson(geom,5)||'},'
from tab 
where error is not null;

select '{"type":"Feature"}';
select ']}';
