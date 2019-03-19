CREATE TABLE [dbo].[CourseAttendees] (
	[CourseId]                INT           NOT NULL,
	[AttendeeId]               INT           NOT NULL,
	[CourseResultId]                INT           NULL,
	[LicenseNumber]             VARCHAR (50)  NULL,
	[LicenseReleaseDate]             DATETIME      NULL,
	[LicenseReleasedBy]              VARCHAR (100) NULL,

	/*Again, these should be custom attributes*/
	[I]                         BIT           NULL,
	[A]                         BIT           NULL,
	[B]                         BIT           NULL,
	[C]                         BIT           NULL,
	[D]                         BIT           NULL,
	[E]                         BIT           NULL,
	[W1]                        BIT           NULL,
	[W2]                        BIT           NULL,
	[G]                         BIT           NULL,
	[II]                        BIT           NULL,
	[Z]                         BIT           NULL,
	[C_BezVodickehoOpravnenia]  BIT           NULL,
	[W1_BezVodickehoOpravnenia] BIT           NULL,
	[Z_PocetHodin]              FLOAT (53)    NULL,
	[F]                         BIT           NULL,
	CONSTRAINT [PK_CourseAttendees] PRIMARY KEY CLUSTERED ([CourseId] ASC, [AttendeeId] ASC),
	CONSTRAINT [FK_CourseAttendee_Attendee] FOREIGN KEY ([AttendeeId]) REFERENCES [dbo].[Attendees] (Id),
	CONSTRAINT [FK_CourseAttendee_Course] FOREIGN KEY ([CourseId]) REFERENCES [dbo].[Courses] ([Id]),
	CONSTRAINT [FK_CourseAttendee_CourseResult] FOREIGN KEY ([CourseResultId]) REFERENCES [dbo].[CourseResults] ([Id])
);

