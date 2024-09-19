#!/usr/bin/env bash

# Base images as dependencies
export OS_UBUNTU="quay.io/labmonkeys/ubuntu:noble-20240827.1.b355"
export OS_ALPINE="quay.io/labmonkeys/alpine:3.20-20240919.b356"
export OS_DEBIAN="quay.io/labmonkeys/debian:bookworm-20240904-slim.b362"
export APP_ANTORA="antora/antora:3.1.9"
export LANG_JRE_11="quay.io/labmonkeys/openjdk:jre-11.0.24.b188"
export LANG_JDK_11="quay.io/labmonkeys/openjdk:jdk-11.0.24.b186"
export LANG_JRE_17="quay.io/labmonkeys/openjdk:jre-17.0.12.b187"
export LANG_JDK_17="quay.io/labmonkeys/openjdk:jdk-17.0.12.b189"
export LANG_NODE_16="node:current-alpine3.20"
export LANG_PYTHON_3="python:3-slim"
export LANG_PYTHON_3_ALPINE="python:alpine3.20"
export LANG_ELIXIR="hexpm/elixir:1.13.4-erlang-24.3.4.15-alpine-3.17.5"
