#FROM openjdk:8-jdk
FROM azul/zulu-openjdk
 
LABEL maintainer "Johan van Soest <j.vansoest@maastrichtuniversity.nl>"
 
# Build time arguments
ARG download_link=https://email.ontotext.com/events/public/v1/track/tc/VVSwVd7K6dPVW8FZ__v4Vhn0JVJvnzy4cTr9WN4FBQN33p_b1V1-WJV7CgZD7W1J0Z1w8xn1rFW26jrWN1B1zP9W5qfK836jRPYkW6GlGM_4kXyBdN3dPpx5WDN_8MH-TM-y-BBmW49wN2V1p8yjMW7RK_Kp4szQS5W8w100V3XszY1N8JJlmqGc-N6N8WBvVzjpdj2W6g1jHL4VRgQlW91srDl7dJdYjW5lQp9x8Trm0qW5S254y4_5TVTW5nvjFv8WFwD8W76Nb-y4dPTNMW4Cmb2b6YrcM5VPWdhF7ZNk8YW3H56Pn6WX03tW2T2GqF1162FgW4BH_vm7m1489W2bFtyM4H3zw7N8FrH0FqkwTJW3VlRLd2Bw1nZW58kxbd39M8y1W706bn04-PHZ1W8_5Sqh3T0WdGW4R6Wmd12t8r7N16hT2mrQr4S3lh61?_ud=34e8a9b9-2deb-4457-b775-f657e4e5cc6c
ARG version=9.3.2
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

