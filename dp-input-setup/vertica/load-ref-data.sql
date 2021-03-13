/* CMS ICD CM Codes */
DROP TABLE IF EXISTS public.cd_icd_cm;
CREATE TABLE public.cd_icd_cm (
    codeID varchar(10),
    altCodeID varchar(10),
    isHeader int,
    shortName varchar(150),
    longName varchar(500),
    version varchar(10),
    diseaseClass varchar(65),
    isChronic varchar(1)
);

COPY public.cd_icd_cm FROM LOCAL '/opt/data/input/_codes/icd_cm_2019.csv' DELIMITER ',' ENCLOSED BY '"' DIRECT
exceptions '/opt/data/logs/icd_cm_2019.exceptions' 
rejected data '/opt/data/logs/icd_cm_2019.rejected';
    
/* NPI Directory */
DROP TABLE IF EXISTS public.cms_npidirectory;
CREATE TABLE public.cms_npidirectory (
        NPI VARCHAR(15),
        EntityTypeCode VARCHAR(4),
        Replacement_NPI VARCHAR(15),
        EIN VARCHAR(12),
        ProviderOrganizationName VARCHAR(255),
        ProviderLastName VARCHAR(255),
        ProviderFirstName VARCHAR(255),
        ProviderMiddleName VARCHAR(255),
        ProviderNamePrefix VARCHAR(10),
        ProviderNameSuffix VARCHAR(10),
        ProviderCredential VARCHAR(25),
        OtherOrganizationName VARCHAR(255),
        OtherOrganizationNameTypeCode VARCHAR(4),
        OtherLastName VARCHAR(255),
        OtherFirstName VARCHAR(255),
        OtherMiddleName VARCHAR(255),
        OtherNamePrefix VARCHAR(10),
        OtherNameSuffix VARCHAR(10),
        OtherCredential VARCHAR(25),
        OtherLastNameTypeCode VARCHAR(4),
        BusinessMailingAddress1 VARCHAR(255),
        BusinessMailingAddress2 VARCHAR(255),
        BusinessMailingAddressCity VARCHAR(255),
        BusinessMailingAddressState VARCHAR(255),
        BusinessMailingAddressPostalCode VARCHAR(25),
        BusinessMailingAddressCountryCode VARCHAR(4),
        BusinessMailingAddressTelephone VARCHAR(25),
        BusinessMailingAddressFax VARCHAR(25),
        PracticeLocationAddress1 VARCHAR(255),
        PracticeLocationAddress2 VARCHAR(255),
        PracticeLocationCity VARCHAR(255),
        PracticeLocationState VARCHAR(255),
        PracticeLocationPostalCode VARCHAR(25),
        PracticeLocationCountryCode VARCHAR(4),
        PracticeLocationTelephone VARCHAR(25),
        PracticeLocationFax VARCHAR(25),
        ProviderEnumerationDate VARCHAR(25),
        LastUpdateDate VARCHAR(25),
        NPI_DeactivationReasonCode VARCHAR(4),
        NPI_DeactivationDate VARCHAR(25),
        NPI_Reactivation_Date VARCHAR(25),
        ProviderGenderCode VARCHAR(4),
        AuthorizedOfficialLastName VARCHAR(255),
        AuthorizedOfficialFirstName VARCHAR(255),
        AuthorizedOfficialMiddleName VARCHAR(255),
        AuthorizedOfficialTitle_Position VARCHAR(255),
        AuthorizedOfficialTelephone VARCHAR(25),
        HealthcareProviderTaxonomyCode_1 VARCHAR(25),
        LicenseNumber_1 VARCHAR(25),
        LicenseNumberStateCode_1 VARCHAR(25),
        HealthcareProviderPrimaryTaxonomySwitch_1 VARCHAR(25),
        HealthcareProviderTaxonomyCode_2 VARCHAR(25),
        LicenseNumber_2 VARCHAR(25),
        LicenseNumberStateCode_2 VARCHAR(25),
        OtherProviderIdentifier_1 VARCHAR(25),
        OtherProviderIdentifierTypeCode_1 VARCHAR(25),
        OtherProviderIdentifierState_1 VARCHAR(25),
        OtherProviderIdentifierIssuer_1 VARCHAR(255),
        IsSoleProprietor VARCHAR(4),
        IsOrganizationSubpart VARCHAR(4),
        ParentOrganizationLBN VARCHAR(255),
        ParentOrganizationTIN VARCHAR(25)
    );
    
COPY cms_npidirectory FROM LOCAL '/opt/data/input/_codes/cms_npi_dir.csv' DELIMITER ',' ENCLOSED BY '"' DIRECT
exceptions '/opt/data/logs/cms_npi_dir.exceptions' 
rejected data '/opt/data/logs/cms_npi_dir.rejected';

/* FDA Drug Codes */
DROP TABLE IF EXISTS public.fda_drug_codes;
CREATE TABLE public.fda_drug_codes (
        productID VARCHAR(50),
        ndcCD VARCHAR(15),
        altNdcCD VARCHAR(15),
        normNdcCD VARCHAR(15),
        labelerCD VARCHAR(5),
        productCD VARCHAR(5),
        packageCD VARCHAR(3),
        productTypeName VARCHAR(35),
        proprietaryName VARCHAR(255),
        proprietaryNameSuffix VARCHAR(150),
        packageDescription VARCHAR(1000),
        nonProprietaryName VARCHAR(550),
        dosageFormName VARCHAR(100),
        routeName VARCHAR(255),
        startMarketingDate VARCHAR(15),
        endMarketingDate VARCHAR(15),
        marketingCategoryName VARCHAR(100),
        applicationNumber VARCHAR(25),
        labelerName VARCHAR(255),
        substanceName VARCHAR(5000),
        strengthNumber VARCHAR(5000),
        strengthUnit VARCHAR(5000),
        pharmaClasses VARCHAR(5000),
        DEASchedule VARCHAR(10),
        status VARCHAR(25),
        source VARCHAR(25)
     );

COPY fda_drug_codes FROM LOCAL '/opt/data/input/_codes/fda_drug_codes.csv' DELIMITER ',' ENCLOSED BY '"' DIRECT
exceptions '/opt/data/logs/fda_drug_codes.exceptions' 
rejected data '/opt/data/logs/fda_drug_codes.rejected';
     
    
/* FDB Drug Dictionary */
DROP TABLE IF EXISTS public.fdb_drugdictionary;
CREATE TABLE fdb_drugdictionary (
        NDC VARCHAR(12),
        drug_strength_volume_nbr VARCHAR(255),
        drug_class_code VARCHAR(255),
        r_drug_pkg_desc VARCHAR(500),
        r_hcfa_unit_type_code VARCHAR(255),
        r_units_pkg_amt VARCHAR(25),
        r_unit_use_code VARCHAR(255),
        repackaged_indicator VARCHAR(255),
        drug_DESI_code VARCHAR(255),
        dosage_form VARCHAR(255),
        drug_strength VARCHAR(255),
        ANDA_indicator VARCHAR(25),
        NDC_add_date VARCHAR(255),
        new_to_market_date VARCHAR(255),
        obsolete_date_NDC VARCHAR(255),
        pkg_size VARCHAR(25),
        route_description VARCHAR(500),
        unit_dose_ind VARCHAR(255),
        AWP_price VARCHAR(25),
        WAC_price VARCHAR(25),
        drug_rebate_code VARCHAR(255),
        gtc VARCHAR(15),
        gtcDescription VARCHAR(255),
        HIC3_GC3_STC VARCHAR(5),
        HIC3_GC3_description VARCHAR(255),
        HICL VARCHAR(8),
        GCN VARCHAR(255),
        GSN VARCHAR(12),
        orange_book_code VARCHAR(255),
        therapeutic_class_code VARCHAR(255),
        metric_strength VARCHAR(25),
        str_unit_measure VARCHAR(25),
        isDeterrent VARCHAR(2),
        isLongActing VARCHAR(2),
        drugClass VARCHAR(25),
        MED VARCHAR(25)
    );

COPY fdb_drugdictionary FROM LOCAL '/opt/data/input/_codes/fdb_drug_dictionary.csv' DELIMITER ',' ENCLOSED BY '"' DIRECT
exceptions '/opt/data/logs/fdb_drug_dictionary.exceptions' 
rejected data '/opt/data/logs/fdb_drug_dictionary.rejected';

DROP TABLE IF EXISTS public.fdb_drug_prices;
CREATE TABLE public.fdb_drug_prices (
    NDC varchar(12),
    PricingTypeCode varchar(4),
    EffectiveDate date,
    TerminationDate date,
    UnitPrice numeric(30,2),
    PriceSourceCode varchar(10)
);

COPY fdb_drug_prices FROM LOCAL '/opt/data/input/_codes/fdb_drug_price_history.csv' DELIMITER ',' ENCLOSED BY '"' DIRECT
exceptions '/opt/data/logs/fdb_drug_price_history.exceptions' 
rejected data '/opt/data/logs/fdb_drug_price_history.rejected';

DROP TABLE IF EXISTS public.geo_zipcode;
CREATE TABLE public.geo_zipcode (
        zip VARCHAR(15),
        type VARCHAR(255),
        decommissioned INT,
        primary_city VARCHAR(255),
        acceptable_cities VARCHAR(255),
        unacceptable_cities VARCHAR(255),
        state VARCHAR(255),
        county VARCHAR(255),
        timezone VARCHAR(255),
        area_codes VARCHAR(255),
        world_region VARCHAR(255),
        country VARCHAR(255),
        latitude FLOAT,
        longitude FLOAT,
        irs_estimated_population_2014 INT
    );

COPY geo_zipcode FROM LOCAL '/opt/data/input/_codes/geo_zipcodes.csv' DELIMITER ',' ENCLOSED BY '"' DIRECT
exceptions '/opt/data/logs/geo_zipcodes.exceptions' 
rejected data '/opt/data/logs/geo_zipcodes.rejected';

/* SSA FIPS Cross Walk */
DROP TABLE IF EXISTS idx_ssa_fips_cw;
CREATE TABLE idx_ssa_fips_cw (
        county VARCHAR(255),
        state VARCHAR(255),
        ssacounty VARCHAR(25),
        fipscounty VARCHAR(25),
        ssastate VARCHAR(5),
        fipsstate VARCHAR(5)
    );

COPY idx_ssa_fips_cw FROM LOCAL '/opt/data/input/_codes/idx_ssa_fips_cw.csv' DELIMITER ',' ENCLOSED BY '"' DIRECT
exceptions '/opt/data/logs/idx_ssa_fips_cw.exceptions' 
rejected data '/opt/data/logs/idx_ssa_fips_cw.rejected';
