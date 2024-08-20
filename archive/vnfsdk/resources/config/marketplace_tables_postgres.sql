CREATE DATABASE "marketplaceDB";

\c marketplaceDB;

DROP TABLE IF EXISTS CSAR_PACKAGE_TABLE;

CREATE TABLE CSAR_PACKAGE_TABLE (
        CSARID                   VARCHAR(200)       NOT NULL,
        DOWNLOADURI              VARCHAR(200)       NULL,
        REPORT                       VARCHAR(200)       NULL,
        SIZE                     VARCHAR(100)       NULL,
        FORMAT                   VARCHAR(100)       NULL,
        CREATETIME               VARCHAR(100)       NULL,
        DELETIONPENDING          VARCHAR(100)       NULL,
        MODIFYTIME               VARCHAR(100)       NULL,
        SHORTDESC                    TEXT                       NULL,
        NAME                     VARCHAR(100)       NULL,
        VERSION                  VARCHAR(20)        NULL,
        PROVIDER                 VARCHAR(300)       NULL,
        TYPE                     VARCHAR(300)       NULL,
        DETAILS                      TEXT                           NULL,
        REMARKS                      TEXT                           NULL,
        DOWNLOADCOUNT            INT                NULL,
        CONSTRAINT csar_package_table_pkey PRIMARY KEY (CSARID)
);
