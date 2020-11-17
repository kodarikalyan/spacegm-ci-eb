#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

EXPOSE 80

COPY * .


WORKDIR /source
RUN dotnet clean
RUN dotnet restore  
RUN dotnet --version

COPY . .
WORKDIR /source

RUN dotnet build -c Release -o /app


# copy everything else and build app
COPY . .
WORKDIR /source
RUN dotnet publish -c release -o /app --no-restore


# final stage/image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "Tailspin.SpaceGame.Web.dll"]

