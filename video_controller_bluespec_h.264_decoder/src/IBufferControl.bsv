
// The MIT License

// Copyright (c) 2006-2007 Massachusetts Institute of Technology

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//**********************************************************************
// Interface for Buffer Controller
//----------------------------------------------------------------------
//
//
//

package IBufferControl;

import H264Types::*;
import GetPut::*;
import ClientServer::*;

interface IBufferControl;

   // Interface for inter-module io
   interface Put#(DeblockFilterOT) ioin;
   interface Get#(BufferControlOT) ioout;

   // Interface for module to frame buffer
   interface Client#(FrameBufferLoadReq,FrameBufferLoadResp) buffer_client_load1;
   interface Client#(FrameBufferLoadReq,FrameBufferLoadResp) buffer_client_load2;
   interface Get#(FrameBufferStoreReq) buffer_client_store;

   // Interface for module to interpolation
   interface Server#(InterpolatorLoadReq,InterpolatorLoadResp) inter_server;	 

endinterface

endpackage

