  /* In order to support upgrades from 8.1.X.11, we need to make sure the latency measure gets deleted */
  
  UPDATE [EDDSPerformance].[eddsdbo].[Measure]
  SET IsActive = 0, IsDeleted = 1
  WHERE MeasureID = 3 AND MeasureCd = 'Latency';