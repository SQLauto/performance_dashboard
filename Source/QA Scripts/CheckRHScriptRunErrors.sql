EXEC sp_MSforeachdb
	'USE ?; 
	DECLARE @cutoff datetime;
	SET @cutoff = ''2014-05-13'';
	IF EXISTS (SELECT * FROM sys.tables WHERE name = ''RHScriptsRunErrors'')
		IF EXISTS(SELECT TOP 1 *
  FROM [eddsdbo].[RHScriptsRunErrors]
  where entry_date > @cutoff)
		SELECT *
  FROM [eddsdbo].[RHScriptsRunErrors]
  where entry_date > @cutoff
  order by id desc;'