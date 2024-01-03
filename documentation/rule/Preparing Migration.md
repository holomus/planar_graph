# Migration Preparation Process

## 1. Delete Debug Migr Files and Create New Structured Migr Files
   - Remove migration files that were created during sprint
   - Develop new migration files, adhering to the specified migration rules

## 2. Add New Actions/Forms (that need to be released, not all) to Release

## 3. Generate Release.SQL

## 4. Add New Forms (only forms that need to be attached) to Modules

## 5. Generate Start_UIS.SQL/Start_UI.SQL/Module.SQL, etc.

## 6. Build Application

## 7. Test Migration on Previous Release (Doesn't test data migration, only structural integrity)
   - Verify the migration process by applying it to a copy of the previous release. This step helps identify and address any issues that may arise during the migration.

## 8. Test New Release on New Schema
   - Test the newly prepared release on a fresh schema or database instance. This ensures that the changes introduced by the migration work as intended and do not conflict with existing data.

## 9. Test data migration
   - Verify that dml operations will not break anything

## 10. Prepare testing schema for QA
   - Run migrations on schema that will be used by QAs.

## 11. Generate New Tag for Release
   - Once the new release has been successfully tested and validated, create a new tag in the version control system (e.g., Git) to mark the release in the project's history. This tag serves as a reference point for the specific version of the software.