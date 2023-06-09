# Data-Base-Movie4u

This project is a movie database system that can be run using Oracle XE 21. It consists of several SQL scripts that need to be executed in order to create the necessary tables and populate the database.

## How to Run

To run the project, simply execute the `main.py` file. When prompted for the username and password, enter the credentials for the admin account in Oracle XE 21, which are typically:

- Username: `SYSTEM`
- Password: (the one defined during installation)

If you encounter an error when creating the user table, you can create it manually using the following credentials:

- User: `movie4u`
- Password: `test1234`

After creating the table, re-run the `main.py` script.

If you still encounter any problems, you can manually run the SQL scripts in the following order:

1. Run `data-base-movie4u/data base architect/fonction1.sql` in the admin account
2. Login to the user account using the credentials mentioned above
3. Run `data-base-movie4u/data base architect/database.sql`
4. Run `data-base-movie4u/data base architect/fonction2.sql`

**Please note that you need Oracle XE with SQLPlus enabled to run the script.**

## Tested Platforms

This project has been tested on Oracle XE 21. 

## Documentation

For more information, please refer to the [documentation](doc).
