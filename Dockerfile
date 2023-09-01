FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /src
COPY "MvcApp.csproj" .
RUN dotnet restore "MvcApp.csproj"
COPY . .
RUN dotnet build . -c Release -o /app/build

# RUN apt-get install curl

FROM build AS publish
RUN dotnet publish "MvcApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ConnectionStrings__ProductsContext Server=mysql-service
ENV ConnectionStrings__ProductsContext Database=ProductsContext
ENV ConnectionStrings__ProductsContext User=sa
ENV ConnectionStrings__ProductsContext Password=@Aa123456;
ENV ASPNETCORE_ENVIRONMENT Development
ENTRYPOINT ["dotnet", "MvcApp.dll"]

