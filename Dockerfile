FROM cirrusci/flutter as build
COPY ./lib /flutter_admin/lib
COPY ./pubspec.yaml /flutter_admin
COPY ./web /flutter_admin/web
WORKDIR /flutter_admin
RUN flutter build web

FROM httpd:2.4
COPY --from=build /flutter_admin/build/web /usr/local/apache2/htdocs