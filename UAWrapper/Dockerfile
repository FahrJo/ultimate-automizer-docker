FROM maven:3-eclipse-temurin-11 as builder
WORKDIR /home
RUN apt update && apt install zip -y
RUN git clone --depth 1 https://github.com/ultimate-pa/ultimate.git
RUN cd ultimate/releaseScripts/default && ./makeFresh.sh

FROM adoptopenjdk/openjdk11
WORKDIR /home
# install gcc and zip
RUN apt update && apt install build-essential zip -y
COPY --from=builder /home/ultimate/releaseScripts/default/UltimateAutomizer-linux.zip ./
RUN unzip UltimateAutomizer-linux.zip && mv UAutomizer-linux/* . && \
    rm UltimateAutomizer-linux.zip
COPY scripts/run_ultimate.sh ./
RUN chmod +x run_ultimate.sh&& \
    # make directories for certain files
    mkdir ./userfiles && mkdir ./logfiles && mkdir ./csvfiles \
    # create dummy file to check if directory was mapped
    touch csvfiles/dockerLocalFile
CMD ["./run_ultimate.sh"]