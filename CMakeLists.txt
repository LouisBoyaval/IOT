cmake_minimum_required(VERSION 3.22)
project(IOT C)

set(CMAKE_C_STANDARD 99)

add_executable(IOT src/DB_test.c header/DB_connector.h src/Motor.c)
