#FROM openjdk:8-jdk
FROM azul/zulu-openjdk
 
LABEL maintainer "Johan van Soest <j.vansoest@maastrichtuniversity.nl>"
 
# Build time arguments
ARG download_link=https://email.ontotext.com/e2t/tc/VWL1m04MLZv-W4ZvtRs3w3CJbW5BVC1m49TTrbN8DGmFf3p_b1V1-WJV7CgVkRW6GwwY07qRPQ1W1c0r6p86f899W8pV36B4Hp8jtW2lLGLn7Kg3wwW38qB3T7q76b7W39BlJR4ZwtJyW7GzNmx4_DR9NW6FTnyV7vJ1B1N1kQJhqsB1qsW18mcnN1M1t4mW7yk39376_K9lW5GfMnZ1gVdHBW4CQDxY1779VmW2wcBrP6LmDgNW1F7B826KNBTsN1RgxhJt6qVJW3KzQ8x8dVMshW6XwBQY2c3VGNW6Wty7J3TBWdMW3GWT0g7mhYdsW2DRcQM2531JRW6N1XW44xV-PcW4TgZJV8mQHTfW6jYG7d40_gDmW86DmTr7FLjTGD_qDmhr_kzW8FY_f34Cy4KDW97hTWw8CNqj5W5m2tGK17DRBpW1cvSLp5PhjvQ34Bb1
ARG version=9.3.0
ARG edition=free
 
# Environment variables, to be used for the docker image
ENV GDB_HEAP_SIZE=2g
ENV GDB_MIN_MEM=1g
ENV GDB_MAX_MEM=2g
 
ENV GRAPHDB_PARENT_DIR=/opt/graphdb
ENV GRAPHDB_HOME=${GRAPHDB_PARENT_DIR}/home
ENV GRAPHDB_INSTALL_DIR=${GRAPHDB_PARENT_DIR}/dist

RUN apt-get update && \
    apt-get install -y unzip curl

# Copy the installation file recieved after registration
#ADD graphdb-${edition}-${version}-dist.zip /tmp
RUN curl -L -o /tmp/graphdb-${edition}-${version}-dist.zip ${download_link}
 
RUN mkdir -p ${GRAPHDB_PARENT_DIR} && \
    cd ${GRAPHDB_PARENT_DIR} && \
    unzip /tmp/graphdb-${edition}-${version}-dist.zip && \
    mv graphdb-${edition}-${version} dist && \
    mkdir -p ${GRAPHDB_HOME} && \
    rm /tmp/graphdb-${edition}-${version}-dist.zip
 
ENV PATH=${GRAPHDB_INSTALL_DIR}/bin:$PATH
 
CMD ["-Dgraphdb.home=/opt/graphdb/home -Dorg.xml.sax.driver=com.sun.org.apache.xerces.internal.parsers.SAXParser -Djdk.xml.entityExpansionLimit=1000000"]
 
ENTRYPOINT ["/opt/graphdb/dist/bin/graphdb"]
 
EXPOSE 7200

