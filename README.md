# Appointments
This application was created to simplify the process of appointment making. 
 
## Installation
To use this web application some development skills are needed. You need to compile and adjust the code by yourself.
We recommend to use of IntelliJ Ultimate as a guide is available for this.

### Import project
After you checked out this project import it into IntelliJ as a Gradle project. This process takes a while because all 
necessary dependencies are collected automatically.

### Adjust database access
You can change database access variables in /grails-app/conf/application.yml. Search for username and password. Defaults 
are:
 - Username: uniAppUser
 - Passowrd: z*§7z902t34!1bpn&Z=(OT68t21&
 
### Test run
For now you will need to provide a database schema for the given credentials with full rights. The tables will be created 
automatically during this test run. If you are running the application for the first time you may need to define the 
locations of the JDK and the Grails Framework.

### Installation
If you like to run it as a web application archive (war) you can do so as follows:

- Hit Strg + Alt + G to open the 'run grails command'-window. 
- insert 'prod war somename.war' to create a war with the name 'somename'.
- Use the manual of your web server of choice to deploy the application.
- Notice that you will need a working database setup to make it work.

 
