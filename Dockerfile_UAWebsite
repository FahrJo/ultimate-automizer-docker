FROM maven:3-eclipse-temurin-11 as builder
WORKDIR /home
RUN git clone --depth 1 https://github.com/ultimate-pa/ultimate.git
RUN cd ultimate/trunk/source/BA_MavenParentUltimate && \
    mvn clean install -P materialize && \
    cd ../BA_SiteRepository/target/products/WebBackend

FROM adoptopenjdk/openjdk11
WORKDIR /opt/Ultimate
RUN apt update && apt install build-essential z3 -y
COPY --from=builder /home/ultimate/trunk/source/BA_SiteRepository/target/products/WebBackend/linux/gtk/x86_64 ./WebBackend
COPY --from=builder /home/ultimate/trunk/source/BA_SiteRepository/target/products/WebsiteStatic ./WebsiteStatic
COPY scripts/prepare_backend.sh WebBackend/
COPY scripts/prepare_frontend.sh WebsiteStatic/
RUN /bin/bash WebBackend/prepare_backend.sh
RUN /bin/bash WebsiteStatic/prepare_frontend.sh
CMD ["WebBackend/WebBackend"]