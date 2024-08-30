// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<1x5xf32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<10> : tensor<1xi64>
    %0:2 = call @inputs() : () -> (tensor<1x5xf32>, tensor<1xf32>)
    %1 = call @expected() : () -> tensor<1x5xf32>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>}> ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %3 = stablehlo.maximum %arg0, %arg1 : tensor<f32>
      stablehlo.return %3 : tensor<f32>
    }) : (tensor<1x5xf32>, tensor<1xi64>, tensor<1xf32>) -> tensor<1x5xf32>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<1x5xf32>, tensor<1x5xf32>) -> ()
    return %2 : tensor<1x5xf32>
  }
  func.func private @inputs() -> (tensor<1x5xf32> {mhlo.layout_mode = "default"}, tensor<1xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[-1.02673471, 0.658179819, 1.61303246, 1.7966454, 3.93343282]]> : tensor<1x5xf32>
    %cst_0 = stablehlo.constant dense<0.390755326> : tensor<1xf32>
    return %cst, %cst_0 : tensor<1x5xf32>, tensor<1xf32>
  }
  func.func private @expected() -> (tensor<1x5xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[-1.02673471, 0.658179819, 1.61303246, 1.7966454, 3.93343282]]> : tensor<1x5xf32>
    return %cst : tensor<1x5xf32>
  }
}