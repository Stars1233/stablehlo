// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<i32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<15xbf16>
    %1 = call @expected() : () -> tensor<i32>
    %2 = call @argmax(%0) : (tensor<15xbf16>) -> tensor<i32>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<i32>, tensor<i32>) -> ()
    return %2 : tensor<i32>
  }
  func.func private @inputs() -> (tensor<15xbf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[-2.929690e-01, -4.250000e+00, -3.468750e+00, 5.468750e+00, 1.281250e+00, 4.937500e+00, -3.300780e-01, -6.328130e-01, 2.437500e+00, -1.728520e-01, 2.859380e+00, -4.281250e+00, 4.160160e-01, -3.984380e-01, 3.265630e+00]> : tensor<15xbf16>
    return %cst : tensor<15xbf16>
  }
  func.func private @expected() -> (tensor<i32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<3> : tensor<i32>
    return %c : tensor<i32>
  }
  func.func private @argmax(%arg0: tensor<15xbf16>) -> tensor<i32> {
    %0 = stablehlo.iota dim = 0 : tensor<15xi32>
    %cst = stablehlo.constant dense<0xFF80> : tensor<bf16>
    %c = stablehlo.constant dense<0> : tensor<i32>
    %1:2 = stablehlo.reduce(%arg0 init: %cst), (%0 init: %c) across dimensions = [0] : (tensor<15xbf16>, tensor<15xi32>, tensor<bf16>, tensor<i32>) -> (tensor<bf16>, tensor<i32>)
     reducer(%arg1: tensor<bf16>, %arg3: tensor<bf16>) (%arg2: tensor<i32>, %arg4: tensor<i32>)  {
      %2 = stablehlo.compare  GT, %arg1, %arg3,  FLOAT : (tensor<bf16>, tensor<bf16>) -> tensor<i1>
      %3 = stablehlo.compare  NE, %arg1, %arg1,  FLOAT : (tensor<bf16>, tensor<bf16>) -> tensor<i1>
      %4 = stablehlo.or %2, %3 : tensor<i1>
      %5 = stablehlo.compare  EQ, %arg1, %arg3,  FLOAT : (tensor<bf16>, tensor<bf16>) -> tensor<i1>
      %6 = stablehlo.compare  LT, %arg2, %arg4,  SIGNED : (tensor<i32>, tensor<i32>) -> tensor<i1>
      %7 = stablehlo.and %5, %6 : tensor<i1>
      %8 = stablehlo.or %4, %7 : tensor<i1>
      %9 = stablehlo.select %4, %arg1, %arg3 : tensor<i1>, tensor<bf16>
      %10 = stablehlo.select %8, %arg2, %arg4 : tensor<i1>, tensor<i32>
      stablehlo.return %9, %10 : tensor<bf16>, tensor<i32>
    }
    return %1#1 : tensor<i32>
  }
}