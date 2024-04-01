Hotel Project P2

psql -U postgres
password postgres
with PostgreSQL 16.2
\i C:/Users/raywa/OneDrive/Desktop/HotelDB.sql
for spring boot use
.\gradlew.bat bootRun

spring.jpa.hibernate.ddl-auto=update
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQL95Dialect
spring.jpa.properties.hibernate.jdbc.lob.non_contextual_creation=true