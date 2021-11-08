FROM cirrusci/flutter as build
RUN git clone https://github.com/shnifer/front.git front
WORKDIR /front
RUN flutter build web

FROM httpd:2.4
COPY --from=build /front/build/web /usr/local/apache2/htdocs