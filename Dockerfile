FROM cirrusci/flutter as build
RUN git clone https://github.com/shnifer/flutter_admin.git flutter_admin
WORKDIR /flutter_admin
RUN flutter build web

FROM httpd:2.4
COPY --from=build /flutter-admin/build/web /usr/local/apache2/htdocs