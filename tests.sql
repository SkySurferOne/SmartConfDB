USE hanusiak_a;

DELETE FROM OrderedWorkshop;
DELETE FROM OrderedConfDay;
DELETE FROM [Order];
DELETE FROM CompanyClients;
DELETE FROM Employee;
DELETE FROM Company;
DELETE FROM PrivateClients;
DELETE FROM Clients;
DELETE FROM Participant;
DELETE FROM Discount; 
DELETE FROM Workshop;
DELETE FROM ConferenceDay;
DELETE FROM Conference;
DELETE FROM Category;

-- Add categories 
EXECUTE ADD_CATEGORY 'IT', 'information technology';
EXECUTE ADD_CATEGORY 'Programming', '';
EXECUTE ADD_CATEGORY 'Life style', 'Test';

-- Add conferences
EXECUTE ADD_CONFERENCE_2 'IT', 'TestConference', 'This is test conference',
'2017-06-18 10:34:09 AM', 'D³uga 3/10', 'Kraków', 'Polska';
EXECUTE ADD_CONFERENCE_2 'Programming', 'Test2Conf', 'Test2',
'20170719 10:34:09 AM', 'D³uga 4/10', 'Kraków', 'Polska';
EXECUTE ADD_CONFERENCE_2 'Life style', 'Test3Conf', 'Test3',
'20170818 10:34:09 AM', 'Polna 10', 'Rzeszów', 'Polska';

-- Add conference day
DECLARE @maxConfDaysPerConfNum int = 7;
	-- loop start 
	SELECT  TOP 1000 A.*, ROW_NUMBER() OVER(ORDER BY A.ConferenceID DESC) AS ROW
	INTO #TEMPTABLE 
	FROM Conference AS A;

	DECLARE @COUNTER INT = (SELECT MAX(ROW) FROM #TEMPTABLE);
	DECLARE @ROW INT;

	WHILE (@COUNTER != 0)
	BEGIN

		SELECT @ROW = ROW
		FROM #TEMPTABLE
		WHERE ROW = @COUNTER
		ORDER BY ROW DESC

			DECLARE @Id int = (SELECT TOP 1 ConferenceID FROM #TEMPTABLE WHERE ROW = @Row);
			DECLARE @price float = RAND()*12;
			DECLARE @placeLimit int = RAND()*@id+10;
			EXECUTE ADD_CONFERENCE_DAY @Id, @placeLimit, @price;

		SET @COUNTER = @ROW -1
	END

	DROP TABLE #TEMPTABLE
	-- loop end 

DECLARE @confId int = (SELECT TOP 1 ConferenceID FROM Conference);
EXECUTE ADD_CONFERENCE_DAY @confId, 20, 21;

-- company
EXECUTE ADD_COMPANY_CLIENT 'Brand Ro¿ek', '106-00-00-062', 'Rojalna 21',
'Kraków', 'Polska', '22-080', 'gggga@a.pl', 623456789;
EXECUTE ADD_COMPANY_CLIENT 'Hohland', '106-00-00-062', 'Mekka 51',
'Kraków', 'Polska', '92-080', 'affff@a.pl', 623456789;
EXECUTE ADD_COMPANY_CLIENT 'Color', '106-00-00-062', 'Fizja 1',
'Kraków', 'Polska', '32-080', 'aaaaa@a.pl', 623456789;

-- add employee
DECLARE @companyId int;
SET @companyID = (SELECT TOP 1 CompanyID FROM Company);
PRINT 'CompanyID:';
PRINT @companyId;

EXECUTE ADD_EMPLOYEE @companyId, 'Misia', 'Pysia', 'Piekielna 666', 'Piek³o', 'Polska',
'82-400', 'misia@gmail.com', '666666666';

-- add private participant
EXECUTE ADD_PRIVATE_PARTICIPANT 'Magda', 'Kowalska', 'Piekielna 666', 'Piek³o', 'Polska',
'82-400', 'magdak@gmail.com', '666333666';
EXECUTE ADD_PRIVATE_PARTICIPANT 'Jan', 'Mela', 'Pieknie', 'Piekniej', 'Polska',
'82-400', 'jankowalskinie@gmail.com', '666666666';
EXECUTE ADD_PRIVATE_PARTICIPANT 'Bartosz', 'Dydusz', 'Olsza 2', 'Wiecisto³y', 'Polska',
'82-400', 'asd@gmail.com', '661116666';

-- add discount
DECLARE @conferenceId int;
SET @conferenceId = (SELECT TOP 1 ConferenceID FROM Conference);
PRINT 'ConferenceID:';
PRINT @conferenceId;

EXECUTE add_discount @conferenceId, 10, '20120618 10:50:09 AM', 1;

-- add workshop
DECLARE @conferenceDayId int;
SET @conferenceDayId = (SELECT TOP 1 ConferenceDayID FROM ConferenceDay);

EXECUTE add_workshop @conferenceDayId, 100, '20120618 11:00:00 AM', '20120618 13:50:00 PM', 5.99, 'SQL - szczêœcie czy z³o wcielone',
'Na warsztacie dowiemy siê dlaczego powsta³y NOSQL i czy s¹ one lepsze od SQLów';

-- add order
DECLARE @clientId int;
SET @clientId = (SELECT TOP 1 ClientID FROM Clients);

EXECUTE add_order @clientId;

-- add ordered conference days
DECLARE @orderId int = (SELECT TOP 1 OrderID FROM [Order]);
PRINT 'OrderId:';
PRINT @orderId;
EXECUTE ADD_ORDERED_CONFERENCE_DAY @orderId, @conferenceDayId, 5;

-- add ordered workshops
DECLARE @OrderedConferenceDayID int = (SELECT OrderedConfDayID FROM OrderedConfDay);
DECLARE @workshopId int = (SELECT TOP 1 WorkshopID FROM Workshop);

EXECUTE ADD_ORDERED_WORKSHOP @OrderedConferenceDayID, @workshopId, 5;

SELECT 'Category' AS TableName, * FROM Category;
SELECT 'CompanyClients' AS TableName, * FROM CompanyClients;
SELECT 'Company' AS TableName, * FROM Company;
SELECT 'Clients' AS TableName, * FROM Clients;
SELECT 'Employee' AS TableName, * FROM Employee;
SELECT 'Participant' AS TableName, * FROM Participant;
SELECT 'PrivateClients' AS TableName, * FROM PrivateClients;
SELECT 'Conference' AS TableName, * FROM Conference;
SELECT 'ConferenceDay' AS TableName, * FROM ConferenceDay;
SELECT 'Discount' AS TableName, * FROM Discount;
SELECT 'Workshop' AS TableName, * FROM Workshop;
SELECT 'Order' AS TableName, * FROM [Order];
SELECT 'OrderedConfDay' AS TableName, * FROM OrderedConfDay;
SELECT 'OrderedWorkshop' AS TableName, * FROM OrderedWorkshop;
SELECT 'ConferenceDayParticipant' as TableName, * from ConferenceDayParticipant
SELECT 'WorkshopParticipant' as TableName, * from WorkshopParticipant
SELECT 'Reservation' AS TableName, * FROM Reservation;
SELECT 'ClientOrder' AS TableName, * FROM ClientOrder;

