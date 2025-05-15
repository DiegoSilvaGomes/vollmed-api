FROM openjdk:17

WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN chmod +x mvnw && ./mvnw package -DskipTests \
  && cp target/*.jar app.jar

CMD ["java", "-jar", "app.jar"]
