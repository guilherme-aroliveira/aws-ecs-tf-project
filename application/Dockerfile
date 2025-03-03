FROM openjdk:alpine

EXPOSE 8080
ADD springbotapp.jar springboot.jar
ENTRYPOINT [ "java", "-jar", "-Xms1024m", "-Xmx1800m", "springbootapp.jar" ]