# DEL FSH

# FHIR Data Migration Tool

The migration tool is designed to facilitate the migration of healthcare-related data into a FHIR (Fast Healthcare Interoperability Resources) server. It's specifically tailored for processing DEL data (questionnaires, including their sections, questions, and responses), and transforming them into a FHIR-compliant format. The tool leverages PostgreSQL for data storage and retrieval, and it's structured to handle complex data relationships and healthcare standards like LOINC codes.

## Prerequisite

- Node.js
- PostgreSQL
- Access to a FHIR server

## Installation

1. Clone the repository to your local machine.
2. Navigate to the project directory.
3. Install the necessary Node.js packages:

    ```bash
    npm install
    ```
## Configuration

1. Update the database connection settings in `src/migrate.js` to match your PostgreSQL configuration. The current setting is set to:

    ```js
    const DATABASE = {
      user: 'postgres',
      database: 'postgres',
      password: 'welcome123',
      port: 5432,
      host: 'localhost',
    };
    ```

2. Set the `profileUrl` and `fhirURL` in `src/migrate.js` to point to the Questionnaire profile URL and your FHIR server base URL, respectively.

## Running the Migration Tool

Please make sure that your database and FHIR server are running before starting the migration.

### Data Migration

1. To run the data migration process, execute the migrate.js script:

    ```bash
    node src/migrate.js <FHIR_server_host>
    ```

    Replace `<FHIR_server_host>` with the host of your FHIR server (e.g. localhost:8080/fhir).
2. The script will connect to the PostgreSQL database, process the data, and generate JSON files for each FHIR Questionnaire resource in the `out/json/questionnaires` directory. It will also upload the FHIR resources to your FHIR server.

### Uploading to FHIR Server

The generated Questionnaire resources in `out/json/questionnaires` can also be loaded to a FHIR server at a later time, without having to rerun the migration process.

1. To upload the generated FHIR resources to your FHIR server, run the upload.js script:

    ```bash
    node src/upload.js <FHIR_server_host>
    ```

    Replace `<FHIR_server_host>` with the host of your FHIR server (e.g. localhost:8080/fhir).

2. The script will upload each resource to the specified FHIR server, including the DEL Implementation Guide resource and the structure definitions.

## Scripts Description

- **migrate.js**: Main script for migrating data from PostgreSQL to FHIR format, then uploading the generated resource to the provided FHIR server.
- **upload.js**: Script for uploading generated FHIR resources and IG structure definitions to a FHIR server.
- **sql.js**: Contains functions to execute SQL queries and fetch data.
- **questionnaire.js** (in `migrators` folder): Handles the construction of FHIR Questionnaires from the database data.

## SQL Scripts

SQL scripts are used to fetch data from the PostgreSQL database. They are located in the `src/sql` directory:

- **questionnaires.sql**: Fetches questionnaire data.
- **sections.sql**: Retrieves sections within each questionnaire.
- **questions.sql**: Fetches questions for each section.
- **responses.sql**: Retrieves responses for each question.

## Contributing

Contributions to this project are welcome. Please ensure that any changes are fully tested before submitting a pull request.

## NOTICE

© 2023 The MITRE Corporation.
