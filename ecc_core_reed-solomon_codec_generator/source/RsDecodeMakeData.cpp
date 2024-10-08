//===================================================================
// Module Name : RsDecodeMakeData
// File Name   : RsDecodeMakeData.cpp
// Function    : RS Decoder data maker
// 
// Revision History:
// Date          By           Version    Change Description
//===================================================================
// 2009/02/03  Gael Sapience     1.0       Original
//
//===================================================================
// (C) COPYRIGHT 2009 SYSTEM LSI CO., Ltd.
//
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <time.h>
#include <string.h>


FILE  *OutFileRsDecIn;
FILE  *OutFileRsDecOut;

void RsGfMultiplier( int*, int*,int*, int, int);
void RsDecodeEmulator(int*, int*, int*, int*, int, int, int, int, int*, int*, int*, int*, int*);


void RsDecodeMakeData(int DataSize, int TotalSize, int PrimPoly, int bitSymbol, int ErasureOption, int delayDataIn, int BlockAmount, int ErrorRate, int PowerErrorRate, int ErasureRate, int PowerErasureRate, int *coeffTab, int *MrefTab, int *PrefTab, int errorStats, int passFailFlag, int encDecMode, int encBlockAmount, int pathFlag, int lengthPath, char *rootFolderPath) {


   //---------------------------------------------------------------
   // syndrome length calculation
   //---------------------------------------------------------------
   int syndromeLength;
   syndromeLength = TotalSize - DataSize;


   //---------------------------------------------------------------
   // C++ variables
   //---------------------------------------------------------------
   int ii,jj, kk,loop;
   int maxValue;
   int bbb;
   int sync_flag;
   int mmTabSize = (bitSymbol*2) -1;
   int bidonTabSize;
   int symbolMax;
   int LoopSize;
   int Pidx;
   int init;
   int idx2;
   int idx1;
   int tempNum;
   int feedback;
   int zz;
   int rsLoop;
   int errCount;
   int errError;
   int errErasure;
   int errData;
   int chanceError;
   int chanceErasure;
   int paddingLength;
   int delay;
   int ErrorNumBKP;
   int ErasureNumBKP;
   int RTLfailFlagBKP;
   int ThErrorNumBKP;
   int ThErasureNumBKP;
   int ThSyndromeBKP;
   int *ErasureTab;
   int *dataEncoded;
   int *dataPure;
   int *powerTab;
   int *feedbackTab;
   int *productTab;
   int *genCoeffTab;
   int *syndromeRegTab;
   int *redundancySymbols;
   int *dataIn;
   int *euclideTab;
   int *ttTab;
   int *bbTab;
   int *ppTab;
   int *bidon;
   int *bidonTab0;
   int *bidonTab1;
   int *bidonTab2;
   int *bidonTab3;
   int *bidonTab4;
   int *bidonTab5;
   int *bidonTab6;
   int *bidonTab7;
   int *bidonTab8;
   int *bidonTab9;
   int *bidonTab10;
   int *bidonTab11;
   int *ErrorNum;
   int *ErasureNum;
   int *RTLDataOut;
   int *RTLfailFlag;
   char *strRsDecIn;
   char *strRsDecOut;


  //---------------------------------------------------------------
  // maxValue
  //---------------------------------------------------------------
   maxValue = 1;
   for(ii=0; ii<(bitSymbol); ii++){
      maxValue = maxValue*2;
   }


   bidonTabSize = 1;
   for (ii=0;ii<(bitSymbol);ii++){
      bidonTabSize= 2* bidonTabSize;
   }
   symbolMax = bidonTabSize;
   bidonTabSize= bitSymbol* bidonTabSize;


   dataIn            = new int[DataSize];
   euclideTab        = new int[(syndromeLength+1)];
   ttTab             = new int[bitSymbol];
   bbTab             = new int[bitSymbol];
   ppTab             = new int[bitSymbol];
   bidon             = new int[bitSymbol];
   bidonTab0         = new int[bidonTabSize];
   bidonTab1         = new int[bidonTabSize];
   bidonTab2         = new int[bidonTabSize];
   bidonTab3         = new int[bidonTabSize];
   bidonTab4         = new int[bidonTabSize];
   bidonTab5         = new int[bidonTabSize];
   bidonTab6         = new int[bidonTabSize];
   bidonTab7         = new int[bidonTabSize];
   bidonTab8         = new int[bidonTabSize];
   bidonTab9         = new int[bidonTabSize];
   bidonTab10        = new int[bidonTabSize];
   bidonTab11        = new int[bidonTabSize];
   feedbackTab       = new int[bitSymbol];
   productTab        = new int[bitSymbol];
   genCoeffTab       = new int[bitSymbol];
   syndromeRegTab    = new int[symbolMax*bitSymbol];
   redundancySymbols = new int[symbolMax];
   powerTab          = new int[bitSymbol];
   ErasureTab        = new int[TotalSize];
   dataEncoded       = new int[TotalSize];
   dataPure          = new int[TotalSize];
   ErrorNum          = new int[bitSymbol];
   ErasureNum        = new int[bitSymbol];
   RTLDataOut        = new int[TotalSize];
   RTLfailFlag       = new int[bitSymbol];


   ErrorNumBKP     = 0;
   ErasureNumBKP   = 0;
   RTLfailFlagBKP  = 0;
   ThErrorNumBKP   = 0;
   ThErasureNumBKP = 0;
   ThSyndromeBKP   = 0;


   //---------------------------------------------------------------
   // open file
   //---------------------------------------------------------------
//   strRsDecIn = (char *)calloc(lengthPath + 15,  sizeof(char));
   strRsDecIn = (char *)calloc(lengthPath + 17,  sizeof(char));
   if (pathFlag == 0) { 
        strRsDecIn[0] = '.';
   }else{
      for(ii=0; ii<lengthPath; ii++){
         strRsDecIn[ii] = rootFolderPath[ii];
      }
   }
//   strcat(strRsDecIn, "/sim/RsDecIn.v");
   strcat(strRsDecIn, "/sim/RsDecIn.hex");

   OutFileRsDecIn = fopen(strRsDecIn,"w");


//   strRsDecOut = (char *)calloc(lengthPath + 16,  sizeof(char));
   strRsDecOut = (char *)calloc(lengthPath + 18,  sizeof(char));
   if (pathFlag == 0) { 
        strRsDecOut[0] = '.';
   }else{
      for(ii=0; ii<lengthPath; ii++){
         strRsDecOut[ii] = rootFolderPath[ii];
      }
   }
//   strcat(strRsDecOut, "/sim/RsDecOut.v");
   strcat(strRsDecOut, "/sim/RsDecOut.hex");

   OutFileRsDecOut = fopen(strRsDecOut,"w");



   //---------------------------------------------------------------
   // random generator
   //---------------------------------------------------------------
   srand (time (NULL));


   //---------------------------------------------------------------
   // write Headers
   //---------------------------------------------------------------
   fprintf(OutFileRsDecIn, "// SYNC, ENABLE, ERASURE_IN, DATA[7:0]\n");
   fprintf(OutFileRsDecOut, "// Error Amount, Erasure Amount, DATA[7:0]\n");


   //------------------------------------------------------------------------
   //- Euclide Length calculation
   //------------------------------------------------------------------------
   euclideTab [syndromeLength] = 3;
   euclideTab [syndromeLength-1] = 3;

   for(ii=(syndromeLength-2); ii>0; ii=ii-2){
      euclideTab [ii] = euclideTab   [ii+2] + 6;
      euclideTab [ii-1] = euclideTab [ii+1] + 6;
   }

   euclideTab [0] = euclideTab [2] + 6;


   //------------------------------------------------------------------------
   // initialize LoopSize
   //------------------------------------------------------------------------
   LoopSize = 2;
   for(ii=0; ii<(bitSymbol-1); ii++){
      LoopSize = LoopSize*2;
   }


   //------------------------------------------------------------------------
   //initialize ttTab
   //------------------------------------------------------------------------
   ttTab[0] = 1;

   for (ii=1;ii<bitSymbol;ii++){
      ttTab[ii] = 0;
   }


   //------------------------------------------------------------------------
   // initialize bbTab
   //------------------------------------------------------------------------
   bbTab[0] = 0;
   bbTab[1] = 1;
   for (ii=2;ii<bitSymbol;ii++){
      bbTab[ii] = 0;
   }


   //------------------------------------------------------------------------
   //------------------------------------------------------------------------
   for(ii=0; ii<(LoopSize-1); ii++){

      //------------------------------------------------------------------------
      // Galois Field Multiplier
      //------------------------------------------------------------------------
      RsGfMultiplier(ppTab, ttTab, bbTab, PrimPoly, bitSymbol);


      //------------------------------------------------------------------------
      // assign multiplier results
      //------------------------------------------------------------------------
      for (jj=0;jj<bitSymbol;jj++){
         ttTab[jj] = ppTab[jj];
      }


      //------------------------------------------------------------------------
      // write P_OUT[0]
      //------------------------------------------------------------------------
      for (Pidx=0; Pidx<bitSymbol; Pidx++){
         init = 0;

         for (idx2=0; idx2<bitSymbol;idx2++){
            bidon [idx2] = 0;
         }
         for (idx1=0; idx1<mmTabSize;idx1++){
            tempNum = PrefTab [Pidx*mmTabSize+idx1];
            if (tempNum == 1) {
               //------------------------------------------------------------------------
               // search
               //------------------------------------------------------------------------
               for (idx2=0; idx2<bitSymbol;idx2++){
                  tempNum = MrefTab[idx1*bitSymbol+idx2];
                  if ((tempNum > 0) && (ttTab[tempNum-1] == 1)) {
                     if  (bidon [idx2] == 0) {
                        bidon [idx2] = 1;
                     }
                     else {
                        bidon [idx2] = 0;
                     }
                  }
               }
            }
         }
         if (Pidx==0) { 
            for (jj=0;jj<bitSymbol;jj++){
               bidonTab0[ii*bitSymbol+jj] = bidon[jj];
            }
         }
         if (Pidx==1) {
            for (jj=0;jj<bitSymbol;jj++){
               bidonTab1[ii*bitSymbol+jj] = bidon[jj];
            }
         }
         if (Pidx==2) {
            for (jj=0;jj<bitSymbol;jj++){
               bidonTab2[ii*bitSymbol+jj] = bidon[jj];
            }
         }
         if (Pidx==3) {
            for (jj=0;jj<bitSymbol;jj++){
               bidonTab3[ii*bitSymbol+jj] = bidon[jj];
            }
         }
         if (Pidx==4) {
            for (jj=0;jj<bitSymbol;jj++){
               bidonTab4[ii*bitSymbol+jj] = bidon[jj];
            }
         }
         if (Pidx==5) {
            for (jj=0;jj<bitSymbol;jj++){
               bidonTab5[ii*bitSymbol+jj] = bidon[jj];
            }
         }
         if (Pidx==6) {
            for (jj=0;jj<bitSymbol;jj++){
               bidonTab6[ii*bitSymbol+jj] = bidon[jj];
            }
         }
         if (Pidx==7) {
            for (jj=0;jj<bitSymbol;jj++){
               bidonTab7[ii*bitSymbol+jj] = bidon[jj];
            }
         }

         if (Pidx==8) {
            for (jj=0;jj<bitSymbol;jj++){
               bidonTab8[ii*bitSymbol+jj] = bidon[jj];
            }
         }
         if (Pidx==9) {
            for (jj=0;jj<bitSymbol;jj++){
               bidonTab9[ii*bitSymbol+jj] = bidon[jj];
            }
         }
         if (Pidx==10) {
            for (jj=0;jj<bitSymbol;jj++){
               bidonTab10[ii*bitSymbol+jj] = bidon[jj];
            }
         }
         if (Pidx==11) {
            for (jj=0;jj<bitSymbol;jj++){
               bidonTab11[ii*bitSymbol+jj] = bidon[jj];
            }
         }
         //------------------------------------------------------------------------
         // printf
         //------------------------------------------------------------------------
      }
   }


   //------------------------------------------------------------------------
   // initialize feedbackTab, productTab, genCoeffTab
   //------------------------------------------------------------------------
   for (ii=0;ii<(bitSymbol);ii++){
      feedbackTab [ii] = 0;
      productTab [ii] = 0;
      genCoeffTab [ii] = 0;
   }


   //---------------------------------------------------------------
   // initialize powerTab
   //---------------------------------------------------------------
   powerTab[0] = 1;
   for (ii=1; ii<bitSymbol;ii++){
      powerTab[ii] = 2*powerTab[ii-1];
   }


   //---------------------------------------------------------------
   // RSDecode codewords construction
   //---------------------------------------------------------------
   for (loop=0; loop<BlockAmount;loop++){

      //---------------------------------------------------------------
      // Input data generation
      //---------------------------------------------------------------
      for (ii=0; ii<DataSize;ii++){
         bbb = rand () & ((1 << bitSymbol) - 1);
         if (bbb == symbolMax) {
            bbb = symbolMax-1;
         }
         dataIn [ii] = bbb;
      }



      //---------------------------------------------------------------
      // Rs Encoder Data calculation
      //---------------------------------------------------------------
      for (rsLoop=0;rsLoop<DataSize; rsLoop++) {
         //---------------------------------------------------------------
         // assign feedback
         //---------------------------------------------------------------
         feedback = dataIn [rsLoop];
         // convert feedback to binary
         for (zz =bitSymbol-1; zz>=0;zz--) {
            if (feedback >= powerTab[zz]) {
               feedback = feedback -powerTab[zz];
               feedbackTab[zz] = 1;
            }else{
               feedbackTab[zz] = 0;
            }
         }

         if (rsLoop > 0) {
            for (zz=0;zz<bitSymbol;zz++){
               feedbackTab[zz] = feedbackTab[zz] ^ syndromeRegTab[(syndromeLength-1)*bitSymbol+zz];
            }
         }


         //---------------------------------------------------------------
         // multiply feedback by genCoeffTab
         //---------------------------------------------------------------
         for (zz =syndromeLength-1; zz>=0;zz--) {
            if (coeffTab[zz] > 0) {
               tempNum =coeffTab[zz]-1;


               switch(bitSymbol)
                  {
                     case (3):
                        productTab[0] = (bidonTab0[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab0[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab0[tempNum*bitSymbol+2] & feedbackTab[2]);
                        productTab[1] = (bidonTab1[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab1[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab1[tempNum*bitSymbol+2] & feedbackTab[2]);
                        productTab[2] = (bidonTab2[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab2[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab2[tempNum*bitSymbol+2] & feedbackTab[2]);
                     break;
                     case (4):
                        productTab[0] = (bidonTab0[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab0[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab0[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab0[tempNum*bitSymbol+3] & feedbackTab[3]);
                        productTab[1] = (bidonTab1[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab1[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab1[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab1[tempNum*bitSymbol+3] & feedbackTab[3]);
                        productTab[2] = (bidonTab2[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab2[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab2[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab2[tempNum*bitSymbol+3] & feedbackTab[3]);
                        productTab[3] = (bidonTab3[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab3[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab3[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab3[tempNum*bitSymbol+3] & feedbackTab[3]);
                     break;
                     case (5):
                        productTab[0] = (bidonTab0[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab0[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab0[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab0[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab0[tempNum*bitSymbol+4] & feedbackTab[4]);
                        productTab[1] = (bidonTab1[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab1[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab1[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab1[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab1[tempNum*bitSymbol+4] & feedbackTab[4]);
                        productTab[2] = (bidonTab2[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab2[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab2[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab2[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab2[tempNum*bitSymbol+4] & feedbackTab[4]);
                        productTab[3] = (bidonTab3[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab3[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab3[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab3[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab3[tempNum*bitSymbol+4] & feedbackTab[4]);
                        productTab[4] = (bidonTab4[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab4[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab4[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab4[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab4[tempNum*bitSymbol+4] & feedbackTab[4]);
                     break;
                     case (6):
                        productTab[0] = (bidonTab0[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab0[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab0[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab0[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab0[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab0[tempNum*bitSymbol+5] & feedbackTab[5]);
                        productTab[1] = (bidonTab1[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab1[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab1[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab1[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab1[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab1[tempNum*bitSymbol+5] & feedbackTab[5]);
                        productTab[2] = (bidonTab2[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab2[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab2[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab2[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab2[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab2[tempNum*bitSymbol+5] & feedbackTab[5]);
                        productTab[3] = (bidonTab3[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab3[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab3[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab3[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab3[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab3[tempNum*bitSymbol+5] & feedbackTab[5]);
                        productTab[4] = (bidonTab4[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab4[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab4[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab4[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab4[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab4[tempNum*bitSymbol+5] & feedbackTab[5]);
                        productTab[5] = (bidonTab5[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab5[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab5[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab5[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab5[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab5[tempNum*bitSymbol+5] & feedbackTab[5]);
                     break;
                     case (7):
                        productTab[0] = (bidonTab0[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab0[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab0[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab0[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab0[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab0[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab0[tempNum*bitSymbol+6] & feedbackTab[6]);
                        productTab[1] = (bidonTab1[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab1[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab1[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab1[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab1[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab1[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab1[tempNum*bitSymbol+6] & feedbackTab[6]);
                        productTab[2] = (bidonTab2[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab2[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab2[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab2[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab2[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab2[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab2[tempNum*bitSymbol+6] & feedbackTab[6]);
                        productTab[3] = (bidonTab3[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab3[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab3[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab3[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab3[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab3[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab3[tempNum*bitSymbol+6] & feedbackTab[6]);
                        productTab[4] = (bidonTab4[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab4[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab4[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab4[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab4[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab4[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab4[tempNum*bitSymbol+6] & feedbackTab[6]);
                        productTab[5] = (bidonTab5[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab5[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab5[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab5[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab5[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab5[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab5[tempNum*bitSymbol+6] & feedbackTab[6]);
                        productTab[6] = (bidonTab6[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab6[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab6[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab6[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab6[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab6[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab6[tempNum*bitSymbol+6] & feedbackTab[6]);
                     break;
                     case (8):
                        productTab[0] = (bidonTab0[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab0[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab0[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab0[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab0[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab0[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab0[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab0[tempNum*bitSymbol+7] & feedbackTab[7]);
                        productTab[1] = (bidonTab1[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab1[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab1[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab1[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab1[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab1[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab1[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab1[tempNum*bitSymbol+7] & feedbackTab[7]);
                        productTab[2] = (bidonTab2[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab2[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab2[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab2[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab2[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab2[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab2[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab2[tempNum*bitSymbol+7] & feedbackTab[7]);
                        productTab[3] = (bidonTab3[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab3[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab3[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab3[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab3[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab3[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab3[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab3[tempNum*bitSymbol+7] & feedbackTab[7]);
                        productTab[4] = (bidonTab4[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab4[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab4[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab4[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab4[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab4[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab4[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab4[tempNum*bitSymbol+7] & feedbackTab[7]);
                        productTab[5] = (bidonTab5[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab5[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab5[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab5[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab5[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab5[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab5[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab5[tempNum*bitSymbol+7] & feedbackTab[7]);
                        productTab[6] = (bidonTab6[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab6[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab6[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab6[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab6[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab6[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab6[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab6[tempNum*bitSymbol+7] & feedbackTab[7]);
                        productTab[7] = (bidonTab7[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab7[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab7[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab7[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab7[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab7[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab7[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab7[tempNum*bitSymbol+7] & feedbackTab[7]);
                     break;
                     case  (9):
                        productTab[0] = (bidonTab0[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab0[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab0[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab0[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab0[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab0[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab0[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab0[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab0[tempNum*bitSymbol+8] & feedbackTab[8]);
                        productTab[1] = (bidonTab1[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab1[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab1[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab1[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab1[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab1[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab1[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab1[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab1[tempNum*bitSymbol+8] & feedbackTab[8]);
                        productTab[2] = (bidonTab2[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab2[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab2[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab2[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab2[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab2[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab2[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab2[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab2[tempNum*bitSymbol+8] & feedbackTab[8]);
                        productTab[3] = (bidonTab3[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab3[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab3[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab3[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab3[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab3[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab3[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab3[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab3[tempNum*bitSymbol+8] & feedbackTab[8]);
                        productTab[4] = (bidonTab4[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab4[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab4[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab4[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab4[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab4[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab4[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab4[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab4[tempNum*bitSymbol+8] & feedbackTab[8]);
                        productTab[5] = (bidonTab5[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab5[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab5[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab5[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab5[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab5[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab5[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab5[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab5[tempNum*bitSymbol+8] & feedbackTab[8]);
                        productTab[6] = (bidonTab6[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab6[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab6[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab6[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab6[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab6[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab6[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab6[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab6[tempNum*bitSymbol+8] & feedbackTab[8]);
                        productTab[7] = (bidonTab7[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab7[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab7[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab7[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab7[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab7[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab7[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab7[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab7[tempNum*bitSymbol+8] & feedbackTab[8]);
                        productTab[8] = (bidonTab8[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab8[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab8[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab8[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab8[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab8[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab8[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab8[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab8[tempNum*bitSymbol+8] & feedbackTab[8]);
                     break;
                     case(10):
                        productTab[0] = (bidonTab0[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab0[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab0[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab0[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab0[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab0[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab0[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab0[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab0[tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab0[tempNum*bitSymbol+9] & feedbackTab[9]);
                        productTab[1] = (bidonTab1[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab1[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab1[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab1[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab1[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab1[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab1[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab1[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab1[tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab1[tempNum*bitSymbol+9] & feedbackTab[9]);
                        productTab[2] = (bidonTab2[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab2[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab2[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab2[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab2[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab2[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab2[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab2[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab2[tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab2[tempNum*bitSymbol+9] & feedbackTab[9]);
                        productTab[3] = (bidonTab3[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab3[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab3[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab3[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab3[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab3[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab3[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab3[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab3[tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab3[tempNum*bitSymbol+9] & feedbackTab[9]);
                        productTab[4] = (bidonTab4[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab4[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab4[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab4[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab4[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab4[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab4[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab4[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab4[tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab4[tempNum*bitSymbol+9] & feedbackTab[9]);
                        productTab[5] = (bidonTab5[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab5[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab5[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab5[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab5[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab5[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab5[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab5[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab5[tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab5[tempNum*bitSymbol+9] & feedbackTab[9]);
                        productTab[6] = (bidonTab6[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab6[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab6[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab6[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab6[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab6[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab6[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab6[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab6[tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab6[tempNum*bitSymbol+9] & feedbackTab[9]);
                        productTab[7] = (bidonTab7[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab7[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab7[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab7[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab7[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab7[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab7[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab7[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab7[tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab7[tempNum*bitSymbol+9] & feedbackTab[9]);
                        productTab[8] = (bidonTab8[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab8[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab8[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab8[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab8[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab8[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab8[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab8[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab8[tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab8[tempNum*bitSymbol+9] & feedbackTab[9]);
                        productTab[9] = (bidonTab9[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab9[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab9[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab9[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab9[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab9[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab9[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab9[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab9[tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab9[tempNum*bitSymbol+9] & feedbackTab[9]);
                     break;

                     case(11):
                        productTab[0]  = (bidonTab0 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab0 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab0 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab0 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab0 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab0 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab0 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab0 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab0 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab0 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab0 [tempNum*bitSymbol+10] & feedbackTab[10]);
                        productTab[1]  = (bidonTab1 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab1 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab1 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab1 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab1 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab1 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab1 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab1 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab1 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab1 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab1 [tempNum*bitSymbol+10] & feedbackTab[10]);
                        productTab[2]  = (bidonTab2 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab2 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab2 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab2 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab2 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab2 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab2 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab2 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab2 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab2 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab2 [tempNum*bitSymbol+10] & feedbackTab[10]);
                        productTab[3]  = (bidonTab3 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab3 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab3 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab3 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab3 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab3 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab3 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab3 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab3 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab3 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab3 [tempNum*bitSymbol+10] & feedbackTab[10]);
                        productTab[4]  = (bidonTab4 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab4 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab4 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab4 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab4 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab4 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab4 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab4 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab4 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab4 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab4 [tempNum*bitSymbol+10] & feedbackTab[10]);
                        productTab[5]  = (bidonTab5 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab5 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab5 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab5 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab5 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab5 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab5 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab5 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab5 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab5 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab5 [tempNum*bitSymbol+10] & feedbackTab[10]);
                        productTab[6]  = (bidonTab6 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab6 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab6 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab6 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab6 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab6 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab6 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab6 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab6 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab6 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab6 [tempNum*bitSymbol+10] & feedbackTab[10]);
                        productTab[7]  = (bidonTab7 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab7 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab7 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab7 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab7 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab7 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab7 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab7 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab7 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab7 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab7 [tempNum*bitSymbol+10] & feedbackTab[10]);
                        productTab[8]  = (bidonTab8 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab8 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab8 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab8 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab8 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab8 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab8 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab8 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab8 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab8 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab8 [tempNum*bitSymbol+10] & feedbackTab[10]);
                        productTab[9]  = (bidonTab9 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab9 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab9 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab9 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab9 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab9 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab9 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab9 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab9 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab9 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab9 [tempNum*bitSymbol+10] & feedbackTab[10]);
                        productTab[10] = (bidonTab10[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab10[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab10[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab10[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab10[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab10[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab10[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab10[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab10[tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab10[tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab10[tempNum*bitSymbol+10] & feedbackTab[10]);
                     break;

                     case(12):
                        productTab[0]  = (bidonTab0 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab0 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab0 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab0 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab0 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab0 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab0 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab0 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab0 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab0 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab0 [tempNum*bitSymbol+10] & feedbackTab[10]) ^ (bidonTab0 [tempNum*bitSymbol+11] & feedbackTab[11]);
                        productTab[1]  = (bidonTab1 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab1 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab1 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab1 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab1 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab1 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab1 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab1 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab1 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab1 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab1 [tempNum*bitSymbol+10] & feedbackTab[10]) ^ (bidonTab1 [tempNum*bitSymbol+11] & feedbackTab[11]);
                        productTab[2]  = (bidonTab2 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab2 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab2 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab2 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab2 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab2 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab2 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab2 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab2 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab2 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab2 [tempNum*bitSymbol+10] & feedbackTab[10]) ^ (bidonTab2 [tempNum*bitSymbol+11] & feedbackTab[11]);
                        productTab[3]  = (bidonTab3 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab3 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab3 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab3 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab3 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab3 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab3 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab3 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab3 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab3 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab3 [tempNum*bitSymbol+10] & feedbackTab[10]) ^ (bidonTab3 [tempNum*bitSymbol+11] & feedbackTab[11]);
                        productTab[4]  = (bidonTab4 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab4 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab4 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab4 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab4 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab4 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab4 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab4 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab4 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab4 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab4 [tempNum*bitSymbol+10] & feedbackTab[10]) ^ (bidonTab4 [tempNum*bitSymbol+11] & feedbackTab[11]);
                        productTab[5]  = (bidonTab5 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab5 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab5 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab5 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab5 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab5 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab5 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab5 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab5 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab5 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab5 [tempNum*bitSymbol+10] & feedbackTab[10]) ^ (bidonTab5 [tempNum*bitSymbol+11] & feedbackTab[11]);
                        productTab[6]  = (bidonTab6 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab6 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab6 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab6 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab6 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab6 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab6 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab6 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab6 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab6 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab6 [tempNum*bitSymbol+10] & feedbackTab[10]) ^ (bidonTab6 [tempNum*bitSymbol+11] & feedbackTab[11]);
                        productTab[7]  = (bidonTab7 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab7 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab7 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab7 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab7 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab7 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab7 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab7 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab7 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab7 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab7 [tempNum*bitSymbol+10] & feedbackTab[10]) ^ (bidonTab7 [tempNum*bitSymbol+11] & feedbackTab[11]);
                        productTab[8]  = (bidonTab8 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab8 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab8 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab8 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab8 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab8 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab8 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab8 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab8 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab8 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab8 [tempNum*bitSymbol+10] & feedbackTab[10]) ^ (bidonTab8 [tempNum*bitSymbol+11] & feedbackTab[11]);
                        productTab[9]  = (bidonTab9 [tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab9 [tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab9 [tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab9 [tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab9 [tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab9 [tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab9 [tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab9 [tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab9 [tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab9 [tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab9 [tempNum*bitSymbol+10] & feedbackTab[10]) ^ (bidonTab9 [tempNum*bitSymbol+11] & feedbackTab[11]);
                        productTab[10] = (bidonTab10[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab10[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab10[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab10[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab10[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab10[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab10[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab10[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab10[tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab10[tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab10[tempNum*bitSymbol+10] & feedbackTab[10]) ^ (bidonTab10[tempNum*bitSymbol+11] & feedbackTab[11]);
                        productTab[11] = (bidonTab11[tempNum*bitSymbol+0] & feedbackTab[0]) ^ (bidonTab11[tempNum*bitSymbol+1] & feedbackTab[1]) ^ (bidonTab11[tempNum*bitSymbol+2] & feedbackTab[2]) ^ (bidonTab11[tempNum*bitSymbol+3] & feedbackTab[3])  ^ (bidonTab11[tempNum*bitSymbol+4] & feedbackTab[4]) ^ (bidonTab11[tempNum*bitSymbol+5] & feedbackTab[5]) ^ (bidonTab11[tempNum*bitSymbol+6] & feedbackTab[6]) ^ (bidonTab11[tempNum*bitSymbol+7] & feedbackTab[7]) ^ (bidonTab11[tempNum*bitSymbol+8] & feedbackTab[8]) ^ (bidonTab11[tempNum*bitSymbol+9] & feedbackTab[9]) ^ (bidonTab11[tempNum*bitSymbol+10] & feedbackTab[10]) ^ (bidonTab11[tempNum*bitSymbol+11] & feedbackTab[11]);
                     break;

                     default:
                        productTab[0] = 0;
                     break;
                  }
            }else{
               
               switch(bitSymbol)
                  {
                     case (3):
                        productTab[0] = feedbackTab[0];
                        productTab[1] = feedbackTab[1];
                        productTab[2] = feedbackTab[2];
                     break;
                     case (4):
                        productTab[0] = feedbackTab[0];
                        productTab[1] = feedbackTab[1];
                        productTab[2] = feedbackTab[2];
                        productTab[3] = feedbackTab[3];
                     break;
                     case (5):
                        productTab[0] = feedbackTab[0];
                        productTab[1] = feedbackTab[1];
                        productTab[2] = feedbackTab[2];
                        productTab[3] = feedbackTab[3];
                        productTab[4] = feedbackTab[4];
                     break;
                     case (6):
                        productTab[0] = feedbackTab[0];
                        productTab[1] = feedbackTab[1];
                        productTab[2] = feedbackTab[2];
                        productTab[3] = feedbackTab[3];
                        productTab[4] = feedbackTab[4];
                        productTab[5] = feedbackTab[5];
                     break;
                     case (7):
                        productTab[0] = feedbackTab[0];
                        productTab[1] = feedbackTab[1];
                        productTab[2] = feedbackTab[2];
                        productTab[3] = feedbackTab[3];
                        productTab[4] = feedbackTab[4];
                        productTab[5] = feedbackTab[5];
                        productTab[6] = feedbackTab[6];
                     break;
                     case (8):
                        productTab[0] = feedbackTab[0];
                        productTab[1] = feedbackTab[1];
                        productTab[2] = feedbackTab[2];
                        productTab[3] = feedbackTab[3];
                        productTab[4] = feedbackTab[4];
                        productTab[5] = feedbackTab[5];
                        productTab[6] = feedbackTab[6];
                        productTab[7] = feedbackTab[7];
                     break;
                     case (9):
                        productTab[0] = feedbackTab[0];
                        productTab[1] = feedbackTab[1];
                        productTab[2] = feedbackTab[2];
                        productTab[3] = feedbackTab[3];
                        productTab[4] = feedbackTab[4];
                        productTab[5] = feedbackTab[5];
                        productTab[6] = feedbackTab[6];
                        productTab[7] = feedbackTab[7];
                        productTab[8] = feedbackTab[8];
                     break;
                     case (10):
                        productTab[0] = feedbackTab[0];
                        productTab[1] = feedbackTab[1];
                        productTab[2] = feedbackTab[2];
                        productTab[3] = feedbackTab[3];
                        productTab[4] = feedbackTab[4];
                        productTab[5] = feedbackTab[5];
                        productTab[6] = feedbackTab[6];
                        productTab[7] = feedbackTab[7];
                        productTab[8] = feedbackTab[8];
                        productTab[9] = feedbackTab[9];
                     break;
                     case (11):
                        productTab[0] = feedbackTab[0];
                        productTab[1] = feedbackTab[1];
                        productTab[2] = feedbackTab[2];
                        productTab[3] = feedbackTab[3];
                        productTab[4] = feedbackTab[4];
                        productTab[5] = feedbackTab[5];
                        productTab[6] = feedbackTab[6];
                        productTab[7] = feedbackTab[7];
                        productTab[8] = feedbackTab[8];
                        productTab[9] = feedbackTab[9];
                        productTab[10]= feedbackTab[10];
                     break;
                     case (12):
                        productTab[0] = feedbackTab[0];
                        productTab[1] = feedbackTab[1];
                        productTab[2] = feedbackTab[2];
                        productTab[3] = feedbackTab[3];
                        productTab[4] = feedbackTab[4];
                        productTab[5] = feedbackTab[5];
                        productTab[6] = feedbackTab[6];
                        productTab[7] = feedbackTab[7];
                        productTab[8] = feedbackTab[8];
                        productTab[9] = feedbackTab[9];
                        productTab[10]= feedbackTab[10];
                        productTab[11]= feedbackTab[11];
                     break;
                     default:
                     break;
                  }
            }


            //---------------------------------------------------------------
            // assign syndromes registers
            //---------------------------------------------------------------
            if (rsLoop == 0) {
               for (kk=0; kk< bitSymbol; kk++){
                  syndromeRegTab [zz*bitSymbol+kk] = productTab[kk];
               }
            }else{
               if (zz==0){
                  for (kk=0; kk< bitSymbol; kk++){
                     syndromeRegTab [kk] = productTab[kk];
                  }
               } else{
                  for (kk=0; kk< bitSymbol; kk++){
                     syndromeRegTab [zz*bitSymbol+kk] = syndromeRegTab [(zz-1)*bitSymbol+kk] ^ productTab[kk];
                  }
               }
            }
         }
      }


      //---------------------------------------------------------------
      // build redundancy symbols
      //---------------------------------------------------------------
      for (zz =0; zz<syndromeLength;zz++) {
         redundancySymbols [zz] = 0;
      }
      for (zz =0; zz<syndromeLength;zz++) {
         for (kk=0;kk<bitSymbol;kk++){
            redundancySymbols [syndromeLength-1-zz] = redundancySymbols [syndromeLength-1-zz] + syndromeRegTab[(zz*bitSymbol)+kk] * powerTab[kk];
         }
      }


      //---------------------------------------------------------------
      // build codeword Encoded
      //---------------------------------------------------------------
      for (zz =0; zz<DataSize;zz++) {
         dataEncoded[zz] = dataIn[zz];
         dataPure[zz] = dataIn[zz];
      }


      //---------------------------------------------------------------
      //---------------------------------------------------------------

      for (zz =0; zz<syndromeLength;zz++) {
         dataEncoded[zz+DataSize] = redundancySymbols[zz];
         dataPure[zz+DataSize] = redundancySymbols[zz];
      }

      //---------------------------------------------------------------
      // Make some noise !!!!!
      //---------------------------------------------------------------
      errCount = 0;
      errError = 0;
      errErasure = 0;
      for (ii = 0;ii<TotalSize;ii++){
        ErasureTab [ii] = 0;
      }


      for (ii=0;ii<TotalSize;ii++){


        switch(PowerErrorRate)
        {
         case (0):
            chanceError = (rand () % 100);
         break;
         case (1):
            chanceError = (rand () % 1000);
         break;
         case (2):
            chanceError = (rand () % 10000);
         break;
         case (3):
            chanceError = (rand () % 100000);
         break;
         case (4):
            chanceError = (rand () % 1000000);
         break;
         default:
            chanceError = 0;
         break;
        }


        switch(PowerErasureRate)
        {
         case (0):
            chanceErasure = (rand () % 100);
         break;
         case (1):
            chanceErasure = (rand () % 1000);
         break;
         case (2):
            chanceErasure = (rand () % 10000);
         break;
         case (3):
            chanceErasure = (rand () % 100000);
         break;
         case (4):
            chanceErasure = (rand () % 1000000);
         break;
         default:
            chanceErasure = 0;
         break;
        }



        if (chanceError < ErrorRate) {
           errData = rand () & ((1 << bitSymbol) - 1);
           if (errData == symbolMax){
              errData = symbolMax-1;
           }
           if (errData == dataEncoded[ii]) {
              if (errData == symbolMax-1){
                 errData = symbolMax-2;
              }else{
                 errData = errData+1;
              }
           }
           errCount = errCount+2;
           errError = errError +1;
           dataEncoded[ii] = errData;
        }else{
           if (ErasureOption == 1) {
              if (chanceErasure < ErasureRate) {
                 ErasureTab [ii] = 1;
                 errCount = errCount+1;
                 errErasure = errErasure + 1;
                 dataEncoded[ii] = 0;
              }
           }
        }
    }


      //---------------------------------------------------------------
      // RS decoder RTL emulator
      //---------------------------------------------------------------
      RsDecodeEmulator(ErrorNum, ErasureNum, RTLfailFlag, RTLDataOut, DataSize, TotalSize, PrimPoly, bitSymbol, MrefTab, PrefTab, coeffTab, dataEncoded, ErasureTab);
//      ErrorNum [0] = 0;
//      ErasureNum[0] = 0;
//      RTLfailFlag[0] = 0;
      

      //---------------------------------------------------------------
      // Write Data Decoder In
      //---------------------------------------------------------------
      fprintf(OutFileRsDecIn, "// WORD Number: %d\n", loop);
      fprintf(OutFileRsDecOut, "// WORD Number: %d\n", loop);

      sync_flag = 0;
      for (ii=0;ii<TotalSize;ii++){
         if (ii == 0) {
            sync_flag = 1;
         }else{
            sync_flag = 0;
         }

         fprintf(OutFileRsDecIn, "%d_%d_%d_%03X\n", sync_flag, 1, ErasureTab[ii], dataEncoded[ii]);
         fprintf(OutFileRsDecOut, "%03X_%03X_%03X_%d_%03X_%03X_%03X_%03X\n", ThSyndromeBKP , ThErrorNumBKP, ThErasureNumBKP, RTLfailFlagBKP, ErrorNumBKP, ErasureNumBKP, dataEncoded[ii],  RTLDataOut[ii]);
//         fprintf(OutFileRsDecOut, "%03X_%03X_%03X_%d_%03X_%03X_%03X_%03X\n", ThSyndromeBKP , ThErrorNumBKP, ThErasureNumBKP, RTLfailFlagBKP, ErrorNumBKP, ErasureNumBKP, dataEncoded[ii],  dataEncoded[ii]);
      }

      ThErrorNumBKP   = errError;
      ThErasureNumBKP = errErasure;
      ThSyndromeBKP   = syndromeLength;
      ErrorNumBKP     = ErrorNum[0];
      ErasureNumBKP   = ErasureNum[0];
      RTLfailFlagBKP  = RTLfailFlag[0];


      //---------------------------------------------------------------
      // padding if EUCLIDE ALGO is HUGE 
      //---------------------------------------------------------------
      if (euclideTab[0] > TotalSize) {
         paddingLength = euclideTab[0] - TotalSize;
         for (ii = 0;ii<paddingLength;ii++) {
                fprintf(OutFileRsDecIn, "0_1_0_000\n");
         }
      }
  }


  //---------------------------------------------------------------
  // padding for enable signal
  //---------------------------------------------------------------
   if (ErasureOption == 1) {
      delay = TotalSize + syndromeLength + 1 + euclideTab [0] + 5;
   }else{
      delay = TotalSize + euclideTab [0] + 5;
   }
   for (ii = 0;ii<(delay+1);ii++) {
         fprintf(OutFileRsDecIn, "0_1_0_000\n");
   }


  //---------------------------------------------------------------
  // close file
  //---------------------------------------------------------------
  fclose(OutFileRsDecIn);
  fclose(OutFileRsDecOut);


  //---------------------------------------------------------------
  // Free memory
  //---------------------------------------------------------------
   delete[] ErasureTab;
   delete[] dataEncoded;
   delete[] dataPure;
   delete[] powerTab;
   delete[] feedbackTab;
   delete[] productTab;
   delete[] genCoeffTab;
   delete[] syndromeRegTab;
   delete[] redundancySymbols;
   delete[] dataIn;
   delete[] euclideTab;
   delete[] ttTab;
   delete[] bbTab;
   delete[] ppTab;
   delete[] bidon;
   delete[] bidonTab0;
   delete[] bidonTab1;
   delete[] bidonTab2;
   delete[] bidonTab3;
   delete[] bidonTab4;
   delete[] bidonTab5;
   delete[] bidonTab6;
   delete[] bidonTab7;
   delete[] bidonTab8;
   delete[] bidonTab9;
   delete[] bidonTab10;
   delete[] bidonTab11;
   delete[] ErrorNum;
   delete[] ErasureNum;
   delete[] RTLDataOut;
   delete[] RTLfailFlag;


   //---------------------------------------------------------------
   // clean string
   //---------------------------------------------------------------
   free(strRsDecIn);
   free(strRsDecOut);


}
