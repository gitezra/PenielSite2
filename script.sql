--USE [Peniel2]
GO
/****** Object:  UserDefinedFunction [dbo].[getVideoIdOfLanguage]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Immanuel Ulmer
-- Create date: 
-- select dbo.getVideoIdOfLanguage(300,'en')
-- select dbo.getVideoIdOfLanguage(300,'ru')
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[getVideoIdOfLanguage] 
(
	-- Add the parameters for the function here
	@sermonId int,
	@lang nvarchar(2)
)
RETURNS nvarchar(11)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @videoIdOfLanguage nvarchar(11)

	-- Add the T-SQL statements to compute the return value here
	SELECT @videoIdOfLanguage = VideoId
	from SermonsByLanguages
	where sermonID = @sermonId
	and [Language] = @lang

	-- Return the result of the function
	RETURN @videoIdOfLanguage

END
GO
/****** Object:  Table [dbo].[FilesContent]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FilesContent](
	[fileContent] [int] NOT NULL,
	[contentName] [nvarchar](20) NULL,
 CONSTRAINT [PK_FilesContent] PRIMARY KEY CLUSTERED 
(
	[fileContent] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FilesContentByLanguage]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FilesContentByLanguage](
	[fileContent] [int] NOT NULL,
	[language] [nvarchar](2) NOT NULL,
	[contentName] [nvarchar](20) NULL,
 CONSTRAINT [PK_FilesContentByLanguage] PRIMARY KEY CLUSTERED 
(
	[fileContent] ASC,
	[language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Languages]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Languages](
	[language] [nvarchar](2) NOT NULL,
	[languageName] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Languages] PRIMARY KEY CLUSTERED 
(
	[language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mediaTypes]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mediaTypes](
	[mediaTypeCode] [nvarchar](2) NOT NULL,
	[mediaName] [nvarchar](20) NULL,
 CONSTRAINT [PK_mediaTypes] PRIMARY KEY CLUSTERED 
(
	[mediaTypeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[playLists]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[playLists](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NULL,
 CONSTRAINT [PK_playLists] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[playListsByLanguage]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[playListsByLanguage](
	[playListID] [int] NOT NULL,
	[language] [nvarchar](2) NOT NULL,
	[name] [nvarchar](100) NULL,
 CONSTRAINT [PK_playListByLanguage] PRIMARY KEY CLUSTERED 
(
	[playListID] ASC,
	[language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[playListsDetails]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[playListsDetails](
	[playListID] [int] NOT NULL,
	[sermonID] [int] NOT NULL,
	[language] [nvarchar](2) NOT NULL,
	[idx] [int] NOT NULL,
 CONSTRAINT [PK_PlaylistDetails] PRIMARY KEY CLUSTERED 
(
	[playListID] ASC,
	[sermonID] ASC,
	[language] ASC,
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sermonFiles]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sermonFiles](
	[sermonId] [int] NOT NULL,
	[fileContent] [int] NOT NULL,
	[idx] [int] NOT NULL,
	[sermonDate] [datetime] NULL,
	[mp3File] [nvarchar](100) NULL,
	[speakerLang] [nvarchar](2) NULL,
	[translatedLang] [nvarchar](2) NULL,
 CONSTRAINT [PK_sermonFiles] PRIMARY KEY CLUSTERED 
(
	[sermonId] ASC,
	[fileContent] ASC,
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SermonGroups]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SermonGroups](
	[GroupId] [int] NOT NULL,
	[language] [nvarchar](2) NOT NULL,
	[GroupName] [nvarchar](100) NULL,
 CONSTRAINT [PK_SermonGroups] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC,
	[language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sermons]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sermons](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](100) NOT NULL,
	[SermonDate] [datetime] NULL,
	[speakerLanguage] [nvarchar](2) NULL,
	[SermonType] [nvarchar](2) NOT NULL,
	[SpeakerId] [int] NULL,
	[videoId] [nvarchar](11) NULL,
	[img] [nvarchar](100) NULL,
 CONSTRAINT [PK_Sermons] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SermonsByGroup]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SermonsByGroup](
	[sermonId] [int] NOT NULL,
	[groupId] [int] NOT NULL,
 CONSTRAINT [PK_SermonsByGroup] PRIMARY KEY CLUSTERED 
(
	[sermonId] ASC,
	[groupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SermonsByLanguages]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SermonsByLanguages](
	[sermonID] [int] NOT NULL,
	[Language] [nvarchar](2) NOT NULL,
	[VideoId] [nvarchar](11) NULL,
	[Title] [nvarchar](100) NULL,
	[YoutubeVideo] [bit] NOT NULL,
	[Reading] [bit] NOT NULL,
	[reading_html] [nvarchar](max) NULL,
	[audioFile] [nvarchar](100) NULL,
 CONSTRAINT [PK_SermonsByLanguages] PRIMARY KEY CLUSTERED 
(
	[sermonID] ASC,
	[Language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SermonsByMediaTypes]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SermonsByMediaTypes](
	[sermonId] [int] NOT NULL,
	[language] [nvarchar](2) NOT NULL,
	[mediaTypeCode] [nvarchar](2) NOT NULL,
 CONSTRAINT [PK_SermonsByMediaType] PRIMARY KEY CLUSTERED 
(
	[sermonId] ASC,
	[language] ASC,
	[mediaTypeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SermonsImportedFromYoutube]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SermonsImportedFromYoutube](
	[Title] [nvarchar](255) NULL,
	[ID] [nvarchar](255) NULL,
	[URL] [nvarchar](255) NULL,
	[Language] [nvarchar](255) NULL,
	[row_num] [float] NULL,
	[VideoId] [nvarchar](255) NULL,
	[Thumpnail] [nvarchar](255) NULL,
	[Group] [nvarchar](255) NULL,
	[Group2] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SermonsReading]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SermonsReading](
	[sermonID] [int] NOT NULL,
	[Language] [nvarchar](2) NOT NULL,
	[reading_html] [nvarchar](max) NULL,
	[Opening] [nvarchar](700) NULL,
 CONSTRAINT [PK_SermonsReading] PRIMARY KEY CLUSTERED 
(
	[sermonID] ASC,
	[Language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SermonTypes]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SermonTypes](
	[TypeCode] [nvarchar](2) NOT NULL,
	[TypeName] [nvarchar](20) NULL,
 CONSTRAINT [PK_SermonTypes] PRIMARY KEY CLUSTERED 
(
	[TypeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Speakers]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Speakers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[speakerName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Speakers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpeakersByLanguages]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpeakersByLanguages](
	[Id] [int] NOT NULL,
	[language] [nvarchar](2) NOT NULL,
	[speakerName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_SpeakersByLanguages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SermonsByLanguages] ADD  CONSTRAINT [DF_SermonsByLanguages_Video]  DEFAULT ((1)) FOR [YoutubeVideo]
GO
ALTER TABLE [dbo].[SermonsByLanguages] ADD  CONSTRAINT [DF_SermonsByLanguages_Reading]  DEFAULT ((0)) FOR [Reading]
GO
ALTER TABLE [dbo].[FilesContentByLanguage]  WITH CHECK ADD  CONSTRAINT [FK_FilesContentByLanguage_FilesContent] FOREIGN KEY([fileContent])
REFERENCES [dbo].[FilesContent] ([fileContent])
GO
ALTER TABLE [dbo].[FilesContentByLanguage] CHECK CONSTRAINT [FK_FilesContentByLanguage_FilesContent]
GO
ALTER TABLE [dbo].[FilesContentByLanguage]  WITH CHECK ADD  CONSTRAINT [FK_FilesContentByLanguage_Languages] FOREIGN KEY([language])
REFERENCES [dbo].[Languages] ([language])
GO
ALTER TABLE [dbo].[FilesContentByLanguage] CHECK CONSTRAINT [FK_FilesContentByLanguage_Languages]
GO
ALTER TABLE [dbo].[playListsByLanguage]  WITH CHECK ADD  CONSTRAINT [FK_playListsByLanguage_Languages] FOREIGN KEY([language])
REFERENCES [dbo].[Languages] ([language])
GO
ALTER TABLE [dbo].[playListsByLanguage] CHECK CONSTRAINT [FK_playListsByLanguage_Languages]
GO
ALTER TABLE [dbo].[playListsByLanguage]  WITH CHECK ADD  CONSTRAINT [FK_playListsByLanguage_playLists] FOREIGN KEY([playListID])
REFERENCES [dbo].[playLists] ([Id])
GO
ALTER TABLE [dbo].[playListsByLanguage] CHECK CONSTRAINT [FK_playListsByLanguage_playLists]
GO
ALTER TABLE [dbo].[playListsDetails]  WITH CHECK ADD  CONSTRAINT [FK_playListsDetails_playListsByLanguage] FOREIGN KEY([playListID], [language])
REFERENCES [dbo].[playListsByLanguage] ([playListID], [language])
GO
ALTER TABLE [dbo].[playListsDetails] CHECK CONSTRAINT [FK_playListsDetails_playListsByLanguage]
GO
ALTER TABLE [dbo].[playListsDetails]  WITH CHECK ADD  CONSTRAINT [FK_playListsDetails_SermonsByLanguages] FOREIGN KEY([sermonID], [language])
REFERENCES [dbo].[SermonsByLanguages] ([sermonID], [Language])
GO
ALTER TABLE [dbo].[playListsDetails] CHECK CONSTRAINT [FK_playListsDetails_SermonsByLanguages]
GO
ALTER TABLE [dbo].[sermonFiles]  WITH CHECK ADD  CONSTRAINT [FK_sermonFiles_filesContent] FOREIGN KEY([fileContent])
REFERENCES [dbo].[FilesContent] ([fileContent])
GO
ALTER TABLE [dbo].[sermonFiles] CHECK CONSTRAINT [FK_sermonFiles_filesContent]
GO
ALTER TABLE [dbo].[sermonFiles]  WITH CHECK ADD  CONSTRAINT [FK_sermonFiles_Languages] FOREIGN KEY([speakerLang])
REFERENCES [dbo].[Languages] ([language])
GO
ALTER TABLE [dbo].[sermonFiles] CHECK CONSTRAINT [FK_sermonFiles_Languages]
GO
ALTER TABLE [dbo].[sermonFiles]  WITH CHECK ADD  CONSTRAINT [FK_sermonFiles_Languages1] FOREIGN KEY([translatedLang])
REFERENCES [dbo].[Languages] ([language])
GO
ALTER TABLE [dbo].[sermonFiles] CHECK CONSTRAINT [FK_sermonFiles_Languages1]
GO
ALTER TABLE [dbo].[sermonFiles]  WITH CHECK ADD  CONSTRAINT [FK_sermonFiles_Sermons] FOREIGN KEY([sermonId])
REFERENCES [dbo].[Sermons] ([Id])
GO
ALTER TABLE [dbo].[sermonFiles] CHECK CONSTRAINT [FK_sermonFiles_Sermons]
GO
ALTER TABLE [dbo].[Sermons]  WITH CHECK ADD  CONSTRAINT [FK_Sermons_Languages] FOREIGN KEY([speakerLanguage])
REFERENCES [dbo].[Languages] ([language])
GO
ALTER TABLE [dbo].[Sermons] CHECK CONSTRAINT [FK_Sermons_Languages]
GO
ALTER TABLE [dbo].[Sermons]  WITH CHECK ADD  CONSTRAINT [FK_Sermons_Sermons] FOREIGN KEY([Id])
REFERENCES [dbo].[Sermons] ([Id])
GO
ALTER TABLE [dbo].[Sermons] CHECK CONSTRAINT [FK_Sermons_Sermons]
GO
ALTER TABLE [dbo].[Sermons]  WITH CHECK ADD  CONSTRAINT [FK_Sermons_SermonTypes] FOREIGN KEY([SermonType])
REFERENCES [dbo].[SermonTypes] ([TypeCode])
GO
ALTER TABLE [dbo].[Sermons] CHECK CONSTRAINT [FK_Sermons_SermonTypes]
GO
ALTER TABLE [dbo].[Sermons]  WITH CHECK ADD  CONSTRAINT [FK_Sermons_Speakers] FOREIGN KEY([SpeakerId])
REFERENCES [dbo].[Speakers] ([Id])
GO
ALTER TABLE [dbo].[Sermons] CHECK CONSTRAINT [FK_Sermons_Speakers]
GO
ALTER TABLE [dbo].[SermonsByMediaTypes]  WITH CHECK ADD  CONSTRAINT [FK_SermonsByMediaType_Sermons] FOREIGN KEY([sermonId])
REFERENCES [dbo].[Sermons] ([Id])
GO
ALTER TABLE [dbo].[SermonsByMediaTypes] CHECK CONSTRAINT [FK_SermonsByMediaType_Sermons]
GO
ALTER TABLE [dbo].[SermonsByMediaTypes]  WITH CHECK ADD  CONSTRAINT [FK_SermonsByMediaTypes_Languages] FOREIGN KEY([language])
REFERENCES [dbo].[Languages] ([language])
GO
ALTER TABLE [dbo].[SermonsByMediaTypes] CHECK CONSTRAINT [FK_SermonsByMediaTypes_Languages]
GO
ALTER TABLE [dbo].[SermonsByMediaTypes]  WITH CHECK ADD  CONSTRAINT [FK_SermonsByMediaTypes_mediaTypes] FOREIGN KEY([mediaTypeCode])
REFERENCES [dbo].[mediaTypes] ([mediaTypeCode])
GO
ALTER TABLE [dbo].[SermonsByMediaTypes] CHECK CONSTRAINT [FK_SermonsByMediaTypes_mediaTypes]
GO
ALTER TABLE [dbo].[SpeakersByLanguages]  WITH CHECK ADD  CONSTRAINT [FK_SpeakersByLanguages_Speakers] FOREIGN KEY([Id])
REFERENCES [dbo].[Speakers] ([Id])
GO
ALTER TABLE [dbo].[SpeakersByLanguages] CHECK CONSTRAINT [FK_SpeakersByLanguages_Speakers]
GO
ALTER TABLE [dbo].[SpeakersByLanguages]  WITH CHECK ADD  CONSTRAINT [FK_SpeakersByLanguages_SpeakersByLanguages] FOREIGN KEY([language])
REFERENCES [dbo].[Languages] ([language])
GO
ALTER TABLE [dbo].[SpeakersByLanguages] CHECK CONSTRAINT [FK_SpeakersByLanguages_SpeakersByLanguages]
GO
/****** Object:  StoredProcedure [dbo].[getAllSermonsInGroupsOfaSermon]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Immanuel Ulmer
-- Create date: 
-- exec getAllSermonsInGroupsOfaSermon 523, 'en', 'All' --, '1980/01/01', '2030/12/31'
-- exec getAllSermonsInGroupsOfaSermon '23nbhwqXdVM', 'en', 'Shabbat' --, '1980/01/01', '2030/12/31'
-- exec getAllSermonsInGroupsOfaSermon '23nbhwqXdVM', 'en', 'Daily' --, '1980/01/01', '2030/12/31'
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[getAllSermonsInGroupsOfaSermon] 
	-- Add the parameters for the stored procedure here
	@sermonId int,  
	@lang nvarchar(2) = 'en',
	@sermonType nvarchar(10)='All' --All, Daily, Shabbat
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 
	   sbl.sermonID
	  ,sbl.Title
      ,sbl.[Language]
      ,sbl.VideoId
      ,groups = STUFF((
		SELECT ', ' + GroupName 
		from SermonsByGroup sbg
		inner join SermonGroups sg 
			on sg.GroupId = sbg.groupId
			and sg.[language] = sbl.[language] 
		where sermonId = sbl.sermonId
		FOR XML PATH ('')),1,2,'')
      ,s.SermonDate
      ,s.SermonType
	  ,ISNull(spbl.speakerName, sp.speakerName) speakerName
	from [Peniel].[dbo].[SermonsByLanguages] sbl
	inner join Sermons s on s.Id = sbl.sermonID
	inner join Speakers sp on sp.Id = s.SpeakerId
	left outer join SpeakersByLanguages spbl 
						on  spbl.Id = s.SpeakerId
						and spbl.[language] = @lang
	where sbl.[Language] = @lang
	and sbl.sermonID in (select SermonId from [dbo].[SermonsByGroup] where GroupId in (select groupId from SermonsByGroup where sermonID = @sermonId))
	and (s.sermonType = @sermonType or @sermonType = 'All')
	--and convert(date,[sermonDate]) between @fromDate and @toDate  
	order by s.SermonDate, groups, s.SermonType

END
GO
/****** Object:  StoredProcedure [dbo].[getArticle]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Immanuel Ulmer
-- Create date: 
-- exec getArticle 577, 'en'
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[getArticle] 
	-- Add the parameters for the stored procedure here
	@sermonId int, 
	@language nvarchar(2) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT sr.sermonID
      ,sr.[Language]
	  ,sbl.Title
	  ,ISNull(spl.speakerName,sp.speakerName) speakerName
      ,sr.reading_html
	FROM SermonsReading sr
	inner join Sermons s on s.Id = sr.sermonID
	left outer join Speakers sp on sp.Id = s.SpeakerId
	left outer join SpeakersByLanguages spl 
						on spl.Id = s.SpeakerId
						and spl.language = sr.Language
	inner join SermonsByLanguages sbl 
						on sbl.sermonID = sr.sermonID
						and sbl.Language = sr.Language
	where sr.sermonID = @sermonId
	and sr.Language = @language

END
GO
/****** Object:  StoredProcedure [dbo].[getLastMessages]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Immanuel Ulmer
-- Create date:
-- exec getLastMessages 'en' 
-- exec getLastMessages 'ru' 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[getLastMessages] 
	-- Add the parameters for the stored procedure here
	@lang varchar(2) = 'en'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 7 
	   sbl.sermonID
	  ,sbl.[Title]
      ,sbl.[Language]
      ,sbl.[VideoId]
      ,groups = STUFF((
		SELECT ', ' + GroupName 
		from SermonsByGroup sbg
		inner join SermonGroups sg 
			on sg.GroupId = sbg.groupId
			and sg.[language] = sbl.[language] 
		where sermonId = sbl.sermonId
		FOR XML PATH ('')),1,2,'')
      ,s.[SermonDate]
      ,s.[SermonType]
	  ,ISNull(spbl.speakerName, sp.speakerName) speakerName
	from [SermonsByLanguages] sbl
	inner join Sermons s on s.Id = sbl.sermonID
	inner join Speakers sp on sp.Id = s.SpeakerId
	left outer join SpeakersByLanguages spbl 
					on  spbl.Id = s.SpeakerId
					and spbl.[language] = @lang
	where sbl.[Language] = @lang
	order by s.SermonDate desc

END
GO
/****** Object:  StoredProcedure [dbo].[getPlayList]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Immanuel Ulmer
-- Create date: 
-- exec getPlayList 1, 'en'
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[getPlayList] 
	-- Add the parameters for the stored procedure here
	@playListID int, 
	@lang nvarchar(2)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select plbl.[name] playListName, sbl.Title sermonTitle, pld.sermonId, pld.[language], sbl.VideoId, pld.idx, s.img
	from [dbo].[playListsByLanguage] plbl
	inner join [dbo].[playListsDetails] pld 
				on  pld.playListID = plbl.playListID
				and pld.[language] = plbl.[language]
	inner join [dbo].[SermonsByLanguages] sbl
				on  sbl.sermonID = pld.sermonID
				and sbl.[Language] = pld.[language]
	inner join [dbo].[Sermons] s on s.Id = pld.sermonID
	where plbl.playListID = @playListID
	and plbl.[language] = @lang
	order by pld.idx

END
GO
/****** Object:  StoredProcedure [dbo].[getSermonFiles]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Immanuel Ulmer
-- Create date: 
-- getSermonFiles 364,'en'
-- getSermonFiles 364,'de'
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[getSermonFiles] 
	-- Add the parameters for the stored procedure here
	@sermonId int, 
	@lang nvarchar(2)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ISNull(fcbl.contentName, fc.contentName) + 
		case sf.fileContent when 1 then  ' - ' + ISNull(sbl.Title,'')
						 when 2 then  ' - ' + convert(varchar,idx)
						 when 3 then '' end title
		,'mp3' + sf.mp3File mp3File
		,sf.sermonId
	FROM sermonFiles sf
	inner join FilesContent fc 
							on fc.fileContent = sf.fileContent
	inner join FilesContentByLanguage fcbl 
							on  fcbl.fileContent = sf.fileContent
							and fcbl.language = @lang
	left outer join  SermonsByLanguages sbl 
							on  sbl.sermonID = sf.sermonId
							and sbl.Language = @lang
							and sf.fileContent = 1
	where sf.sermonId = @sermonId
	and ((sf.speakerLang = @lang or sf.translatedLang = @lang) and (sf.fileContent = 1) or sf.fileContent <> 1) 

END
GO
/****** Object:  StoredProcedure [dbo].[getSermons]    Script Date: 12/13/2020 5:16:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Immanuel Ulmer
-- Create date: 
-- exec getSermons 'en',0, 'All', '1980/01/01', '2030/12/31'
-- exec getSermons 'ru',3, 'All', '1980/01/01', '2030/12/31'
-- exec getSermons 'en',0, 'All', '1980/01/01', '2030/12/31'
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[getSermons] 
	-- Add the parameters for the stored procedure here
	@lang nvarchar(2) = 'en',--'' All
	@groupId int, --0 = All 
	@sermonType nvarchar(10)='All', --All, d=Daily, S=Shabbat, A=Articles
	@fromDate date = '1980/01/01',
	@toDate date = '2099/01/01'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 
	   sbl.sermonID
	  ,sbl.Title
      ,sbl.[Language]
      ,sbl.VideoId
      ,groups = STUFF((
		SELECT ', ' + GroupName 
		from SermonsByGroup sbg
		inner join SermonGroups sg 
			on sg.GroupId = sbg.groupId
			and sg.[language] = sbl.[language] 
		where sermonId = sbl.sermonId
		FOR XML PATH ('')),1,2,'')
      ,s.SermonDate
      ,s.SermonType
	  ,ISNull(spbl.speakerName, sp.speakerName) speakerName
	  ,s.img
	  ,row_number() over (order by SermonDate desc) row_num
	  ,sr.opening
	from [Peniel].[dbo].[SermonsByLanguages] sbl
	inner join Sermons s on s.Id = sbl.sermonID
	inner join Speakers sp on sp.Id = s.SpeakerId
	left outer join SpeakersByLanguages spbl 
						on  spbl.Id = s.SpeakerId
						and spbl.[language] = @lang
	left outer join SermonsReading sr 
						on sr.sermonID = sbl.sermonID
						and sr.Language = sbl.Language
	where (sbl.[Language] = @lang or @lang = '')
	and (sbl.[sermonID] in (select sermonId from SermonsByGroup where groupId = @groupId) or @groupId = 0)
	and (s.[sermonType] = @sermonType or @sermonType = 'All')
	and (convert(date,s.[sermonDate]) between @fromDate and @toDate or s.sermonDate is null)
	order by s.SermonDate desc

END
GO
