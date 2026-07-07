#!/usr/bin/env bash

# Base images as dependencies
export OS_UBUNTU="ubuntu:noble-20260610"
export OS_ALPINE="alpine:3.24"
export OS_DEBIAN="debian:bookworm-20250203-slim"
export APP_ANTORA="antora/antora:3.1.15"
export LANG_JDK_11="quay.io/labmonkeys/openjdk:jdk-11.0.24.b186"
export LANG_JRE_17="quay.io/labmonkeys/openjdk:jre-17.0.12.b187"
export LANG_JDK_17="quay.io/labmonkeys/openjdk:jdk-17.0.12.b189"
export LANG_PYTHON_3="python:3-slim"
export LANG_ELIXIR="hexpm/elixir:1.17.3-erlang-26.2.5.21-alpine-3.20.9"
