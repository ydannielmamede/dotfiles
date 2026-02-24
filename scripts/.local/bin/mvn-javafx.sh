#!/bin/bash

mvn archetype:generate \
        -DarchetypeGroupId=org.openjfx \
        -DarchetypeArtifactId=javafx-archetype-fxml \
        -DarchetypeVersion=0.0.6 \
        -DgroupId=org.openjfx \
        -DartifactId=JavaFX \
        -Dversion=1.0.0 \
        -Djavafx-version=25.0.2
