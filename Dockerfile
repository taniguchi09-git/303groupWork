# -------- ビルド用コンテナ（Gradle + JDK） --------
FROM gradle:8.10.2-jdk-21 AS build
WORKDIR /workspace

# プロジェクト一式をコピー
COPY . .

# Spring Boot の jar をビルド（テストはスキップ）
RUN gradle bootJar -x test

# -------- 実行用コンテナ（JREのみ） --------
FROM eclipse-temurin:21-jre
WORKDIR /app

# ビルド成果物の jar をコピー（ファイル名は * でまとめて1つ取る）
COPY --from=build /workspace/build/libs/*.jar app.jar

# Spring Boot のデフォルトポート
EXPOSE 8080

# アプリ起動コマンド
ENTRYPOINT ["java", "-jar", "app.jar"]
