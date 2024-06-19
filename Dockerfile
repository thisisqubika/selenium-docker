
FROM maven:3.8.1-openjdk-11-slim AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package clean

FROM --platform=linux/amd64 selenium/standalone-chrome:125.0
USER root
RUN apt-get update && apt-get install -y openjdk-11-jdk
#RUN chmod +x /usr/local/bin/chromedriver

USER seluser
COPY --from=build /app/target/selenium-docker-1.0-SNAPSHOT.jar /app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]
