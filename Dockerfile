FROM cirrusci/flutter as build
RUN git clone https://github.com/shnifer/front.git front
WORKDIR /front
RUN flutter build web