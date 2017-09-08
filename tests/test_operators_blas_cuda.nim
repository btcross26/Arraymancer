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

import ../src/cuda
import unittest, future, math

suite "CUDA backend: BLAS (Basic Linear Algebra Subprograms)":
  test "Scalar/dot product":
    let u = @[1'f64, 3, -5].toTensor().cuda()
    let v = @[4'f64, -2, -1].toTensor().cuda()

    check: u .* v == 3.0

  test "Matrix and Vector in-place addition":
    var u = @[1'f64, 3, -5].toTensor().cuda()
    let v = @[4'f64, -2, -1].toTensor().cuda()

    u += v

    check: u.cpu() == @[5'f64, 1, -6].toTensor()


    let vandermonde = [[1,1,1],
                       [2,4,8],
                       [3,9,27]]

    let t = vandermonde.toTensor.astype(float32)

    var z = t.transpose.cuda()
    z += z

    check: z.cpu == [[2,4,6],
                     [2,8,18],
                     [2,16,54]].toTensor.astype(float32)

    let t2 = vandermonde.toTensor.astype(float32).cuda
    z += t2

    check: z.cpu == [[3,5,7],
                     [4,12,26],
                     [5,25,81]].toTensor.astype(float32)

  test "Matrix and vector addition":
    let u = @[1'f32, 3, -5].toTensor.cuda
    let v = @[1'f32, 1, 1].toTensor.cuda

    check: (u + v).cpu == @[2'f32, 4, -4].toTensor()

    let a = @[7.0, 4.0, 3.0, 1.0, 8.0, 6.0, 8.0, 1.0, 6.0, 2.0].toTensor.reshape([5,2]).cuda
    let b = @[6.0, 6.0, 2.0, 0.0, 4.0, 3.0, 2.0, 0.0, 0.0, 3.0].toTensor.reshape([5,2]).cuda

    let apb = @[13.0, 10.0, 5.0, 1.0, 12.0, 9.0, 10.0, 1.0, 6.0, 5.0].toTensor.reshape([5,2])

    check: (a + b).cpu == apb