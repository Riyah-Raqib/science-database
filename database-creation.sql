-- Create ecology-related tables
CREATE TABLE species_reference (
    species_id NUMBER PRIMARY KEY,
    species_name VARCHAR2(255) UNIQUE NOT NULL,
    common_name VARCHAR2(255),
    family VARCHAR2(255) NOT NULL,
    "order" VARCHAR2(255) NOT NULL,
    class VARCHAR2(255) NOT NULL,
    phylum VARCHAR2(255) NOT NULL,
    kingdom VARCHAR2(255) NOT NULL,
    conservation_status VARCHAR2(255),
    habitat VARCHAR2(255)
);

CREATE INDEX idx_species_family ON species_reference(family);
CREATE INDEX idx_species_order ON species_reference("order");
CREATE INDEX idx_species_class ON species_reference(class);
CREATE INDEX idx_species_phylum ON species_reference(phylum);
CREATE INDEX idx_species_kingdom ON species_reference(kingdom);
CREATE INDEX idx_species_conservation_status ON species_reference(conservation_status);
CREATE INDEX idx_species_habitat ON species_reference(habitat);

CREATE TABLE location_reference (
    location_id NUMBER PRIMARY KEY,
    location_name VARCHAR2(255) UNIQUE NOT NULL,
    habitat_type VARCHAR2(255) NOT NULL,
    region VARCHAR2(255) NOT NULL
);

CREATE INDEX idx_location_habitat_type ON location_reference(habitat_type);
CREATE INDEX idx_location_name ON location_reference(location_name);
CREATE INDEX idx_location_region ON location_reference(region);

CREATE TABLE observations (
    observation_id NUMBER PRIMARY KEY,
    species_name VARCHAR2(255) NOT NULL,
    location_name VARCHAR2(255) NOT NULL,
    observation_datetime TIMESTAMP(0),
    weather_conditions VARCHAR2(255),
    temperature NUMBER(5,2),
    behaviour VARCHAR2(255),
    count NUMBER(10)
);

CREATE INDEX idx_observation_datetime ON observations(observation_datetime);
CREATE INDEX idx_observation_temperature ON observations(temperature);

CREATE TABLE field_notes (
    note_id NUMBER PRIMARY KEY,
    observation_id NUMBER NOT NULL,
    note_text CLOB NOT NULL
);

CREATE TABLE media (
    media_id NUMBER PRIMARY KEY,
    observation_id NUMBER NOT NULL,
    file_type VARCHAR2(50) NOT NULL,
    file_path VARCHAR2(512) NOT NULL,
    description VARCHAR2(1000) NOT NULL
);

-- Create bioinformatics-related tables
CREATE TABLE source_studies (
    study_id NUMBER PRIMARY KEY,
    title VARCHAR2(255) NOT NULL,
    authors VARCHAR2(1000) NOT NULL,
    source VARCHAR2(255) NOT NULL,
    abstract CLOB,
    doi VARCHAR2(255) UNIQUE NOT NULL,
    publication_date DATE
);

CREATE TABLE sample_datasets (
    sample_id NUMBER PRIMARY KEY,
    dataset_name VARCHAR2(255) NOT NULL,
    doi VARCHAR2(255) NOT NULL,
    sample_name VARCHAR2(255) NOT NULL,
    condition VARCHAR2(255) NOT NULL,
    repeat_number NUMBER NOT NULL,
    platform VARCHAR2(255) NOT NULL,
    metadata CLOB
);

CREATE TABLE methods (
    method_id NUMBER PRIMARY KEY,
    method_name VARCHAR2(255) UNIQUE NOT NULL,
    method_description CLOB,
    method_version VARCHAR2(255),
    method_author VARCHAR2(255)
);

CREATE TABLE results (
    result_id NUMBER PRIMARY KEY,
    method_name VARCHAR2(255),
    result_name VARCHAR2(255),
    result_description CLOB,
    data_file VARCHAR2(255),
    result_data CLOB,
    creation_date DATE DEFAULT SYSDATE,
    modification_date DATE DEFAULT SYSDATE,
    status VARCHAR2(50) DEFAULT 'Pending'
);

COMMIT;

-- Add foreign key constraints
ALTER TABLE observations
    ADD CONSTRAINT fk_species_name FOREIGN KEY (species_name) REFERENCES species_reference(species_name);

ALTER TABLE observations
    ADD CONSTRAINT fk_location_name FOREIGN KEY (location_name) REFERENCES location_reference(location_name);

ALTER TABLE field_notes
    ADD CONSTRAINT fk_fn_observation_id FOREIGN KEY (observation_id) REFERENCES observations(observation_id);

ALTER TABLE media
    ADD CONSTRAINT fk_m_observation_id FOREIGN KEY (observation_id) REFERENCES observations(observation_id);

ALTER TABLE sample_datasets
    ADD CONSTRAINT fk_doi FOREIGN KEY (doi) REFERENCES source_studies(doi);

ALTER TABLE results
    ADD CONSTRAINT fk_method_name FOREIGN KEY (method_name) REFERENCES methods(method_name);

COMMIT;
