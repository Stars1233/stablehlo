/* Copyright 2019 The TensorFlow Authors. All Rights Reserved.
   Copyright 2022 The StableHLO Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

#ifndef STABLEHLO_DIALECT_VHLO_ATTRS
#define STABLEHLO_DIALECT_VHLO_ATTRS

include "mlir/IR/AttrTypeBase.td"
include "stablehlo/dialect/VhloBase.td"
include "stablehlo/dialect/VhloDialect.td"
include "stablehlo/dialect/VhloTypes.td"
include "stablehlo/dialect/VhloEnums.td"


class VHLO_AttrDef<string name, string minVersion, string maxVersion>
  : AttrDef<VHLO_Dialect, name, [VHLO_VersionedAttrInterface]> {
  let extraClassDeclaration = [{
    mlir::vhlo::Version getMinVersion() {
      return mlir::vhlo::Version(}] # !subst(".", ", ", minVersion) # [{);
    }
    mlir::vhlo::Version getMaxVersion() {
      }] # !if(
        !eq(maxVersion, "current"),
        [{ return mlir::vhlo::Version::getCurrentVersion(); }],
        [{ return mlir::vhlo::Version("}] # !subst(".", ", ", maxVersion) # [{"); }]
      ) # [{
    }
  }];
}

// Represents attributes from the StableHLO spec which say "variadic number of",
// although not called out explicitly in the "Constants" section.
def VHLO_ArrayAttrV1 : VHLO_AttrDef<"ArrayV1", "0.9.0", "current"> {
  let mnemonic = "array_v1";
  let parameters = (ins ArrayRefParameter<"mlir::Attribute">:$value);
  let assemblyFormat = "`<` custom<AttributeArray>($value) `>`";
}

// Corresponds to BooleanConstant from the StableHLO spec.
def VHLO_BooleanAttrV1 : VHLO_AttrDef<"BooleanV1", "0.9.0", "current"> {
  let mnemonic = "bool_v1";
  let parameters = (ins "bool":$value);
  let assemblyFormat = "`<` $value `>`";
}

// TODO(#425): DictionaryConstant is not part of the StableHLO spec.
// At the moment, it is used to represent argument and result attributes of
// StableHLO functions, and we're planning to look into it as part of the work
// on speccing Module/Func/Call/Return ops in StableHLO.
def VHLO_DictionaryAttrV1 : VHLO_AttrDef<"DictionaryV1", "0.9.0", "current"> {
  let mnemonic = "dict_v1";
  let parameters = (ins ArrayRefParameter<"std::pair<mlir::Attribute, mlir::Attribute>", "">:$value);
  let genVerifyDecl = 1;
  let extraClassDefinition = [{
    LogicalResult DictionaryV1Attr::verify(
        llvm::function_ref<mlir::InFlightDiagnostic ()> errFn,
        ArrayRef<std::pair<mlir::Attribute, mlir::Attribute>> value) {
      for (auto & entry : value) {
        if (!isFromVhlo(entry.first)) errFn() << "expected VHLO key attribute";
      }
      return success();
    }
  }];
  let assemblyFormat = "`<` custom<AttributeDictionary>($value) `>`";
}

// Corresponds to FloatConstant from the StableHLO spec.
def VHLO_FloatAttrV1 : VHLO_AttrDef<"FloatV1", "0.9.0", "current"> {
  let mnemonic = "float_v1";
  let parameters = (ins "mlir::Type":$type, VHLO_APFloatV1:$value);
  let genVerifyDecl = 1;
  let extraClassDefinition = [{
    LogicalResult FloatV1Attr::verify(
        llvm::function_ref<mlir::InFlightDiagnostic ()> errFn, mlir::Type type, APFloat value) {
      if (!isFromVhlo(type)) return errFn() << "expected VHLO type";
      return success();
    }
  }];
  let assemblyFormat = "`<` $value `:` $type `>`";
}

// Corresponds to IntegerConstant from the StableHLO spec.
def VHLO_IntegerAttrV1 : VHLO_AttrDef<"IntegerV1", "0.9.0", "current"> {
  let mnemonic = "integer_v1";
  let parameters = (ins "mlir::Type":$type, APIntParameter<"">:$value);
  let genVerifyDecl = 1;
  let extraClassDefinition = [{
    LogicalResult IntegerV1Attr::verify(
        llvm::function_ref<mlir::InFlightDiagnostic ()> errFn, mlir::Type type, APInt value) {
      if (!isFromVhlo(type)) return errFn() << "expected VHLO type";
      return success();
    }
  }];
  let hasCustomAssemblyFormat = 1;
}

// TODO(#740): OutputOperandAlias is not yet part of the StableHLO spec.
// At the moment, it is used to represent buffer donation, and we're planning
// to look into it as part of the work on speccing buffer donation in StableHLO.
def VHLO_OutputOperandAliasAttrV1 : VHLO_AttrDef<"OutputOperandAliasV1", "0.9.0", "current"> {
  let mnemonic = "output_operand_alias_v1";
  let parameters = (ins
    VHLO_Dims:$outputTupleIndices,
    "int64_t":$operandIndex,
    VHLO_Dims:$operandTupleIndices
  );
  let assemblyFormat = "`<` struct(params) `>`";
}

// Corresponds to StringConstant from the StableHLO spec.
def VHLO_StringAttrV1 : VHLO_AttrDef<"StringV1", "0.9.0", "current"> {
  let mnemonic = "string_v1";
  let parameters = (ins StringRefParameter<"">:$value);
  let assemblyFormat = "`<` custom<EscapedString>($value) `>`";
}

// Corresponds to TensorConstant from the StableHLO spec.
def VHLO_TensorDataV1 : AttrParameter<"::llvm::ArrayRef<char>", ""> {
  let allocator = "$_dst = $_allocator.copyInto($_self);";
}
def VHLO_TensorAttrV1 : VHLO_AttrDef<"TensorV1", "0.9.0", "current"> {
  let mnemonic = "tensor_v1";
  let parameters = (ins "::mlir::Type":$type, VHLO_TensorDataV1:$data);
  let genVerifyDecl = 1;
  let extraClassDefinition = [{
    LogicalResult TensorV1Attr::verify(
        llvm::function_ref<mlir::InFlightDiagnostic ()> errFn, mlir::Type type, ArrayRef<char>) {
      if (!isFromVhlo(type)) errFn() << "expected VHLO type";
      return success();
    }
  }];
  let hasCustomAssemblyFormat = 1;
}

// TODO(#425): TypeConstant is not part of the StableHLO spec.
// At the moment, it is used to represent types of StableHLO functions, and
// we're planning to look into it as part of the work on speccing
// Module/Func/Call/Return ops in StableHLO.
def VHLO_TypeAttrV1 : VHLO_AttrDef<"TypeV1", "0.9.0", "current"> {
  let mnemonic = "type_v1";
  let parameters = (ins "::mlir::Type":$value);
  let genVerifyDecl = 1;
  let extraClassDefinition = [{
    LogicalResult TypeV1Attr::verify(
        llvm::function_ref<mlir::InFlightDiagnostic ()> errFn, mlir::Type value) {
      if (!isFromVhlo(value)) return errFn() << "expected VHLO type";
      return success();
    }
  }];
  let assemblyFormat = "`<` $value `>`";
}

// TODO(#8): TypeExtensions is not part of the StableHLO spec.
// At the moment, it is used to represent dimension bounds to support bounded
// dynamism, and we're planning to look into it as part of the work on the
// dynamism RFC.
def VHLO_TypeExtensionsAttrV1 : VHLO_AttrDef<"TypeExtensionsV1", "0.9.0", "current"> {
  let mnemonic = "type_extensions_v1";
  let parameters = (ins VHLO_Dims:$bounds);
  let assemblyFormat = "`<` struct(params) `>`";
}


def VHLO_ResultAccuracyAttrV1 : VHLO_AttrDef<"ResultAccuracyV1", "1.9.0", "current"> {
  let mnemonic = "result_accuracy_v1";
  let summary = "The requested accuracy for transcendental unary ops.";
  let parameters = (ins
      VHLO_APFloatV1:$atol,
      VHLO_APFloatV1:$rtol,
      "int64_t":$ulps,
      "mlir::Attribute":$mode
  );
  let assemblyFormat = "`<` struct(params) `>`";
  let genVerifyDecl = 1;
  let extraClassDefinition = [{
    LogicalResult ResultAccuracyV1Attr::verify(
        llvm::function_ref<mlir::InFlightDiagnostic ()> errFn,
        APFloat atol, APFloat rtol, int64_t ulps,
        mlir::Attribute mode) {
          if (!isFromVhlo(mode)) return errFn() << "expected VHLO result accuracy mode";
          return success();
        }
  }];
}

#endif // STABLEHLO_DIALECT_VHLO_ATTRS
