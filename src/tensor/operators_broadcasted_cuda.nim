# Copyright 2017 Mamy André-Ratsimbazafy
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import  ./private/p_init_cuda,
        ./private/p_kernels_interface_cuda,
        ./private/p_checks,
        ./data_structure,
        ./higher_order,
        ./shapeshifting_cuda

include ./private/incl_accessors_cuda,
        ./private/incl_higher_order_cuda,
        ./private/incl_kernels_cuda

# #########################################################
# # Broadcasting Tensor-Tensor
# # And element-wise multiplication (Hadamard) and division

proc `.+`*[T: SomeReal](a, b: CudaTensor[T]): CudaTensor[T] {.noInit,inline.} =
  ## Broadcasted addition for tensors of incompatible but broadcastable shape.
  let (tmp_a, tmp_b) = unsafeBroadcast2(a, b)
  return tmp_a + tmp_b

proc `.-`*[T: SomeReal](a, b: CudaTensor[T]): CudaTensor[T] {.noInit,inline.} =
  ## Broadcasted addition for tensors of incompatible but broadcastable shape.
  let (tmp_a, tmp_b) = unsafeBroadcast2(a, b)
  return tmp_a - tmp_b

cuda_binary_glue("cuda_Mul", "MulOp", cuda_Mul)

proc `.*`*[T: SomeReal](a,b: CudaTensor[T]): CudaTensor[T] {.noInit.} =
  ## Element-wise multiplication (Hadamard product).
  ##
  ## And broadcasted element-wise multiplication.

  let (tmp_a, tmp_b) = unsafeBroadcast2(a, b)

  result = newCudaTensor[T](tmp_a.shape)
  cuda_binary_call(cuda_Mul, result, tmp_a, tmp_b)

cuda_binary_glue("cuda_Div", "DivOp", cuda_Div)

proc `./`*[T: SomeReal](a,b: CudaTensor[T]): CudaTensor[T] {.noInit.} =
  ## CudaTensor substraction

  let (tmp_a, tmp_b) = unsafeBroadcast2(a, b)

  result = newCudaTensor[T](tmp_a.shape)
  cuda_binary_call(cuda_Div, result, tmp_a, tmp_b)
