FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copia os arquivos dos projetos individuais
COPY src/Usuarios.API/*.csproj ./Usuarios.API/
COPY src/Usuarios.Application/*.csproj ./Usuarios.Application/
COPY src/Usuarios.Domain/*.csproj ./Usuarios.Domain/
COPY src/Usuarios.Infrastructure/*.csproj ./Usuarios.Infrastructure/

# Restaura os pacotes
RUN dotnet restore ./Usuarios.API/Usuarios.API.csproj

# Copia o restante do código
COPY src/ ./src/
WORKDIR /app/src/Usuarios.API
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 80
ENTRYPOINT ["dotnet", "Usuarios.API.dll"]