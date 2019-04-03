USE [EDDSPerformance]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[eddsdbo].[LoadBISSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [eddsdbo].[LoadBISSummary]
GO
DECLARE @_ AS VARBINARY(MAX)
SET @_ = 0x0D000A002D002D0020003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D000D000A002D002D00200041007500740068006F0072003A000900090052006F006E0040004D0069006C0079006C0069000D000A002D002D002000430072006500610074006500200064006100740065003A00200032003000310032002D00300036002D00300031000D000A002D002D0020004400650073006300720069007000740069006F006E003A0009000D000A002D002D00200032003000310033002D00300032002D003100380020003A00200052006F006E0040004D0069006C0079006C00690020003A0020004100640064006500640020006E0065007700200054006F00740061006C004E005200510043006F0075006E00740020006600690065006C0064000D000A002D002D00200032003000310033002D00300032002D003100380020003A00200052006F006E0040004D0069006C0079006C00690020003A00200041006400640065006400200074006800650020006600690065006C006400200065006E006300720079007000740069006F006E00200063006F00640065000D000A002D002D00200032003000310033002D00300036002D003000350020003A0020004400610076006900640040004D0069006C0079006C0069002E0063006F006D0020003A00200061006400640065006400200073007500700070006F0072007400200066006F007200200061002000740069006D0065007A006F006E00650020006F00660066007300650074000D000A002D002D0020003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D003D000D000A004300520045004100540045002000500052004F0043004500440055005200450020005B006500640064007300640062006F005D002E005B004C006F0061006400420049005300530075006D006D006100720079005D000D000A0009004000500072006F0063006500730073004500780065006300440061007400650020004400610074006500540069006D0065002C0020000D000A0009004000540069006D0065005A006F006E0065004F0066006600730065007400200069006E0074000D000A00410053000D000A0042004500470049004E000D000A00090053004500540020004E004F0043004F0055004E00540020004F004E003B000D000A000D000A0009004400450043004C004100520045002000400070007700640020004E005600610072006300680061007200280031003000300029000D000A0009005300450054002000400070007700640020003D00200027006B004300750072006100500061007300730077006F00720064003100210027000D000A000D000A00090073006500740020004000540069006D0065005A006F006E0065004F0066006600730065007400200020003D0020004400410054004500440049004600460028004D0049004E005500540045002C0020004700450054005500540043004400410054004500280029002C002000470045005400440041005400450028002900290020002A0020002D0031000D000A0009000D000A0009004400650063006C0061007200650020004000530075006D006D006100720079004D00650061007300750072006500440061007400650020004400610074006500540069006D0065000D000A0009004400650063006C00610072006500200040004D006500610073007500720065004400610074006500200044006100740065000D000A0009000D000A000900530065006C00650063007400200040004D00650061007300750072006500440061007400650020003D002000430061007300740028004000500072006F006300650073007300450078006500630044006100740065002000610073002000440061007400650029000D000A000900730065007400200040004D00650061007300750072006500440061007400650020003D0020004400410054004500410044004400280048004F00550052002C002000440041005400450044004900460046002800480048002C00200030002C002000440041005400450041004400440028004D0049004E005500540045002C0020004000540069006D0065005A006F006E0065004F00660066007300650074002C00200040004D0065006100730075007200650044006100740065002900290020002C00300029000D000A000900530065006C0065006300740020004000530075006D006D006100720079004D00650061007300750072006500440061007400650020003D00200040004D0065006100730075007200650044006100740065000D000A000D000A0009002D002D00420049005300530075006D006D0061007200790020006400610074006100200069007300200061006C0072006500610064007900200063006F006E00760065007200740065006400200074006F0020006C006F00630061006C002000740069006D0065000D000A0009004900460020004500580049005300540053002800530065006C00650063007400200031002000460072006F006D0020006500640064007300640062006F002E00420049005300530075006D006D0061007200790020005700680065007200650020004D00650061007300750072006500440061007400650020003D0020004000530075006D006D006100720079004D00650061007300750072006500440061007400650029000D000A00090042004500470049004E0020000D000A000900200020002D002D004500780069007300740069006E00670020006400610074006100200066006F0072002000740068006500200064006100740065002C002000720075006E00200061006E0020007500700064006100740065000D000A0009002000200042004500470049004E0020005400520041004E000D000A00090009005500500044004100540045002000420049005300530075006D006D006100720079000D000A000900090053004500540020005400510043006F0075006E00740020003D00200043004F0041004C00450053004300450028004C0043002E005400510043006F0075006E0074002C00300029002C000D000A0009000900090054006F00740061006C004E005200510043006F0075006E00740020003D00200043004F0041004C00450053004300450028004C0043002E0054006F00740061006C004E005200510043006F0075006E0074002C002000300029002C000D000A000900090009004E0052004C005200510043006F0075006E00740020003D00200043004F0041004C00450053004300450028004C0043002E004E0052004C005200510043006F0075006E0074002C00300029000D000A0009000900460052004F004D000D000A000900090009006500640064007300640062006F002E00420049005300530075006D006D006100720079002000420053000D000A000900090009004C0065006600740020004A006F0069006E0020002800530065006C006500630074002000430061007300650041007200740069006600610063007400490044002C002000530055004D00280054006F00740061006C00510043006F0075006E007400290020005400510043006F0075006E0074002C002000530055004D00280054006F00740061006C004E005200510043006F0075006E0074002900200054006F00740061006C004E005200510043006F0075006E0074002C002000530055004D0028004C005200510043006F0075006E007400290020004C005200510043006F0075006E0074002C002000530055004D0028004E0052004C005200510043006F0075006E007400290020004E0052004C005200510043006F0075006E0074002000200020000D000A00090009000900460072006F006D0020006500640064007300640062006F002E004C005200510043006F0075006E0074004400570020007700680065007200650020004400410054004500410044004400280048004F00550052002C002000440041005400450044004900460046002800480048002C00200030002C002000440041005400450041004400440028004D0049004E005500540045002C0020004000540069006D0065005A006F006E0065004F00660066007300650074002C0020004D0065006100730075007200650044006100740065002900290020002C003000290020003D00200040004D0065006100730075007200650044006100740065002000470072006F0075007000200042007900200043006100730065004100720074006900660061006300740049004400290020004C0043000D000A000900090009004F006E002000420053002E004300610073006500410072007400690066006100630074004900440020003D0020004C0043002E004300610073006500410072007400690066006100630074004900440020000D000A0009000900090041004E0044002000420053002E004D00650061007300750072006500440061007400650020003D00200040004D0065006100730075007200650044006100740065000900090009000D000A0009002000200043004F004D004D004900540020005400520041004E0020000D000A000D000A00090045004E0044000D000A000D000A00090045004C00530045000D000A000D000A00090042004500470049004E000D000A00090020002000200020002D002D004E006500770020006400610079002C00200073006F00200064006F00200061006E00200069006E0069007400690061006C00200069006E0073006500720074000D000A000900090042004500470049004E0020005400520041004E000D000A00200009000900090049004E0053004500520054002000420049005300530075006D006D006100720079002000280043007200650061007400650064004F006E002C002000430061007300650041007200740069006600610063007400490044002C0020004D0065006100730075007200650044006100740065002C0020005400510043006F0075006E0074002C00200054006F00740061006C004E005200510043006F0075006E0074002C0020004E0052004C005200510043006F0075006E0074002C0020005300740061007400750073004400610079002C0020005300740061007400750073003900300044006100790073002C002000530074006100740075007300500065007200630065006E0074006100670065004E0052004C00520051004400610079002C002000530074006100740075007300500065007200630065006E0074006100670065004E0052004C005200510039003000440061007900730029000D000A00090009000900530045004C0045004300540020000D000A000900090009000900470065007400550054004300440061007400650028002900200043007200650061007400650064004F006E002C0020000D000A00090009000900090043002E0041007200740069006600610063007400490044002000430061007300650041007200740069006600610063007400490044002C00200009000D000A0009000900090009004000530075006D006D006100720079004D00650061007300750072006500440061007400650020004D0065006100730075007200650044006100740065002C0020000D000A00090009000900090043004F0041004C00450053004300450028004C0043002E005400510043006F0075006E0074002C003000290020005400510043006F0075006E0074002C0020000D000A00090009000900200020002000200043004F0041004C00450053004300450028004C0043002E0054006F00740061006C004E005200510043006F0075006E0074002C00200030002900200054006F00740061006C004E005200510043006F0075006E0074002C000D000A00090009000900090043004F0041004C00450053004300450028004C0043002E004E0052004C005200510043006F0075006E0074002C003000290020004E0052004C005200510043006F0075006E0074002C0020000D000A00090009000900090045006E0063007200790070007400420079005000610073007300500068007200610073006500280040007000770064002C004E0027002D00310027002C0031002C0043004F004E00560045005200540028002000760061007200620069006E006100720079002C0020004000530075006D006D006100720079004D0065006100730075007200650044006100740065002900290020005300740061007400750073004400610079002C000D000A00090009000900090045006E0063007200790070007400420079005000610073007300500068007200610073006500280040007000770064002C004E0027002D00310027002C0031002C0043004F004E00560045005200540028002000760061007200620069006E006100720079002C0020004000530075006D006D006100720079004D0065006100730075007200650044006100740065002900290020005300740061007400750073003900300044006100790073002C000D000A0009000900090009002D00310020002000530074006100740075007300500065007200630065006E0074006100670065004E0052004C00520051004400610079002C000D000A0009000900090009002D0031002000530074006100740075007300500065007200630065006E0074006100670065004E0052004C00520051003900300044006100790073000D000A00090009000900460072006F006D000D000A000900090009002000200045004400440053002E006500640064007300640062006F002E005B0043006100730065005D00200043000D000A000900090009004C0065006600740020004A006F0069006E0020002800530065006C006500630074002000430061007300650041007200740069006600610063007400490044002C002000530055004D00280054006F00740061006C00510043006F0075006E007400290020005400510043006F0075006E0074002C002000530055004D00280054006F00740061006C004E005200510043006F0075006E0074002900200054006F00740061006C004E005200510043006F0075006E0074002C002000530055004D0028004C005200510043006F0075006E007400290020004C005200510043006F0075006E0074002C002000530055004D0028004E0052004C005200510043006F0075006E007400290020004E0052004C005200510043006F0075006E0074002000200020000D000A00090009000900460072006F006D0020006500640064007300640062006F002E004C005200510043006F0075006E0074004400570020000D000A000900090009005700680065007200650020004400410054004500410044004400280048004F00550052002C002000440041005400450044004900460046002800480048002C00200030002C002000440041005400450041004400440028004D0049004E005500540045002C0020004000540069006D0065005A006F006E0065004F00660066007300650074002C0020004D0065006100730075007200650044006100740065002900290020002C003000290020003D00200040004D0065006100730075007200650044006100740065002000470072006F0075007000200042007900200043006100730065004100720074006900660061006300740049004400290020004C0043000D000A000900090009004F006E00200043002E00410072007400690066006100630074004900440020003D0020004C0043002E00430061007300650041007200740069006600610063007400490044000D000A000D000A000900090043004F004D004D004900540020005400520041004E000D000A00090045004E0044000D000A0045004E0044000D000A00
EXEC (@_)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[eddsdbo].[GetBISHealthData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [eddsdbo].[GetBISHealthData]
GO
DECLARE @_ AS VARBINARY(MAX)
SET @_ = 0x0D000A004300520045004100540045002000500052004F0043004500440055005200450020005B006500640064007300640062006F005D002E005B004700650074004200490053004800650061006C007400680044006100740061005D000D000A0028000D000A000900400057006F0072006B007300700061006300650049006400200069006E0074002C000D000A000900400053007400610072007400440061007400650009004400410054004500540049004D00450020003D0020004E0055004C004C002C000D000A000900400045006E006400440061007400650009004400410054004500540049004D00450020003D0020004E0055004C004C002C000D000A0009004000540069006D0065005A006F006E0065004F0066006600730065007400200069006E0074000D000A0029000D000A005700490054004800200045004E004300520059005000540049004F004E00200020000D000A00410053000D000A0042004500470049004E000D000A00090053004500540020004E004F0043004F0055004E00540020004F004E003B000D000A0009004400450043004C004100520045002000400070007700640020004E005600610072006300680061007200280031003000300029000D000A0009005300450054002000400070007700640020003D00200027006B004300750072006100500061007300730077006F00720064003100210027000D000A0009004900460020002800400053007400610072007400440061007400650020004900530020004E0055004C004C00200041004E0044002000400045006E006400440061007400650020004900530020004E0055004C004C0029000D000A000900090042004500470049004E000D000A00090009000900530045004C004500430054002000400053007400610072007400440061007400650020003D00200044004100540045004100440044002800480048002C002D00320033002C004400410054004500410044004400280048004F00550052002C002000440041005400450044004900460046002800480048002C00200030002C002000440041005400450041004400440028004D0049004E005500540045002C0020004000540069006D0065005A006F006E0065004F00660066007300650074002C0020004700450054005500540043004400410054004500280029002900290020002C0030002900290009000900090009000D000A000900090009005300450054002000400045006E006400440061007400650020003D00200040005300740061007200740044006100740065000900090009000D000A000900090045004E0044000D000A0009000D000A000900530045004C004500430054000D000A000900090052004F0057005F004E0055004D004200450052002800290020004F0056004500520028004F0052004400450052002000420059002000570053002E00430061007300650041007200740069006600610063007400490044002C002000440052002E004400610074006500520061006E00670065002900200041005300200049006400090009000900090009000900090009000D000A00090009002C002000570053002E00430061007300650041007200740069006600610063007400490044002000610073002000430061007300650041007200740069006600610063007400490044000D000A00090009002C002000570053002E0057006F0072006B00730070006100630065004E0061006D006500200061007300200057006F0072006B00730070006100630065004E0061006D0065000900090009000900090009000D000A00090009002C002000440052002E004400610074006500520061006E006700650020006100730020004D0065006100730075007200650044006100740065000D000A00090009002C002000490053004E0055004C004C002800500053002E0042004900530049006E00640069006300610074006F0072002C0030002900200041005300200042004900530049006E00640069006300610074006F0072000D000A000900460052004F004D0020000D000A00090009005B006500640064007300640062006F005D002E004700650074004400610074006500520061006E0067006500280040005300740061007200740044006100740065002C002000400045006E0064004400610074006500290020004400520020000D000A0009000900430052004F005300530020004A004F0049004E0020000D000A000900090028000D000A00090009000900530045004C004500430054002000440049005300540049004E004300540020000D000A00090009000900090077002E00430061007300650041007200740069006600610063007400490044000D000A0009000900090009002C0077002E0057006F0072006B00730070006100630065004E0061006D0065000D000A00090009000900460052004F004D0020000D000A0009000900090009006500640064007300640062006F002E00450044004400530057006F0072006B00730070006100630065002000770020000D000A00090009000900570048004500520045000D000A00090009000900090077002E004300610073006500410072007400690066006100630074004900440020003D002000400057006F0072006B0073007000610063006500490064000D000A00090009002900200041005300200057005300090009000D000A00090009004C0045004600540020004A004F0049004E0020000D000A000900090028000D000A00090009000900530045004C0045004300540020000D000A000900090009000900420053002E00430061007300650041007200740069006600610063007400490044000D000A0009000900090009002C0020004D00650061007300750072006500440061007400650020004100530020005B004D0065006100730075007200650044006100740065005D000D000A0009000900090009002C00200043006F006E007600650072007400280069006E0074002C000D000A00090009000900090009002000200043006F006E00760065007200740028006E00760061007200630068006100720028006D006100780029002C0020000D000A000900090009000900090009004400650063007200790070007400420079005000610073007300500068007200610073006500280040007000770064002C0020000D000A00090009000900090009000900090043004F004E00560045005200540028006E00760061007200630068006100720028006D006100780029002C00420053002E0053007400610074007500730044006100790029002C0020000D000A00090009000900090009000900090031002C0020000D000A00090009000900090009000900090043004F004E00560045005200540028002000760061007200620069006E006100720079002C0020004D00650061007300750072006500440061007400650029000D000A0009000900090009000900090029000D000A000900090009000900090029000D000A00090009000900090020002000290020004100530020005B0042004900530049006E00640069006300610074006F0072005D000D000A00090009000900460052004F004D0020000D000A0009000900090009006500640064007300640062006F002E00420049005300530075006D006D006100720079002000420053000D000A000900090009005700480045005200450020000D000A0009000900090009004D00650061007300750072006500440061007400650020003E003D0020002000400053007400610072007400440061007400650020000D000A00090009000900090041004E00440020004D00650061007300750072006500440061007400650020003C0020002800400045006E006400440061007400650020002B002000310029000D000A00090009000900090041004E0044002000420053002E004300610073006500410072007400690066006100630074004900440020003D002000400057006F0072006B0073007000610063006500490064000D000A0009000900290020004100530020005000530020006F006E002000500053002E004D00650061007300750072006500440061007400650020003D002000640072002E004400610074006500520061006E006700650020000D000A000900090041004E0044002000570053002E004300610073006500410072007400690066006100630074004900440020003D002000500053002E00430061007300650041007200740069006600610063007400490044000D000A0045004E0044000D000A000D000A000D000A00
EXEC (@_)
GO