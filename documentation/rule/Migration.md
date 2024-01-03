# Rules for Preparing Migrations

1. **Error Handling:**
   - **Rule:** Include the line `whenever sqlerror exit failure rollback;` at the very beginning of the migration file.
   - **Explanation:** This line halts script execution if any error is fired, ensuring a consistent state in the database.

2. **Migration File Naming Convention:**
   - **Rule:** Migration file names should consist of the format **MajorVersion.MinorVersion.PatchVersion** _Script Order_._Script Type_.sql.
   - **Explanation:**
     - MajorVersion.MinorVersion.PatchVersion represents the version of the database schema.
     - _Script Order_ indicates the order of execution for the script within the specified version.
     - _Script Type_ describes the type or purpose of the script (e.g., DDL, DML, PCK).
     - _Script Type_ PCK contains main package changes from previous version (doesn't contain ui changes)
     - **Example:** v2.36.0 (1.ddl).sql signifies the first DDL script for version 2.36.0.
   
3. **File Grouping**
   - **Rule:** Migration Files From One Version must be in One Folder
   - **Explanation:**
      - For example if migration consists of v2.36.0 (1.ddl).sql and v2.36.0 (2.dml).sql
      - Then file scture looks like this:
      - _v2.36.0_:
        - _v2.36.0 (1.ddl).sql_
        - _v2.36.0 (2.dml).sql_