
CREATE KEYSPACE IF NOT EXISTS adhoc_cloud WITH replication = {'class':'NetworkTopologyStrategy', 'datacenter1':2};
CREATE TABLE IF NOT EXISTS adhoc_cloud.nodes( id UUID PRIMARY KEY, ip text);
USE adhoc_cloud;
insert into nodes(id,ip) values (uuid(), 'hola');





