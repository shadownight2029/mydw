USE [LuckyDraw_NewYearForTest]
GO
/****** Object:  StoredProcedure [dbo].[prc_TRN_Reserve_GetSummaryDataReport]    Script Date: 26/11/61 14:58:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arnon Potipussa
-- Create date: 16/10/2018
-- Description: Get Reserve data.
-- =============================================
ALTER PROCEDURE [dbo].[prc_TRN_Reserve_GetSummaryDataReport]
@workingAreaId int, 
@tableName varchar(100), 
@statusName varchar(100), 
@dateFrom datetime, 
@dateTo datetime,
@sortBy varchar(100),
@sortOrder varchar(100),
@start int,
@length int
AS
BEGIN
	DECLARE @COUNTROW int;
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @workingAreaId = 0
	BEGIN
	  SET @workingAreaId = NULL
	END 

	IF NULLIF(@sortBy,'') IS NULL
	BEGIN
	  SET @sortBy = 'Id'  
	END 

	IF NULLIF(@sortOrder,'') IS NULL
	BEGIN 
	  SET @sortOrder =  'asc' 
	END 

		SELECT @COUNTROW = COUNT(*)
		FROM [dbo].[tb_trn_ReserveTable] a
		LEFT JOIN [dbo].[tb_mas_WorkingArea] b on a.[WorkingArea] = b.[WorkingArea]
		WHERE 
			(NULLIF(@workingAreaId, '') IS NULL OR b.[Id] = @workingAreaId)  
			AND (NULLIF(@tableName, '') IS NULL OR a.[TableName] = @tableName)  
			AND (NULLIF(@statusName, '') IS NULL OR a.[ReserveStatusDescription] = @statusName)  
			AND a.[ModifyDate] BETWEEN ISNULL(@dateFrom, '') AND ISNULL(@dateTo, GETDATE())

		SELECT 
			 a.[Id]
			,a.[EmployeeID]
			,a.[FirstName]
			,a.[LastName]
			,b.[Id] AS [WorkingAreaID]
			,a.[WorkingArea]
			,a.[TableName]
			,a.[CreateDate]
			,a.[ModifyDate]
			,a.[ReserveStatus]
			,a.[ReserveStatusDescription]
			,@COUNTROW AS AllRow
		FROM [dbo].[tb_trn_ReserveTable] a
		LEFT JOIN [dbo].[tb_mas_WorkingArea] b on a.[WorkingArea] = b.[WorkingArea]
		WHERE 
			(NULLIF(@workingAreaId, '') IS NULL OR b.[Id] = @workingAreaId)  
			AND (NULLIF(@tableName, '') IS NULL OR a.[TableName] = @tableName)  
			AND (NULLIF(@statusName, '') IS NULL OR a.[ReserveStatusDescription] = @statusName)  
			AND a.[ModifyDate] BETWEEN ISNULL(@dateFrom, '') AND ISNULL(@dateTo, GETDATE())
		ORDER BY 
			CASE 
				WHEN @sortBy = 'Id' AND  @sortOrder = 'desc' THEN CONVERT(int, a.[Id]) END DESC, 
			CASE  
				WHEN @sortBy = 'EmployeeID' AND  @sortOrder = 'desc' THEN CONVERT(NVARCHAR(250), a.[EmployeeID]) END DESC,
			CASE   
				WHEN @sortBy = 'FirstName' AND  @sortOrder = 'desc' THEN CONVERT(NVARCHAR(250), a.[FirstName]) END DESC,
			CASE   
				WHEN @sortBy = 'LastName' AND  @sortOrder = 'desc' THEN CONVERT(NVARCHAR(250), a.[LastName]) END DESC,
			CASE   
				WHEN @sortBy = 'WorkingAreaID' AND  @sortOrder = 'desc' THEN CONVERT(NVARCHAR(250), b.[Id]) END DESC,
			CASE   
				WHEN @sortBy = 'WorkingArea' AND  @sortOrder = 'desc' THEN CONVERT(NVARCHAR(250), a.[WorkingArea]) END DESC,
			CASE   
				WHEN @sortBy = 'TableName' AND  @sortOrder = 'desc' THEN CONVERT(NVARCHAR(250), a.[TableName]) END DESC,
			CASE   
				WHEN @sortBy = 'CreateDate' AND  @sortOrder = 'desc' THEN CONVERT(NVARCHAR(50), a.[CreateDate], 121) END DESC,
			CASE   
				WHEN @sortBy = 'ModifyDate' AND  @sortOrder = 'desc' THEN CONVERT(NVARCHAR(50), a.[ModifyDate], 121) END DESC,
			CASE   
				WHEN @sortBy = 'ReserveStatus' AND  @sortOrder = 'desc' THEN CONVERT(NVARCHAR(250), a.[ReserveStatus]) END DESC,
			CASE   
				WHEN @sortBy = 'ReserveStatusDescription' AND  @sortOrder = 'desc' THEN CONVERT(NVARCHAR(250), a.[ReserveStatusDescription]) END DESC,
			CASE 
				WHEN @sortBy = 'Id' AND  @sortOrder = 'asc' THEN CONVERT(int, a.[Id]) END ASC, 
			CASE  
				WHEN @sortBy = 'EmployeeID' AND  @sortOrder = 'asc' THEN CONVERT(NVARCHAR(250), a.[EmployeeID]) END ASC,
			CASE   
				WHEN @sortBy = 'FirstName' AND  @sortOrder = 'asc' THEN CONVERT(NVARCHAR(250), a.[FirstName]) END ASC,
			CASE   
				WHEN @sortBy = 'LastName' AND  @sortOrder = 'asc' THEN CONVERT(NVARCHAR(250), a.[LastName]) END ASC,
			CASE   
				WHEN @sortBy = 'WorkingAreaID' AND  @sortOrder = 'asc' THEN CONVERT(int, b.[Id]) END ASC,
			CASE   
				WHEN @sortBy = 'WorkingArea' AND  @sortOrder = 'asc' THEN CONVERT(NVARCHAR(250), a.[WorkingArea]) END ASC,
			CASE   
				WHEN @sortBy = 'TableName' AND  @sortOrder = 'asc' THEN CONVERT(NVARCHAR(250), a.[TableName]) END ASC,
			CASE   
				WHEN @sortBy = 'CreateDate' AND  @sortOrder = 'asc' THEN CONVERT(NVARCHAR(50), a.[CreateDate], 121) END ASC,
			CASE   
				WHEN @sortBy = 'ModifyDate' AND  @sortOrder = 'asc' THEN CONVERT(NVARCHAR(50), a.[ModifyDate], 121) END ASC,
			CASE   
				WHEN @sortBy = 'ReserveStatus' AND  @sortOrder = 'asc' THEN CONVERT(NVARCHAR(250), a.[ReserveStatus]) END ASC,
			CASE   
				WHEN @sortBy = 'ReserveStatusDescription' AND  @sortOrder = 'asc' THEN CONVERT(NVARCHAR(250), a.[ReserveStatusDescription]) END ASC
		OFFSET @start  ROWS  FETCH NEXT @length ROWS ONLY
END

