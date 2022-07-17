To start mysql, in the terminal, type in `mysql -u root`

To create a user that can be accessed via nodejs etc, run this:
```
mysql -e "ALTER USER 'user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root_password';"
```

# import sakila database
mysql -u root < sakila-schema.sql
mysql -u root < sakila-data.sql

# dependencies

1) create a file with the name `init.sh`

yarn add express
yarn add hbs
yarn add wax-on
yarn add handlebars-helpers
yarn add mysql2

set permission: 
chmod +x init.sh

# create user
create user 'ahkow'@'localhost' identified by 'rotiprata123';
GRANT ALL PRIVILEGES ON sakila.* TO 'ahkow'@'localhost' with grant option;
flush privileges;