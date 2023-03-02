// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xui16>, tensor<2x7xui16>)
    %2 = call @expected() : () -> tensor<5x6x7xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xui16>, tensor<2x2xi32>, tensor<2x7xui16>) -> tensor<5x6x7xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xui16>, tensor<5x6x7xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xui16>, tensor<2x7xui16>) {
    %0 = stablehlo.constant dense<"0x020003000200020003000400030000000300080005000100060001000300030000000000010000000000020000000400030000000100040004000400010000000000020003000100070002000300020006000000050000000700000002000300020000000300000004000100010003000100020000000200000001000100030006000400030002000100030001000400010000000100030003000000000001000800050001000000010004000300010003000000010004000200020002000100070003000300020001000400010001000200000003000000010002000000060004000100030001000000030003000100030000000100010003000300020002000400030001000000010001000000010002000300050002000100040000000000000001000100010000000600030003000000000001000200000002000000010002000300070004000000020002000000040004000000010002000400000002000500010002000700000005000200010002000000000002000200000001000300020002000000010000000400010003000000020004000000000000000600030003000300"> : tensor<5x6x7xui16>
    %1 = stablehlo.constant dense<[[5, 1, 3, 4, 2, 3, 6], [0, 3, 3, 3, 0, 1, 0]]> : tensor<2x7xui16>
    return %0, %1 : tensor<5x6x7xui16>, tensor<2x7xui16>
  }
  func.func private @expected() -> tensor<5x6x7xui16> {
    %0 = stablehlo.constant dense<"0x020003000200020003000400030005000300080005000200060006000300030000000000010000000000020000000400030000000100040004000400010000000000020003000100070002000300020006000000050000000700000002000300020000000300000004000100010003000100020000000200000001000100030006000400030002000100030001000400010000000100030003000000000001000800050001000000010004000300010003000000010004000200020002000100070003000300020001000400010001000200000003000300030002000100060004000100030001000000030003000100030000000100010003000300020002000400030001000000010001000000010002000300050002000100040000000000000001000100010000000600030003000000000001000200000002000000010002000300070004000000020002000000040004000000010002000400000002000500010002000700000005000200010002000000000002000200000001000300020002000000010000000400010003000000020004000000000000000600030003000300"> : tensor<5x6x7xui16>
    return %0 : tensor<5x6x7xui16>
  }
}
