#!/usr/bin/env bash

# Base images as dependencies
export OS_UBUNTU_JAMMY="quay.io/labmonkeys/ubuntu:jammy-20230308.b306"
export OS_ALPINE="quay.io/labmonkeys/alpine:3.17.2-20230313.b304"
export APP_ANTORA="antora/antora:3.1.2"
export LANG_JRE_11="quay.io/labmonkeys/openjdk:jre-11.0.18.b168"
export LANG_JDK_11="quay.io/labmonkeys/openjdk:jdk-11.0.18.b166"
export LANG_JRE_17="quay.io/labmonkeys/openjdk:jre-17.0.6.b167"
export LANG_JDK_17="quay.io/labmonkeys/openjdk:jdk-17.0.6.b169"
export LANG_PYTHON_3="python:3-slim"
export LANG_ELIXIR="elixir:1.11.4-alpine"