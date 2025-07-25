# Copyright 2020 The TensorFlow Authors. All Rights Reserved.
# Copyright 2022 The StableHLO Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

add_mlir_public_c_api_library(CheckCAPI
  PARTIAL_SOURCES_INTENDED
  CheckDialect.cpp

  LINK_LIBS PUBLIC
  CheckOps
)

add_mlir_public_c_api_library(ChloCAPI
  PARTIAL_SOURCES_INTENDED
  ChloAttributes.cpp
  ChloDialect.cpp

  LINK_LIBS PUBLIC
  ChloOps
)

add_mlir_public_c_api_library(StablehloCAPI
  PARTIAL_SOURCES_INTENDED
  StablehloAttributes.cpp
  StablehloDialect.cpp
  StablehloPasses.cpp
  StablehloTypes.cpp
  StablehloDialectApi.cpp
  StablehloUnifiedApi.cpp
  InterpreterDialect.cpp

  LINK_LIBS PUBLIC
  MLIRCAPIIR
  MLIRIR
  MLIRSupport  # LLVMSupport is automatically added in AddLLVM.cmake.
  StablehloOps
  StablehloPasses
  StablehloPortableApi
  StablehloReferenceApi
  StablehloReferenceConfiguration
  StablehloSerialization
  Version
  InterpreterOps
)

add_mlir_public_c_api_library(VhloCAPI
  PARTIAL_SOURCES_INTENDED
  VhloDialect.cpp

  LINK_LIBS PUBLIC
  VhloOps
)
