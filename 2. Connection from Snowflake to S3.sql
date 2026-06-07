CREATE OR REPLACE STORAGE INTEGRATION s3_retail_brazilian_integration
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = 'S3'
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::000000000000:role/placeholder'
    STORAGE_ALLOWED_LOCATIONS = ('s3://snowflake-capstone-retail-data/');   


DESC INTEGRATION s3_retail_brazilian_integration;    


ALTER STORAGE INTEGRATION s3_retail_brazilian_integration
SET STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::439855819219:role/Snowflake_Retail_Brazilian_S3_Access';
