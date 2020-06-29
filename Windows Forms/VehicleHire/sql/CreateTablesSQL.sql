USE [VehicleHire]
GO

/* DROP Admin Table */
DROP TABLE [dbo].[Admin]
GO

/* DROP Equipment Booking Table */
DROP TABLE [dbo].[EquipmentBooking]
GO

/* DROP Equipment Table */
DROP TABLE [dbo].[Equipment]
GO

/* DROP Vehicle Booking Table */
DROP TABLE [dbo].[VehicleBooking]
GO

/* DROP Customer Table */
DROP TABLE [dbo].[Customer]
GO

/* DROP Vehicle Table */
DROP TABLE [dbo].[Vehicle]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* CREATE Vehicle Table */
CREATE TABLE [dbo].[Vehicle](
	[VehicleId] [bigint] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](100) NOT NULL,
	[Engine] [varchar](10) NOT NULL,
	[Gearbox] [varchar](10) NOT NULL,
	[PricePerDay] [decimal](18, 2) NOT NULL,
	[NumberAvailable] [int] NOT NULL,
 CONSTRAINT [PK_Vehicle] PRIMARY KEY CLUSTERED 
(
	[VehicleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* CREATE Customer Table */
CREATE TABLE [dbo].[Customer](
	[Email] [varchar](254) NOT NULL,
	[Password] [varchar](128) NOT NULL,
	[DateOfBirth] [date] NOT NULL,
	[Blacklisted] [bit] NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* CREATE Vehicle Booking Table */
CREATE TABLE [dbo].[VehicleBooking](
	[VehicleBookingId] [bigint] IDENTITY(1,1) NOT NULL,
	[Email] [varchar](254) NOT NULL,
	[VehicleId] [bigint] NOT NULL,
	[StartDateTime] [datetime] NOT NULL,
	[EndDateTime] [datetime] NOT NULL,
	[TotalPrice] [decimal] (18, 2) NOT NULL,
	[Collected] [bit] NOT NULL,
 CONSTRAINT [PK_VehicleBooking] PRIMARY KEY CLUSTERED 
(
	[VehicleBookingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[VehicleBooking]  WITH CHECK ADD  CONSTRAINT [FK_VehicleBooking_Customer] FOREIGN KEY([Email])
REFERENCES [dbo].[Customer] ([Email])
GO

ALTER TABLE [dbo].[VehicleBooking] CHECK CONSTRAINT [FK_VehicleBooking_Customer]
GO

ALTER TABLE [dbo].[VehicleBooking]  WITH CHECK ADD  CONSTRAINT [FK_VehicleBooking_Vehicle] FOREIGN KEY([VehicleId])
REFERENCES [dbo].[Vehicle] ([VehicleId])
GO

ALTER TABLE [dbo].[VehicleBooking] CHECK CONSTRAINT [FK_VehicleBooking_Vehicle]
GO

/* CREATE Equipment Table */
CREATE TABLE [dbo].[Equipment](
	[EquipmentId] [bigint] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[Amount] [int] NOT NULL,
 CONSTRAINT [PK_Equipment] PRIMARY KEY CLUSTERED 
(
	[EquipmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* CREATE Equipment Booking Table */
CREATE TABLE [dbo].[EquipmentBooking](
	[EquipmentBookingId] [bigint] IDENTITY(1,1) NOT NULL,
	[VehicleBookingId] [bigint] NOT NULL,
	[EquipmentId] [bigint] NOT NULL,
 CONSTRAINT [PK_EquipmentBooking] PRIMARY KEY CLUSTERED 
(
	[EquipmentBookingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[EquipmentBooking]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentBooking_Equipment] FOREIGN KEY([EquipmentId])
REFERENCES [dbo].[Equipment] ([EquipmentId])
GO

ALTER TABLE [dbo].[EquipmentBooking] CHECK CONSTRAINT [FK_EquipmentBooking_Equipment]
GO

ALTER TABLE [dbo].[EquipmentBooking]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentBooking_VehicleBooking] FOREIGN KEY([VehicleBookingId])
REFERENCES [dbo].[VehicleBooking] ([VehicleBookingId])
GO

ALTER TABLE [dbo].[EquipmentBooking] CHECK CONSTRAINT [FK_EquipmentBooking_VehicleBooking]
GO

/* CREATE Admin Table */
CREATE TABLE [dbo].[Admin](
	[Username] [varchar](50) NOT NULL,
	[Password] [varchar](128) NOT NULL,
 CONSTRAINT [PK_Admin] PRIMARY KEY CLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* INSERT INTO Vehicle Table */
INSERT INTO [dbo].[Vehicle] ([Type], [Engine], [Gearbox], [PricePerDay], [NumberAvailable])
     VALUES
        ('Small Town Car', 'Petrol', 'Manual', '40.00', 1),
		('Small Town Car', 'Hybrid', 'Manual', '40.00', 1),
		('Small Family Hatchback', 'Diesel', 'Automatic', '55.00', 1),
		('Small Family Hatchback', 'Petrol', 'Manual', '55.00', 1),
		('Large Family Saloon', 'Petrol', 'Manual', '60.00', 1),
		('Large Family Estate', 'Petrol', 'Manual', '75.00', 1),
		('Medium Van', 'Petrol', 'Manual', '70.00', 1),
		('Medium Van', 'Petrol', 'Manual', '70.00', 1)
GO

/* INSERT INTO Customer Table */
INSERT INTO [dbo].[Customer] ([Email], [Password], [DateOfBirth], [Blacklisted])
     VALUES
		('customer1@gmail.com',
		'EE26B0DD4AF7E749AA1A8EE3C10AE9923F618980772E473F8819A5D4940E0DB27AC185F8A0E1D5F84F88BC887FD67B143732C304CC5FA9AD8E6F57F50028A8FF',
		'1999-05-01', 0),
		('customer2@gmail.com',
		'EE26B0DD4AF7E749AA1A8EE3C10AE9923F618980772E473F8819A5D4940E0DB27AC185F8A0E1D5F84F88BC887FD67B143732C304CC5FA9AD8E6F57F50028A8FF',
		'1980-04-07', 0),
		('customer3@gmail.com',
		'EE26B0DD4AF7E749AA1A8EE3C10AE9923F618980772E473F8819A5D4940E0DB27AC185F8A0E1D5F84F88BC887FD67B143732C304CC5FA9AD8E6F57F50028A8FF',
		'1981-02-15', 0)
GO

/* INSERT INTO Vehicle Booking Table */
INSERT INTO [dbo].[VehicleBooking] ([Email], [VehicleId], [StartDateTime], [EndDateTime], [TotalPrice], [Collected])
     VALUES
		('customer1@gmail.com', 1, '2020-05-11 08:00', '2020-05-13 18:00', '80.00', 0),
		('customer1@gmail.com', 2, '2020-05-16 08:00', '2020-05-21 18:00', '200.00', 0),
		('customer2@gmail.com', 1, '2020-05-14 08:00', '2020-05-15 18:00', '80.00', 0),
		('customer1@gmail.com', 1, '2020-06-14 08:00', '2020-06-15 18:00', '40.00', 0),
		('customer2@gmail.com', 2, '2020-06-24 08:00', '2020-06-28 18:00', '220.00', 0),
		('customer3@gmail.com', 4, '2020-05-21 08:00', '2020-05-21 13:00', '70.00', 0),
		('customer3@gmail.com', 3, '2020-05-15 08:00', '2020-05-15 18:00', '70.00', 0)
GO

/* INSERT INTO Equipment Table */
INSERT INTO [dbo].[Equipment] ([Type], [Amount])
     VALUES
		('SatNav', 1),
		('Baby Seat', 1),
		('Wine Chiller', 1)
GO

/* INSERT INTO Equipment Booking Table */
INSERT INTO [dbo].[EquipmentBooking] ([VehicleBookingId], [EquipmentId])
     VALUES
		(1, 1)
GO

/* INSERT INTO Admin Table */
INSERT INTO [dbo].[Admin] ([Username], [Password])
     VALUES
        ('admin', 'EE26B0DD4AF7E749AA1A8EE3C10AE9923F618980772E473F8819A5D4940E0DB27AC185F8A0E1D5F84F88BC887FD67B143732C304CC5FA9AD8E6F57F50028A8FF')
GO