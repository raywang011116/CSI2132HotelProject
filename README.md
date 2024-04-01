Hotel Project P2
1--database deployment:
    open terminal and enter:
    psql -U postgres
    password postgres
    \i C:/Users/raywa/OneDrive/Desktop/HotelDB.sql(where you put database file)
with PostgreSQL 16.2
2--for spring boot use
.\gradlew.bat bootRun
homepage deployment on http://localhost:8080/homepage.html

spring.jpa.hibernate.ddl-auto=update
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.properties.hibernate.jdbc.lob.non_contextual_creation=true