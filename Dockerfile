# Cria a imagem ubuntu mais recente e faz o build
FROM ubuntu:latest AS build

# Depois de criar a imagem dá uma atualizada e instala o jdk o -y é para dar um "sim" para todas as perguntas
RUN apt-get update
RUN apt-get install openjdk-17-jdk -y

# Copia todo o meu projeto e passa para a imagem
COPY . .

# Instala o maven e cria o .jar da aplicação
RUN apt-get install maven -y        
RUN mvn clean install

# Imagem base para depois de instalar o jdk ele poder rodar o projeto
FROM openjdk:17-jdk-slim

# Expõe a porta da aplicação
EXPOSE 8080

# Faz uma cópia do todolist.jar e coloca em outro arquivo, nesse caso no app.jar
COPY --from=build /target/todolist-0.0.1-SNAPSHOT.jar app.jar

# Roda o projeto
ENTRYPOINT [ "java", "-jar", "app.jar" ]