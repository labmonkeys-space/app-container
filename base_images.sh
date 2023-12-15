#!/usr/bin/env bash

# Base images as dependencies
export OS_UBUNTU_JAMMY="quay.io/labmonkeys/ubuntu:jammy-20231128.b344"
export OS_ALPINE="quay.io/labmonkeys/alpine:3.19-20231215.b341"
export APP_ANTORA="antora/antora:3.1.5"
export LANG_JRE_11="quay.io/labmonkeys/openjdk:jre-11.0.21.b179"
export LANG_JDK_11="quay.io/labmonkeys/openjdk:jdk-11.0.21.b181"
export LANG_JRE_17="quay.io/labmonkeys/openjdk:jre-17.0.9.b180"
export LANG_JDK_17="quay.io/labmonkeys/openjdk:jdk-17.0.9.b178"
export LANG_NODE_16="node:current-alpine3.19"
export LANG_PYTHON_3="python:3-slim"
export LANG_PYTHON_3_ALPINE="python:alpine3.19"
export LANG_ELIXIR="elixir:1.11.4-alpine"