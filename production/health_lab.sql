
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='health_lab')
	EXEC('CREATE SCHEMA health_lab')
GO


--"Accession Number","Kit Number","Patient ID","Last Name","First Name","Maiden Name","Birth Date","Place of birth","Address 1","City","State","Zip Code","Phone no. 1","Phone no. 2","Location","Entry Mode","Rank","Mother's surname","Mother's first name","Mother's maiden name","Mother's date of birth","Contact facility","Contact Address 1"

-- Where are the results????

--Accession Number VARCHAR(15)
--Kit Number VARCHAR(15)
--Patient ID VARCHAR(15)
--Last Name VARCHAR(15)
--First Name VARCHAR(15)	-- MALE, FEMALE????
--Maiden Name VARCHAR
--Birth Date DATE
--Place of birth VARCHAR
--Address 1 VARCHAR
--City VARCHAR
--State VARCHAR
--Zip Code VARCHAR
--Phone no. 1 VARCHAR
--Phone no. 2 VARCHAR
--Location VARCHAR
--Entry Mode VARCHAR
--Rank VARCHAR
--Mother's surname VARCHAR
--Mother's first name VARCHAR
--Mother's maiden name VARCHAR
--Mother's date of birth DATE
--Contact facility VARCHAR
--Contact Address 1 VARCHAR

IF OBJECT_ID('health_lab.newborn_screening', 'U') IS NOT NULL
	DROP TABLE health_lab.newborn_screening;
CREATE TABLE health_lab.newborn_screening (
	id INT IDENTITY(1,1),
	CONSTRAINT health_lab_newborn_screening_id PRIMARY KEY CLUSTERED (id ASC),
	name_first VARCHAR(250),
	name_last VARCHAR(250),
	date_of_birth DATETIME,
	sex VARCHAR(1),
	testresults1 VARCHAR(250),
	testresults2 VARCHAR(250),
	testresults3 VARCHAR(250),
	testresults4 VARCHAR(250),
	testresults5 VARCHAR(250),



--Congenital Adrenal Hyperplasia
--Congenital Hypothyroidism
--Sickle Cell Disease S/S
--Sickle Cell Disease S/C
--Thalassemia Major
--Biotinidase Deficiency
--Galactosemia
--Argininosuccinate Lyase Deficiency (ASA)
--Classic Citrullinemia
--Citrullinemia Type II
--Homocystinuria
--Hyperphenylalanemia, including Phenylketonuria
--Tyrosinemia, Type 1
--Tyrosinemia, Type 2
--Beta-Ketothiolase Deficiency
--Glutaric Aciduria, Type I (Glutaryl-CoA Dehydrogenase Deficiency)
--Isovaleryl-CoA Dehydrogenase Deficiency (Isovaleric Acidemia)
--Maple Syrup Urine Disease
--Methylmalonic Acidemia (MMA; 8 types)
--Methylmalonic Aciduria, Vitamin B-12 Responsive
--Methylmalonic Aciduria, Vitamin B-12 Nonresponsive
--Vitamin B12 Metabolic Defect with Methylmalonicacidemia and Homocystinuria
--Propionic Acidemia (PA)
--3-methylglutaconyl-CoA Hydratase Deficiency
--3-methylglutaconyl-CoA Aciduria Type I
--3-methylglutaconyl-CoA Aciduria Type II
--3-methylglutaconyl-CoA Aciduria Type III
--3-methylglutaconyl-CoA aciduria Type IV
--Multiple Carboxylase Deficiency
--Carnitine uUptake/Transporter Defects
--Carnitine-Acylcarnitine Translocase Deficiency
--Carnitine Transporter Defect
--Carnitine Palmitoyl Transferase I Deficiency (CPT I)
--Carnitine PalmitoylTransferase II Deficiency (CPT II)
--Glutaric Aciduria, Type II (Multiple Acyl-CoA Dehydrogenase Deficiency (MADD))
--Very Long Chain Acyl-CoA Dehydrogenase Deficiency (VLCADD)
--Long Chain L-3 Hydroxyacyl-CoA Dehydrogenase Deficiency (LCHADD)
--Medium Chain Acyl-CoA Dehydrogenase Deficiency (MCADD)
--Short Chain Acyl-CoA Dehydrogenase Deficiency (SCADD)
--Cystic Fibrosis



);
GO

EXEC bin.add_imported_at_column_to_tables_by_schema 'health_lab';
EXEC bin.add_imported_to_dw_column_to_tables_by_schema 'health_lab';
