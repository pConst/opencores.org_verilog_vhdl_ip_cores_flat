//Reed Solomon Program
//This program is based on Phil Karn
//Rewritten for YACC CPU (has no C library) by Tak.Sugawara Apr.3.2005
//Consideration for embedded CPU
// 1) Has no C library. Ex. Not have printf/random...
// 2) Not have plenty of stack 

#define POLY 0x80000057




#define print_port 0x3ff0
#define print_char_port 0x3ff1
#define print_int_port 0x3ff2
#define print_long_port 0x3ff4





#define uart_port		0x03ffc //for 16KRAM
#define uart_wport uart_port
#define uart_rport uart_port
#define int_set_address 0x03ff8 //for 16KRAM

//#define PC

void print_uart(unsigned char* ptr)// 
{
	unsigned int uport;
	#define WRITE_BUSY 0x0100


	while (*ptr) {
	
		do {
		  uport=*(volatile unsigned*)	uart_port;
		} while (uport & WRITE_BUSY);
		*(volatile unsigned char*)uart_wport=*(ptr++);
	}
	//*(volatile unsigned char*)uart_wport=0x00;//Write Done
}	


void putc_uart(unsigned char c)// 
{
	unsigned int uport;
	

	do {
		  uport=*(volatile unsigned*)	uart_port;
	} while (uport & WRITE_BUSY);
	*(volatile unsigned char*)uart_wport=c;
	
}	

unsigned char read_uart()//Verilog Test Bench Use 
{
		unsigned uport;
		uport= *(volatile unsigned *)uart_rport;
		return uport;
}	

void print(unsigned char* ptr)//Verilog Test Bench Use 
{

	while (*ptr) {
		#ifdef PC
			putchar(*(ptr++));
		#else	
		*(volatile unsigned char*)print_port=*(ptr++);
		#endif
	}
	#ifndef PC
		*(volatile unsigned char*)print_port=0x00;//Write Done
	#endif
}
void print_char(unsigned char val)//Little Endian write out 16bit number 
{
	#ifdef PC
		putchar(val);
	#else	
		*(volatile unsigned char*)print_port=(unsigned char)val ;
	#endif
}
void print_uchar(unsigned char val)//Little Endian write out 16bit number 
{
	#ifdef PC
	
		printf("%x",val);
	#else
	*(volatile unsigned char*)print_char_port=(unsigned char)val ;
	#endif	
}







static unsigned lfsr_state=1;

unsigned random (void)
{
  if (lfsr_state & 0x1)
    {
      lfsr_state = (lfsr_state >> 1) ^ POLY;
    }
  else
    {
      lfsr_state = (lfsr_state >> 1);
    }
  return lfsr_state;
}
/*
void print(unsigned char* ptr)
{
	while(*(ptr)) putchar(*(ptr++));	
	
}
*/	
void print_num(unsigned long num)
{
   unsigned long digit,offset;
   for(offset=1000;offset;offset/=10) {
      digit=num/offset;
      
      print_char(digit+'0');//putchar(digit+'0');
      num-=digit*offset;
   }
}

void memcpy(unsigned char* dest,unsigned char* source,unsigned size)
{
	unsigned i;
	for (i=0;i< size;i++){	
		*(dest++)=*(source++);
	}
}	

unsigned memcmp(unsigned char* dest,unsigned char* source,unsigned size)
{
	unsigned i;
	for (i=0;i< size;i++){	
		if (*(dest++)!=*(source++) ) return 1;
	}
	return 0;
}	
/*
 * Reed-Solomon coding and decoding
 * Phil Karn (karn@ka9q.ampr.org) September 1996
 * 
 * This file is derived from the program "new_rs_erasures.c" by Robert
 * Morelos-Zaragoza (robert@spectra.eng.hawaii.edu) and Hari Thirumoorthy
 * (harit@spectra.eng.hawaii.edu), Aug 1995
 *
 * I've made changes to improve performance, clean up the code and make it
 * easier to follow. Data is now passed to the encoding and decoding functions
 * through arguments rather than in global arrays. The decode function returns
 * the number of corrected symbols, or -1 if the word is uncorrectable.
 *
 * This code supports a symbol size from 2 bits up to 16 bits,
 * implying a block size of 3 2-bit symbols (6 bits) up to 65535
 * 16-bit symbols (1,048,560 bits). The code parameters are set in rs.h.
 *
 * Note that if symbols larger than 8 bits are used, the type of each
 * data array element switches from unsigned char to unsigned int. The
 * caller must ensure that elements larger than the symbol range are
 * not passed to the encoder or decoder.
 *
 */
//#include <stdio.h>
#include "rs.h"

#if (KK >= NN)
#error "KK must be less than 2**MM - 1"
#endif

/* This defines the type used to store an element of the Galois Field
 * used by the code. Make sure this is something larger than a char if
 * if anything larger than GF(256) is used.
 *
 * Note: unsigned char will work up to GF(256) but int seems to run
 * faster on the Pentium.
 */
typedef int gf;

/* Primitive polynomials - see Lin & Costello, Appendix A,
 * and  Lee & Messerschmitt, p. 453.
 */
#if(MM == 2)/* Admittedly silly */
int Pp[MM+1] = { 1, 1, 1 };

#elif(MM == 3)
/* 1 + x + x^3 */
int Pp[MM+1] = { 1, 1, 0, 1 };

#elif(MM == 4)
/* 1 + x + x^4 */
int Pp[MM+1] = { 1, 1, 0, 0, 1 };

#elif(MM == 5)
/* 1 + x^2 + x^5 */
int Pp[MM+1] = { 1, 0, 1, 0, 0, 1 };

#elif(MM == 6)
/* 1 + x + x^6 */
int Pp[MM+1] = { 1, 1, 0, 0, 0, 0, 1 };

#elif(MM == 7)
/* 1 + x^3 + x^7 */
int Pp[MM+1] = { 1, 0, 0, 1, 0, 0, 0, 1 };

#elif(MM == 8)
/* 1+x^2+x^3+x^4+x^8 */
int Pp[MM+1] = { 1, 0, 1, 1, 1, 0, 0, 0, 1 };

#elif(MM == 9)
/* 1+x^4+x^9 */
int Pp[MM+1] = { 1, 0, 0, 0, 1, 0, 0, 0, 0, 1 };

#elif(MM == 10)
/* 1+x^3+x^10 */
int Pp[MM+1] = { 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1 };

#elif(MM == 11)
/* 1+x^2+x^11 */
int Pp[MM+1] = { 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1 };

#elif(MM == 12)
/* 1+x+x^4+x^6+x^12 */
int Pp[MM+1] = { 1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1 };

#elif(MM == 13)
/* 1+x+x^3+x^4+x^13 */
int Pp[MM+1] = { 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1 };

#elif(MM == 14)
/* 1+x+x^6+x^10+x^14 */
int Pp[MM+1] = { 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1 };

#elif(MM == 15)
/* 1+x+x^15 */
int Pp[MM+1] = { 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 };

#elif(MM == 16)
/* 1+x+x^3+x^12+x^16 */
int Pp[MM+1] = { 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1 };

#else
#error "MM must be in range 2-16"
#endif

/* Alpha exponent for the first root of the generator polynomial */
#define B0	1

/* index->polynomial form conversion table */
gf Alpha_to[NN + 1];

/* Polynomial->index form conversion table */
gf Index_of[NN + 1];

/* No legal value in index form represents zero, so
 * we need a special value for this purpose
 */
#define A0	(NN)

/* Generator polynomial g(x)
 * Degree of g(x) = 2*TT
 * has roots @**B0, @**(B0+1), ... ,@^(B0+2*TT-1)
 */
gf Gg[NN - KK + 1];

/* Compute x % NN, where NN is 2**MM - 1,
 * without a slow divide
 */
static inline gf
modnn(int x)
{
//	print("modnn input="); print_num(x);
	while (x >= NN) {
		x -= NN;
		x = (x >> MM) + (x & NN);
	}
//	print("modnn output=");print_num(x);
//	print("\n");
	return x;
}

#define	min(a,b)	((a) < (b) ? (a) : (b))

#define	CLEAR(a,n) {	int ci;	for(ci=(n)-1;ci >=0;ci--)		(a)[ci] = 0;	}

#define	COPY(a,b,n) {	int ci;	for(ci=(n)-1;ci >=0;ci--)	(a)[ci] = (b)[ci];	}
#define	COPYDOWN(a,b,n) {	int ci;	for(ci=(n)-1;ci >=0;ci--) (a)[ci] = (b)[ci];	}

void init_rs(void)
{
	generate_gf();
	gen_poly();
}

/* generate GF(2**m) from the irreducible polynomial p(X) in p[0]..p[m]
   lookup tables:  index->polynomial form   alpha_to[] contains j=alpha**i;
                   polynomial form -> index form  index_of[j=alpha**i] = i
   alpha=2 is the primitive element of GF(2**m)
   HARI's COMMENT: (4/13/94) alpha_to[] can be used as follows:
        Let @ represent the primitive element commonly called "alpha" that
   is the root of the primitive polynomial p(x). Then in GF(2^m), for any
   0 <= i <= 2^m-2,
        @^i = a(0) + a(1) @ + a(2) @^2 + ... + a(m-1) @^(m-1)
   where the binary vector (a(0),a(1),a(2),...,a(m-1)) is the representation
   of the integer "alpha_to[i]" with a(0) being the LSB and a(m-1) the MSB. Thus for
   example the polynomial representation of @^5 would be given by the binary
   representation of the integer "alpha_to[5]".
                   Similarily, index_of[] can be used as follows:
        As above, let @ represent the primitive element of GF(2^m) that is
   the root of the primitive polynomial p(x). In order to find the power
   of @ (alpha) that has the polynomial representation
        a(0) + a(1) @ + a(2) @^2 + ... + a(m-1) @^(m-1)
   we consider the integer "i" whose binary representation with a(0) being LSB
   and a(m-1) MSB is (a(0),a(1),...,a(m-1)) and locate the entry
   "index_of[i]". Now, @^index_of[i] is that element whose polynomial 
    representation is (a(0),a(1),a(2),...,a(m-1)).
   NOTE:
        The element alpha_to[2^m-1] = 0 always signifying that the
   representation of "@^infinity" = 0 is (0,0,0,...,0).
        Similarily, the element index_of[0] = A0 always signifying
   that the power of alpha which has the polynomial representation
   (0,0,...,0) is "infinity".
 
*/

void
generate_gf(void)
{
	register int i, mask;

	mask = 1;
	Alpha_to[MM] = 0;
	for (i = 0; i < MM; i++) {
		Alpha_to[i] = mask;
		Index_of[Alpha_to[i]] = i;
		/* If Pp[i] == 1 then, term @^i occurs in poly-repr of @^MM */
		if (Pp[i] != 0)
			Alpha_to[MM] ^= mask;	/* Bit-wise EXOR operation */
		mask <<= 1;	/* single left-shift */
	}
	Index_of[Alpha_to[MM]] = MM;
	/*
	 * Have obtained poly-repr of @^MM. Poly-repr of @^(i+1) is given by
	 * poly-repr of @^i shifted left one-bit and accounting for any @^MM
	 * term that may occur when poly-repr of @^i is shifted.
	 */
	mask >>= 1;
	for (i = MM + 1; i < NN; i++) {
		if (Alpha_to[i - 1] >= mask)
			Alpha_to[i] = Alpha_to[MM] ^ ((Alpha_to[i - 1] ^ mask) << 1);
		else
			Alpha_to[i] = Alpha_to[i - 1] << 1;
		Index_of[Alpha_to[i]] = i;
	}
	Index_of[0] = A0;
	Alpha_to[NN] = 0;
	print("index dump\n");
    for (i=0;i<NN;i++){
		print_uchar(Index_of[i]);
		print(" ");	
	}
	print("\n");
	print("Alpha_to dump\n");
    for (i=0;i<NN;i++){
		print_uchar(Alpha_to[i]);
		print(" ");	
	}
	print("\n");
		
}


/*
 * Obtain the generator polynomial of the TT-error correcting, length
 * NN=(2**MM -1) Reed Solomon code from the product of (X+@**(B0+i)), i = 0,
 * ... ,(2*TT-1)
 *
 * Examples:
 *
 * If B0 = 1, TT = 1. deg(g(x)) = 2*TT = 2.
 * g(x) = (x+@) (x+@**2)
 *
 * If B0 = 0, TT = 2. deg(g(x)) = 2*TT = 4.
 * g(x) = (x+1) (x+@) (x+@**2) (x+@**3)
 */
void
gen_poly(void)
{
	register int i, j;

	Gg[0] = Alpha_to[B0];
	Gg[1] = 1;		/* g(x) = (X+@**B0) initially */
	for (i = 2; i <= NN - KK; i++) {
		Gg[i] = 1;
		/*
		 * Below multiply (Gg[0]+Gg[1]*x + ... +Gg[i]x^i) by
		 * (@**(B0+i-1) + x)
		 */
		for (j = i - 1; j > 0; j--){
			if (Gg[j] != 0)
				Gg[j] = Gg[j - 1] ^ Alpha_to[modnn((Index_of[Gg[j]]) + B0 + i - 1)];
			else
				Gg[j] = Gg[j - 1];
			
		//	print("Gg[");print_num(j);print("]=");print_num(Gg[j]);print("\n");
		//	print("Gg[");print_num(j-1);print("]=");print_num(Gg[j-1]);print("\n");
		}		
		/* Gg[0] can never be zero */
		Gg[0] = Alpha_to[modnn((Index_of[Gg[0]]) + B0 + i - 1)];
	}
	/* convert Gg[] to index form for quicker encoding */
	for (i = 0; i <= NN - KK; i++)
		Gg[i] = Index_of[Gg[i]];
		
	print("Gg dump\n");
	for (i=0;i<=NN-KK;i++){
		print_uchar(Gg[i]);
		print(" ");	
	}
	print("\n");		
}


/*
 * take the string of symbols in data[i], i=0..(k-1) and encode
 * systematically to produce NN-KK parity symbols in bb[0]..bb[NN-KK-1] data[]
 * is input and bb[] is output in polynomial form. Encoding is done by using
 * a feedback shift register with appropriate connections specified by the
 * elements of Gg[], which was generated above. Codeword is   c(X) =
 * data(X)*X**(NN-KK)+ b(X)
 */
int
encode_rs(dtype data[KK], dtype bb[NN-KK])
{
	register int i, j;
	gf feedback;

	CLEAR(bb,NN-KK);
	for (i = KK - 1; i >= 0; i--) {
#if (MM != 8)
		if(data[i] > NN)
			return -1;	/* Illegal symbol */
#endif
		feedback = Index_of[data[i] ^ bb[NN - KK - 1]];
		if (feedback != A0) {	/* feedback term is non-zero */
			for (j = NN - KK - 1; j > 0; j--)
				if (Gg[j] != A0)
					bb[j] = bb[j - 1] ^ Alpha_to[modnn(Gg[j] + feedback)];
				else
					bb[j] = bb[j - 1];
			bb[0] = Alpha_to[modnn(Gg[0] + feedback)];
		} else {	/* feedback term is zero. encoder becomes a
				 * single-byte shifter */
			for (j = NN - KK - 1; j > 0; j--)
				bb[j] = bb[j - 1];
			bb[0] = 0;
		}
	}
	return 0;
}

/*
 * Performs ERRORS+ERASURES decoding of RS codes. If decoding is successful,
 * writes the codeword into data[] itself. Otherwise data[] is unaltered.
 *
 * Return number of symbols corrected, or -1 if codeword is illegal
 * or uncorrectable.
 * 
 * First "no_eras" erasures are declared by the calling program. Then, the
 * maximum # of errors correctable is t_after_eras = floor((NN-KK-no_eras)/2).
 * If the number of channel errors is not greater than "t_after_eras" the
 * transmitted codeword will be recovered. Details of algorithm can be found
 * in R. Blahut's "Theory ... of Error-Correcting Codes".
 */
int
eras_dec_rs(dtype data[NN], int eras_pos[NN-KK], int no_eras)
{
	int deg_lambda, el, deg_omega;
	int i, j, r;
	gf u,q,tmp,num1,num2,den,discr_r;
	gf recd[NN];
	gf lambda[NN-KK + 1], s[NN-KK + 1];	/* Err+Eras Locator poly
						 * and syndrome poly */
	gf b[NN-KK + 1], t[NN-KK + 1], omega[NN-KK + 1];
	gf root[NN-KK], reg[NN-KK + 1], loc[NN-KK];
	int syn_error, count;

	/* data[] is in polynomial form, copy and convert to index form */
	for (i = NN-1; i >= 0; i--){
#if (MM != 8)
		if(data[i] > NN)
			return -1;	/* Illegal symbol */
#endif
		recd[i] = Index_of[data[i]];
	}
	/* first form the syndromes; i.e., evaluate recd(x) at roots of g(x)
	 * namely @**(B0+i), i = 0, ... ,(NN-KK-1)
	 */
	syn_error = 0;
	for (i = 1; i <= NN-KK; i++) {
		tmp = 0;
		for (j = 0; j < NN; j++)
			if (recd[j] != A0)	/* recd[j] in index form */
				tmp ^= Alpha_to[modnn(recd[j] + (B0+i-1)*j)];
		syn_error |= tmp;	/* set flag if non-zero syndrome =>
					 * error */
		/* store syndrome in index form  */
		s[i] = Index_of[tmp];
	}
	if (!syn_error) {
		/*
		 * if syndrome is zero, data[] is a codeword and there are no
		 * errors to correct. So return data[] unmodified
		 */
		return 0;
	}
	CLEAR(&lambda[1],NN-KK);
	lambda[0] = 1;
	if (no_eras > 0) {
		/* Init lambda to be the erasure locator polynomial */
		lambda[1] = Alpha_to[eras_pos[0]];
		for (i = 1; i < no_eras; i++) {
			u = eras_pos[i];
			for (j = i+1; j > 0; j--) {
				tmp = Index_of[lambda[j - 1]];
				if(tmp != A0)
					lambda[j] ^= Alpha_to[modnn(u + tmp)];
			}
		}
#ifdef ERASURE_DEBUG
		/* find roots of the erasure location polynomial */
		for(i=1;i<=no_eras;i++)
			reg[i] = Index_of[lambda[i]];
		count = 0;
		for (i = 1; i <= NN; i++) {
			q = 1;
			for (j = 1; j <= no_eras; j++)
				if (reg[j] != A0) {
					reg[j] = modnn(reg[j] + j);
					q ^= Alpha_to[reg[j]];
				}
			if (!q) {
				/* store root and error location
				 * number indices
				 */
				root[count] = i;
				loc[count] = NN - i;
				count++;
			}
		}
		if (count != no_eras) {
			print("\n lambda(x) is WRONG\n");
			return -1;
		}
#ifndef NO_PRINT
		print("\n Erasure positions as determined by roots of Eras Loc Poly:\n");
		for (i = 0; i < count; i++)
			print_num(loc[i]);
		print("\n");
#endif
#endif
	}
	for(i=0;i<NN-KK+1;i++)
		b[i] = Index_of[lambda[i]];

	/*
	 * Begin Berlekamp-Massey algorithm to determine error+erasure
	 * locator polynomial
	 */
	r = no_eras;
	el = no_eras;
	while (++r <= NN-KK) {	/* r is the step number */
		/* Compute discrepancy at the r-th step in poly-form */
		discr_r = 0;
		for (i = 0; i < r; i++){
			if ((lambda[i] != 0) && (s[r - i] != A0)) {
				discr_r ^= Alpha_to[modnn(Index_of[lambda[i]] + s[r - i])];
			}
		}
		discr_r = Index_of[discr_r];	/* Index form */
		if (discr_r == A0) {
			/* 2 lines below: B(x) <-- x*B(x) */
			COPYDOWN(&b[1],b,NN-KK);
			b[0] = A0;
		} else {
			/* 7 lines below: T(x) <-- lambda(x) - discr_r*x*b(x) */
			t[0] = lambda[0];
			for (i = 0 ; i < NN-KK; i++) {
				if(b[i] != A0)
					t[i+1] = lambda[i+1] ^ Alpha_to[modnn(discr_r + b[i])];
				else
					t[i+1] = lambda[i+1];
			}
			if (2 * el <= r + no_eras - 1) {
				el = r + no_eras - el;
				/*
				 * 2 lines below: B(x) <-- inv(discr_r) *
				 * lambda(x)
				 */
				for (i = 0; i <= NN-KK; i++)
					b[i] = (lambda[i] == 0) ? A0 : modnn(Index_of[lambda[i]] - discr_r + NN);
			} else {
				/* 2 lines below: B(x) <-- x*B(x) */
				COPYDOWN(&b[1],b,NN-KK);
				b[0] = A0;
			}
			COPY(lambda,t,NN-KK+1);
		}
	}

	/* Convert lambda to index form and compute deg(lambda(x)) */
	deg_lambda = 0;
	for(i=0;i<NN-KK+1;i++){
		lambda[i] = Index_of[lambda[i]];
		if(lambda[i] != A0)
			deg_lambda = i;
	}
	/*
	 * Find roots of the error+erasure locator polynomial. By Chien
	 * Search
	 */
	COPY(&reg[1],&lambda[1],NN-KK);
	count = 0;		/* Number of roots of lambda(x) */
	for (i = 1; i <= NN; i++) {
		q = 1;
		for (j = deg_lambda; j > 0; j--)
			if (reg[j] != A0) {
				reg[j] = modnn(reg[j] + j);
				q ^= Alpha_to[reg[j]];
			}
		if (!q) {
			/* store root (index-form) and error location number */
			root[count] = i;
			loc[count] = NN - i;
			count++;
		}
	}

#ifdef DEBUG
	print("\n Final error positions:\t");
	for (i = 0; i < count; i++)
		print_num(loc[i]);
	print("\n");
#endif
	if (deg_lambda != count) {
		/*
		 * deg(lambda) unequal to number of roots => uncorrectable
		 * error detected
		 */
		return -1;
	}
	/*
	 * Compute err+eras evaluator poly omega(x) = s(x)*lambda(x) (modulo
	 * x**(NN-KK)). in index form. Also find deg(omega).
	 */
	deg_omega = 0;
	for (i = 0; i < NN-KK;i++){
		tmp = 0;
		j = (deg_lambda < i) ? deg_lambda : i;
		for(;j >= 0; j--){
			if ((s[i + 1 - j] != A0) && (lambda[j] != A0))
				tmp ^= Alpha_to[modnn(s[i + 1 - j] + lambda[j])];
		}
		if(tmp != 0)
			deg_omega = i;
		omega[i] = Index_of[tmp];
	}
	omega[NN-KK] = A0;

	/*
	 * Compute error values in poly-form. num1 = omega(inv(X(l))), num2 =
	 * inv(X(l))**(B0-1) and den = lambda_pr(inv(X(l))) all in poly-form
	 */
	for (j = count-1; j >=0; j--) {
		num1 = 0;
		for (i = deg_omega; i >= 0; i--) {
			if (omega[i] != A0)
				num1  ^= Alpha_to[modnn(omega[i] + i * root[j])];
		}
		num2 = Alpha_to[modnn(root[j] * (B0 - 1) + NN)];
		den = 0;

		/* lambda[i+1] for i even is the formal derivative lambda_pr of lambda[i] */
		for (i = min(deg_lambda,NN-KK-1) & ~1; i >= 0; i -=2) {
			if(lambda[i+1] != A0)
				den ^= Alpha_to[modnn(lambda[i+1] + i * root[j])];
		}
		if (den == 0) {
#ifdef DEBUG
			print("\n ERROR: denominator = 0\n");
#endif
			return -1;
		}
		/* Apply error to data */
		if (num1 != 0) {
			data[loc[j]] ^= Alpha_to[modnn(Index_of[num1] + Index_of[num2] + NN - Index_of[den])];
		}
	}
	return count;
}

void
fill_eras(int eras_pos[],int n)
{
	int i,j,t,work[NN];

	for(i=0;i<NN;i++)
		work[i] = i;
	for(j=NN-1;j>0;j--){
		i = random() % j;	/* not really uniform, I know */
		t = work[i];
		work[i] = work[j];
		work[j] = t;
	}
#ifdef notdef
	for(i=0;i<NN;i++)
	  print_num(work[i]);
	print("\n");
#endif
	for(i=0;i<n;i++)
		eras_pos[i] = work[i];
}

/* Return non-zero random number in range 0 - NN (NN power of 2 minus 1) */
int
randomnz(void)
{
	int i;

	while((i = random() & NN) == 0)
		;
	return i;
}

dtype data[NN];
dtype tdata[NN];
dtype ddata[NN];
int eras_pos[NN];
int
main(int argc,char *argv[])
{


	int i,trials;
	int nerrors,nerase,ntrials,verbose,timetest;
	int detfails,fails;
	extern char *optarg;

	nerrors = nerase = 0;
	timetest = verbose = 0;
	ntrials = 3;
	verbose = 1;
	nerrors=11;
	nerase=10;
//	while((i = getopt(argc,argv,"e:E:n:vt")) != EOF){
//		switch(i){
///		case 'e':	/* Number of errors per block */
//			nerrors = atoi(optarg);
//			break;
//		case 'E':	/* Number of erasures per block */
//			nerase = atoi(optarg);
//			break;
//		case 'n':	/* Number of trials */
//			ntrials = atoi(optarg);
//			break;
//		case 'v':	/* Be verbose */
//			verbose = 1;
//			break;
//		case 't':	/* Repeatedly decode the same block */
//			timetest = 1;
//			break;
//		default:
//			printf("usage: %s [-v] [-t] [-e errors] [-E erasures] [-n ntrials]\n",argv[0]);
//			exit(1);
//		}
//	}
	print("It takes very very long time for RTL Simulation.\n");
	print("Reed-Solomon code is ");
//	for (i=3;i>0;i--){ 
		print_num(NN), print(" "); print_num(KK); print("over GF(");
		print_num(NN+1);print(")\n");
	//	print("i=");print_num(i);print("\n");
//	}
	print("test erasures: ");print_num(nerase);print("errors ");print_num(nerrors);print("\n");
	if(2*nerrors + nerase > NN-KK){
		print("Warning: ");
		print_num(nerrors); print("errors and ");
		print_num(nerase); print("erasures exceeds the correction ability of the code\n");
	}	

	init_rs();
	print("Init_RS Done");

	fails = detfails = 0;
	for(trials=0;trials < ntrials;trials++){
		if(verbose){
			print(" Trial ");
			print_num(trials);
			print("\n");
		}
		print("Making Encode Data");	
		for(i=0;i<KK;i++)
			data[i] = random() & NN;
		encode_rs(data,&data[KK]);
		fill_eras(eras_pos,nerase+nerrors);
		if(verbose && nerase){
			print("\n erasing:");
			for(i=0;i<nerase;i++){
				print(" ");print_num(eras_pos[i]);
			
			}
			print("\n");
		}
		if(verbose && nerrors){
			print(" erroring:");
			for(i=nerase;i<nerase+nerrors;i++){
				print(" ");print_num(eras_pos[i]);
			
			}
			print("\n");	
		}
		if(verbose){
			for(i=0;i<NN;i++){
				print_uchar(data[i]);
			    print(" ");
			}
			print("\n");    
		}	
		memcpy(ddata,data,sizeof(data));
		for(i=0;i<nerase+nerrors;i++)
			ddata[eras_pos[i]] ^= randomnz();

		i = eras_dec_rs(ddata,eras_pos,nerase);
		if(verbose){
			print("errs + erasures corrected: ");print_num(i);
		}
		if(i == -1){
			detfails++;
			print("RS decoder detected failure\n");
		} else if(memcmp(ddata,data,NN) != 0){
			fails++;
			print(" Undetected decoding failure!\n");
		}
	}
	print(" \n\nTrials: ");
	print_num(ntrials);
	print(" decoding failures: ");
	print_num(detfails); print(" not detected by decoder: ");
	print_num(fails); print("\n");
	print("$finish");
	return 0;
}

