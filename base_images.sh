#!/usr/bin/env bash

# Base images as dependencies
export OS_UBUNTU_JAMMY="quay.io/labmonkeys/ubuntu:jammy-20231004.b337"
export OS_ALPINE="quay.io/labmonkeys/alpine:3.18.4-20231108.b339"
export APP_ANTORA="antora/antora:3.1.4"
export LANG_JRE_11="quay.io/labmonkeys/openjdk:jre-11.0.19.b172"
export LANG_JDK_11="quay.io/labmonkeys/openjdk:jdk-11.0.19.b170"
export LANG_JRE_17="quay.io/labmonkeys/openjdk:jre-17.0.7.b171"
export LANG_JDK_17="quay.io/labmonkeys/openjdk:jdk-17.0.7.b173"
export LANG_NODE_16="node:current-alpine3.18"
export LANG_PYTHON_3="python:3-slim"
export LANG_PYTHON_3_ALPINE="python:alpine3.18"
export LANG_ELIXIR="elixir:1.11.4-alpine"