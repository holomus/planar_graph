### Prerequisites:

1. **Git Installed:**
   - Ensure that Git is installed on your system, and the `git` command is available in your command-line environment.

2. **Python Installed:**
   - Ensure that Python is installed on your system, and the `python` command is available in your command-line environment.

### Instructions:

1. **Open a Command Prompt:**
   - Open a command prompt on your computer in directory where scripts are located.

2. **Run the Batch Script:**
   - Execute the batch script by providing two Git tags as parameters. For example:
     ```bash
     gen_migr.bat tag1 tag2
     ```
     Replace `tag1` and `tag2` with the Git tags you want to compare.

   - Example:
     ```bash
     gen_migr.bat v1.0 v1.1
     ```

3. **Review Output:**
   - The script will perform a Git diff operation, capturing the names of changed files in `difference.txt`.
   - The Python script (`gen_migr.py`) will be executed with one of the Git tags as an argument, and it will attempt to create a new SQL script (`<prefix>_pack.sql`).

4. **Check for Errors:**
   - Review the output in the command prompt for any error messages or success messages.
