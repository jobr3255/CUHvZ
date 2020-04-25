# CU HvZ

## Installing
Run the installation script as sudo to install all the dependencies
```
CUHvZ/$ sudo ./install.sh
```
Install the node modules for both the api/ and the client/ directories
```
/CUHvZ/api$ npm i
/CUHvZ/client$ npm i
```
## Setting up database
Import the database
```
/CUHvZ/db$ mysql -u root -p < CUHvZ.sql
```

### API
Start the api with `npm start` command in the `CUHvZ/api/` directory

### Client

Start the client with `ionic serve` command in the `CUHvZ/client/` directory

### Configuring the emailer

Edit the EMAIL_CONFIG variable in the `api/src/config.ts` file with the appropriate values to connect to the email account on cpanel.
```
export const EMAIL_CONFIG = {
  name: "NAME",
  host: "HOST",
  port: 465,
  secure: true,
  auth: {
    user: 'USER',
    pass: 'PASSWORD'
  },
  tls: {
    rejectUnauthorized: false
  }
};
```
