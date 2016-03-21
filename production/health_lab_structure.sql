
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='health_lab')
	EXEC('CREATE SCHEMA health_lab')
GO

IF OBJECT_ID('health_lab.newborn_screening', 'U') IS NOT NULL
	DROP TABLE health_lab.newborn_screening;
CREATE TABLE health_lab.newborn_screening (
	id INT IDENTITY(1,1) PRIMARY KEY,
	name_first VARCHAR(250),
	name_last VARCHAR(250),
	date_of_birth DATETIME,
	sex VARCHAR(1),
	blahblah VARCHAR(250),
	yadayada VARCHAR(250),



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

EXEC dbo.add_imported_at_column_to_tables_by_schema 'health_lab';
EXEC dbo.add_imported_to_dw_column_to_tables_by_schema 'health_lab';
