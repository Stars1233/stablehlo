<!-- Autogenerated by mlir-tblgen; don't manually edit -->

### `-stablehlo-legalize-to-tosa`

_Legalize StableHLO to TOSA_

### `-stablehlo-prepare-for-tosa`

_Prepare StableHLO for legalization to TOSA_

This pass adds rewriters to make StableHLO ops more compatible with TOSA ops.
Currently simplifies stablehlo.dot_general into stablehlo.dot for easier lowering.

### `-stablehlo-quant-legalize-to-tosa-rescale`

_Legalize StableHLO Quantized operations to TOSA rescale operations_

This pass rewrites StableHLO quantized operations to integer operations
by inserting TOSA rescale operations at the inputs and outputs of the
integer operations.

### `-tosa-rescale-legalize-to-stablehlo`

_Legalize TOSA rescales to StableHlo primitive math operations_

This pass rewrites TOSA rescale operations to StableHLO primitive math operations.
