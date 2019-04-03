use edds

select 
rs.ArtifactID, 
rs.name as ServerName, 
c.name as ServerType, 
rs.URL 
from eddsdbo.ResourceServer as rs
	inner join eddsdbo.Code as c on rs.[Type] = c.ArtifactID