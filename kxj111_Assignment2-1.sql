/*
* File: Assignment2_SubmissionTemplate.sql
* 
* 1) Rename this file according to the instructions in the assignment statement.
* 2) Use this file to insert your solution.
*
*
* Author: Jakubonis, Kristupas
* Student ID Number: 2279211
* Institutional mail prefix: kxj111
*/


/*
*  Assume a user account 'fsad' with password 'fsad2022' with permission
* to create  databases already exists. You do NO need to include the commands
* to create the user nor to give it permission in you solution.
* For your testing, the following command may be used:
*
* CREATE USER fsad PASSWORD 'fsad2022' CREATEDB;
* GRANT pg_read_server_files TO fsad;
*/


/* *********************************************************
* Exercise 1. Create the Smoked Trout database
* 
************************************************************ */

-- The first time you login to execute this file with \i it may
-- be convenient to change the working directory.
-- \cd '/home/kristupasj/Pictures/New Folder'
  -- In PostgreSQL, folders are identified with '/'

-- 1) Create a database called SmokedTrout.


CREATE DATABASE "SmokedTrout"
	WITH
    OWNER = fsad
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;

-- 2) Connect to the database
\c "SmokedTrout" fsad





/* *********************************************************
* Exercise 2. Implement the given design in the Smoked Trout database
* 
************************************************************ */

-- 1) Create a new ENUM type called materialState for storing the raw material state
CREATE TYPE "materialState" 
	AS ENUM 
    (
    'Solid',
    'Liquid',
    'Gas',
    'Plasma'
    );
-- 2) Create a new ENUM type called materialComposition for storing whether
-- a material is Fundamental or Composite.
CREATE TYPE "materialComposition" 
	AS ENUM 
    (
    'Fundamental',
    'Composite'
    );
-- 3) Create the table TradingRoute with the corresponding attributes.
CREATE TABLE "TradingRoute"
(
	"MonitoringKey" integer GENERATED ALWAYS AS IDENTITY NOT NULL,
	"FleetSize" integer,
	"OperatingCompany" varchar(50),
	"LastYearRevenue" real NOT NULL,
	PRIMARY KEY ("MonitoringKey")
);
-- 4) Create the table Planet with the corresponding attributes.
CREATE TABLE "Planet"
(
	"PlanetID" integer GENERATED ALWAYS AS IDENTITY NOT NULL,
	"StarSystem" varchar(50),
	"Name" varchar(50),
	"Population" integer,
	PRIMARY KEY ("PlanetID")
);
-- 5) Create the table SpaceStation with the corresponding attributes.
CREATE TABLE "SpaceStation"
(
	"StationID" integer GENERATED ALWAYS AS IDENTITY NOT NULL,
	"PlanetID" integer,
	"Name" varchar(50),
	"Longitude" varchar(50),
	"Latitude" varchar(50),

	CONSTRAINT fk_Planet  
		FOREIGN KEY("PlanetID")   
			REFERENCES "Planet"("PlanetID"),
	PRIMARY KEY ("StationID")
);
-- 6) Create the parent table Product with the corresponding attributes.
CREATE TABLE "Product"
(
	"ProductID" integer GENERATED ALWAYS AS IDENTITY NOT NULL,
	"Name" varchar(50),
	"VolumePerTon" real,
	"ValuePerTon" real,
	PRIMARY KEY ("ProductID")
);
-- 7) Create the child table RawMaterial with the corresponding attributes.
CREATE TABLE "RawMaterial"
(
	"FundamentalOrComposite" "materialComposition",
	"State" "materialState"

)INHERITS ("Product");
-- 8) Create the child table ManufacturedGood. 
CREATE TABLE "ManufacturedGood"
(
)INHERITS ("Product");
-- 9) Create the table MadeOf with the corresponding attributes.
CREATE TABLE "MadeOf"
(
	"ManufacturedGoodID" integer,
	"ProductID" integer
);

-- 10) Create the table Batch with the corresponding attributes.
CREATE TABLE "Batch"
(
	"BatchID" integer GENERATED ALWAYS AS IDENTITY NOT NULL,
	"ProductID" integer,
	"ExtractionOrManufacturingDate" date,
	"OriginalFrom" integer,



	CONSTRAINT fk_Planet  
		FOREIGN KEY("OriginalFrom")   
			REFERENCES "Planet"("PlanetID"),

	PRIMARY KEY ("BatchID")

);
-- 11) Create the table Sells with the corresponding attributes.
CREATE TABLE "Sells"
(

	"BatchID" integer,
	"StationID" integer,

	CONSTRAINT fk_SpaceStation  
		FOREIGN KEY("StationID")   
			REFERENCES "SpaceStation"("StationID"),
	CONSTRAINT fk_Batch  
		FOREIGN KEY("BatchID")   
			REFERENCES "Batch"("BatchID")

);
-- 12)  Create the table Buys with the corresponding attributes.
CREATE TABLE "Buys"
(
	"BatchID" integer,
	"StationID" integer,

	CONSTRAINT fk_SpaceStation  
		FOREIGN KEY("StationID")   
			REFERENCES "SpaceStation"("StationID"),
	CONSTRAINT fk_Batch  
		FOREIGN KEY("BatchID")   
			REFERENCES "Batch"("BatchID")
);
-- 13)  Create the table CallsAt with the corresponding attributes.
CREATE TABLE "CallsAt"
(
	"MonitoringKey" integer,
	"StationID" integer,
	"VisitOrder" integer,

	CONSTRAINT fk_TradingRoute  
		FOREIGN KEY("MonitoringKey")   
			REFERENCES "TradingRoute"("MonitoringKey"),

	CONSTRAINT fk_SpaceStation  
		FOREIGN KEY("StationID")   
			REFERENCES "SpaceStation"("StationID")

);
-- 14)  Create the table Distance with the corresponding attributes.
CREATE TABLE "Distance"
(
	"PlanetOrigin" integer,
		"PlanetDestination" integer,
			"Distance" real,

	CONSTRAINT fk_PlanetO  
		FOREIGN KEY("PlanetOrigin")   
			REFERENCES "Planet"("PlanetID"),

	CONSTRAINT fk_PlanetD 
		FOREIGN KEY("PlanetDestination")   
			REFERENCES "Planet"("PlanetID")

);

/* *********************************************************
* Exercise 3. Populate the Smoked Trout database
* 
************************************************************ */
/* *********************************************************
* NOTE: The copy statement is NOT standard SQL.
* The copy statement does NOT permit on-the-fly renaming columns,
* hence, whenever necessary, we:
* 1) Create a dummy table with the column name as in the file
* 2) Copy from the file to the dummy table
* 3) Copy from the dummy table to the real NOT NULL table
* 4) Drop the dummy table (This is done further below, as I keep
*    the dummy table also to imporrt the other columns)
************************************************************ */




-- 1) Unzip all the data files in a subfolder called data from where you have your code file 
-- NO CODE GOES HERE. THIS STEP IS JUST LEFT HERE TO KEEP CONSISTENCY WITH THE ASSIGNMENT STATEMENT
-- 2) Populate the table TradingRoute with the data in the file TradeRoutes.csv.
\COPY "TradingRoute" FROM './data/TradeRoutes.csv' WITH (FORMAT CSV, HEADER);

-- 3) Populate the table Planet with the data in the file Planets.csv.
\COPY "Planet" FROM './data/Planets.csv' WITH (FORMAT CSV, HEADER);

-- select * from "Planet"; 
-- 4) Populate the table SpaceStation with the data in the file SpaceStations.csv.
\COPY "SpaceStation" FROM './data/SpaceStations.csv' WITH (FORMAT CSV, HEADER);
-- select * from "SpaceStation"; 

-- 5) Populate the tables RawMaterial and Product with the data in the file Products_Raw.csv. 
CREATE TABLE "Dummy"
(
	"ProductID" integer GENERATED ALWAYS AS IDENTITY NOT NULL,
	"Product" varchar(50),
	"Composite" varchar(50),
	"VolumePerTon" real,
	"ValuePerTon" real,
	"State" "materialState");
\COPY "Dummy" FROM './data/Products_Raw.csv' WITH (FORMAT CSV, HEADER);

UPDATE "Dummy"
	SET "Composite" = 'Fundamental' 
		WHERE "Composite" = 'No';
UPDATE "Dummy"
	SET "Composite" = 'Composite' 
		WHERE "Composite" = 'Yes';



ALTER TABLE "Dummy" 
    ALTER COLUMN "Composite" 
		TYPE "materialComposition" USING "Composite"::"materialComposition";

INSERT INTO "RawMaterial" (
"ProductID", "Name", "VolumePerTon", "ValuePerTon", "FundamentalOrComposite", "State")
SELECT "ProductID", "Product", "VolumePerTon", "ValuePerTon", "Composite", "State"   FROM "Dummy";
DROP TABLE "Dummy";

-- 6) Populate the tables ManufacturedGood and Product with the data in the file  Products_Manufactured.csv.
 \COPY "ManufacturedGood" FROM './data/Products_Manufactured.csv' WITH (FORMAT CSV, HEADER);

-- 7) Populate the table MadeOf with the data in the file MadeOf.csv.
 \COPY "MadeOf" FROM './data/MadeOf.csv' WITH (FORMAT CSV, HEADER);

-- 8) Populate the table Batch with the data in the file Batches.csv.
 \COPY "Batch" FROM './data/Batches.csv' WITH (FORMAT CSV, HEADER);

-- 9) Populate the table Sells with the data in the file Sells.csv.
 \COPY "Sells" FROM './data/Sells.csv' WITH (FORMAT CSV, HEADER);

-- 10) Populate the table Buys with the data in the file Buys.csv.
 \COPY "Buys" FROM './data/Buys.csv' WITH (FORMAT CSV, HEADER);

-- 11) Populate the table CallsAt with the data in the file CallsAt.csv.
 \COPY "CallsAt" FROM './data/CallsAt.csv' WITH (FORMAT CSV, HEADER);

-- 12) Populate the table Distance with the data in the file PlanetDistances.csv.
 \COPY "Distance" FROM './data/PlanetDistances.csv' WITH (FORMAT CSV, HEADER);





/* *********************************************************
* Exercise 4. Query the database
* 
************************************************************ */

-- 4.1 Report last year taxes per company

-- 1) Add an attribute Taxes to table TradingRoute
ALTER TABLE "TradingRoute"
	ADD "Taxes" real;
-- 2) Set the derived attribute taxes as 12% of LastYearRevenue
UPDATE
  "TradingRoute"
SET
  "Taxes" = "LastYearRevenue" * 0.12;
-- 3) Report the operating company and the sum of its taxes group by company.

SELECT "OperatingCompany", SUM("Taxes") as "Taxes"
	FROM "TradingRoute"
		GROUP BY "OperatingCompany";




-- 4.2 What's the longest trading route in parsecs?

-- 1) Create a dummy table RouteLength to store the trading route and their lengths.
CREATE TABLE "RouteLength"
(
	"RouteMonitoringKey" integer,
	"RouteTotalDistance" real
);
-- 2) Create a view EnrichedCallsAt that brings together trading route, space stations and planets.
CREATE VIEW "EnrichedCallsAt"
AS  
    SELECT "CallsAt"."VisitOrder",
        "SpaceStation"."Name",
        "CallsAt"."MonitoringKey",
        "SpaceStation"."PlanetID" AS "Planet"
    FROM "CallsAt"
    INNER JOIN "SpaceStation"  
        ON "CallsAt"."StationID" = "SpaceStation"."StationID";
        


-- 3) Add the support to execute an anonymous code block as follows;
DO
$$
DECLARE
	"routeDistance" real NOT NULL:= 0.0;
	"hopDistance" real NOT NULL:= 0.0;
	"rRoute" record;
	"hopIteration" record;
	"query" text;
BEGIN
	FOR "rRoute" IN SELECT "MonitoringKey" FROM "TradingRoute"
	LOOP
		"query" := 'CREATE VIEW "PortsOfCall" AS '
						|| 'SELECT "Planet", "VisitOrder" '
						|| 'FROM "EnrichedCallsAt" '
						|| 'WHERE "MonitoringKey" = ' || "rRoute"."MonitoringKey"
						|| ' ORDER BY "VisitOrder"';
		EXECUTE "query";
		CREATE VIEW "Hops"
		AS  
		SELECT m."Planet" AS "PlanetOrigin",
			   e."Planet" AS "PlanetDestination" 
		FROM "PortsOfCall" e
			INNER JOIN "PortsOfCall" m ON e."VisitOrder" = m."VisitOrder" + 1;
		"routeDistance" := 0.0;
		FOR "hopIteration" IN SELECT "PlanetOrigin","PlanetDestination" FROM "Hops"
		LOOP

			"query" := 'CREATE OR REPLACE VIEW "DistanceView"
			AS  
				SELECT "PlanetOrigin","PlanetDestination","Distance"
				FROM "Distance"';
			EXECUTE "query";
			SELECT "Distance" INTO "hopDistance" FROM "DistanceView" WHERE "PlanetOrigin" = "hopIteration"."PlanetOrigin" and "PlanetDestination" = "hopIteration"."PlanetDestination";
			"routeDistance" = "routeDistance" + "hopDistance";
		END LOOP;
		INSERT INTO "RouteLength" VALUES ("rRoute"."MonitoringKey", "routeDistance");
		DROP VIEW "Hops" CASCADE;
		DROP VIEW "PortsOfCall" CASCADE;

	END LOOP;
END;

$$;
SELECT "RouteMonitoringKey", "RouteTotalDistance"
	FROM "RouteLength"
		WHERE "RouteTotalDistance" = (SELECT MAX("RouteTotalDistance") FROM "RouteLength");
;

-- 4) Within the declare section, declare a variable of type real NOT NULL to store a route total distance.

-- 5) Within the declare section, declare a variable of type real NOT NULL to store a hop partial distance.

-- 6) Within the declare section, declare a variable of type record to iterate over routes.

-- 7) Within the declare section, declare a variable of type record to iterate over hops.

-- 8) Within the declare section, declare a variable of type varchar(50) to transiently build dynamic queries.

-- 9) Within the main body section, loop over routes in TradingRoutes

-- 10) Within the loop over routes, get all visited planets (in order) by this trading route.

-- 11) Within the loop over routes, execute the dynamic view

-- 12) Within the loop over routes, create a view Hops for storing the hops of that route. 

-- 13) Within the loop over routes, initialize the route total distance to 0.0.

-- 14) Within the loop over routes, create an inner loop over the hops

-- 15) Within the loop over hops, get the partial distances of the hop. 

-- 16)  Within the loop over hops, execute the dynamic view and store the outcome INTO the hop partial distance.

-- 17)  Within the loop over hops, accumulate the hop partial distance to the route total distance.

-- 18)  Go back to the routes loop and insert into the dummy table RouteLength the pair (RouteMonitoringKey,RouteTotalDistance).

-- 19)  Within the loop over routes, drop the view for Hops (and cascade to delete dependent objects).

-- 20)  Within the loop over routes, drop the view for PortsOfCall (and cascade to delete dependent objects).

-- 21)  Finally, just report the longest route in the dummy table RouteLength.
