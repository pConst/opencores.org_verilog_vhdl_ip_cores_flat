//----------------------------------------------------------------------//
// The MIT License 
// 
// Copyright (c) 2008 Abhinav Agarwal, Alfred Man Cheuk Ng
// Contact: abhiag@gmail.com
// 
// Permission is hereby granted, free of charge, to any person 
// obtaining a copy of this software and associated documentation 
// files (the "Software"), to deal in the Software without 
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//----------------------------------------------------------------------//

#include "global_rs.h"
#include "gf_arith.h"
#include "error_correct.h"

// Directive: Synthesize independently
void error_correct( unsigned char k, unsigned char in_data[kk], unsigned char err[kk], 
                    unsigned char out_data[kk])
{
    for (int i = 0; i < kk; i++)
        out_data[i] = gfadd_hw(in_data[i],err[i]); 
}
