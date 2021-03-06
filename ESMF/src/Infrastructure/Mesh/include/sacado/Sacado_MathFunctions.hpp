// $Id: Sacado_MathFunctions.hpp,v 1.1.5.1 2013-01-11 20:23:44 mathomp4 Exp $ 
// $Source: /cvsroot/baselibs/Baselibs/src/esmf/src/Infrastructure/Mesh/include/sacado/Sacado_MathFunctions.hpp,v $ 
// @HEADER
// ***********************************************************************
// 
//                           Sacado Package
//                 Copyright (2006) Sandia Corporation
// 
// Under the terms of Contract DE-AC04-94AL85000 with Sandia Corporation,
// the U.S. Government retains certain rights in this software.
// 
// This library is free software; you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 2.1 of the
// License, or (at your option) any later version.
//  
// This library is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//  
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA
// Questions? Contact David M. Gay (dmgay@sandia.gov) or Eric T. Phipps
// (etphipp@sandia.gov).
// 
// ***********************************************************************
// @HEADER

#ifndef SACADO_MATHFUNCTIONS_HPP
#define SACADO_MATHFUNCTIONS_HPP

#define UNARYFUNC_MACRO(OP,FADOP)					\
namespace Sacado {							\
									\
  namespace Fad {							\
    template <typename T> class FADOP;					\
    template <typename T> class Expr;					\
    template <typename T, template<typename> class Op> class UnaryExpr;	\
    template <typename T>						\
    Expr< UnaryExpr< Expr<T>, FADOP > > OP (const Expr<T>&);		\
  }									\
									\
  namespace CacheFad {							\
    template <typename T> class FADOP;					\
    template <typename T> class Expr;					\
    template <typename T, template<typename> class Op> class UnaryExpr;	\
    template <typename T>						\
    Expr< UnaryExpr< Expr<T>, FADOP > > OP (const Expr<T>&);		\
  }									\
									\
  namespace Tay {							\
    template <typename T> class Taylor;					\
    template <typename T> Taylor<T> OP (const Taylor<T>&);		\
  }									\
									\
  namespace FlopCounterPack {						\
    template <typename T> class ScalarFlopCounter;			\
    template <typename T>						\
    ScalarFlopCounter<T> OP (const ScalarFlopCounter<T>&);		\
  }									\
									\
  namespace Rad {							\
    template <typename T> class ADvari;					\
    template <typename T> class IndepADvar;				\
    template <typename T> ADvari<T>& OP (const ADvari<T>&);		\
    template <typename T> ADvari<T>& OP (const IndepADvar<T>&);		\
  }									\
}                                                                       \
                                                                        \
namespace std {                                                         \
  using Sacado::Fad::OP;						\
  using Sacado::CacheFad::OP;						\
  using Sacado::Tay::OP;						\
  using Sacado::FlopCounterPack::OP;					\
  using Sacado::Rad::OP;						\
}

UNARYFUNC_MACRO(exp, ExpOp)
UNARYFUNC_MACRO(log, LogOp)
UNARYFUNC_MACRO(log10, Log10Op)
UNARYFUNC_MACRO(sqrt, SqrtOp)
UNARYFUNC_MACRO(cos, CosOp)
UNARYFUNC_MACRO(sin, SinOp)
UNARYFUNC_MACRO(tan, TanOp)
UNARYFUNC_MACRO(acos, ACosOp)
UNARYFUNC_MACRO(asin, ASinOp)
UNARYFUNC_MACRO(atan, ATanOp)
UNARYFUNC_MACRO(cosh, CoshOp)
UNARYFUNC_MACRO(sinh, SinhOp)
UNARYFUNC_MACRO(tanh, TanhOp)
UNARYFUNC_MACRO(acosh, ACoshOp)
UNARYFUNC_MACRO(asinh, ASinhOp)
UNARYFUNC_MACRO(atanh, ATanhOp)
UNARYFUNC_MACRO(abs, AbsOp)
UNARYFUNC_MACRO(fabs, FAbsOp)

#undef UNARYFUNC_MACRO

#define BINARYFUNC_MACRO(OP,FADOP)					\
namespace Sacado {							\
									\
  namespace Fad {							\
    template <typename T1, typename T2> class FADOP;			\
    template <typename T> class Expr;					\
    template <typename T> class ConstExpr;				\
    template <typename T1, typename T2,					\
	      template<typename,typename> class Op> class BinaryExpr;	\
    template <typename T1, typename T2>					\
    Expr< BinaryExpr< Expr<T1>, Expr<T2>, FADOP > >			\
    OP (const Expr<T1>&, const Expr<T2>&);				\
									\
    template <typename T>						\
    Expr< BinaryExpr< ConstExpr<typename Expr<T>::value_type>,		\
		      Expr<T>, FADOP > >				\
    OP (const typename Expr<T>::value_type&, const Expr<T>&);		\
									\
    template <typename T>						\
    Expr< BinaryExpr< Expr<T>, ConstExpr<typename Expr<T>::value_type>, \
		      FADOP > >						\
    OP (const Expr<T>&, const typename Expr<T>::value_type&);		\
  }									\
									\
  namespace CacheFad {							\
    template <typename T1, typename T2> class FADOP;			\
    template <typename T> class Expr;					\
    template <typename T> class ConstExpr;				\
    template <typename T1, typename T2,					\
	      template<typename,typename> class Op> class BinaryExpr;	\
    template <typename T1, typename T2>					\
    Expr< BinaryExpr< Expr<T1>, Expr<T2>, FADOP > >			\
    OP (const Expr<T1>&, const Expr<T2>&);				\
									\
    template <typename T>						\
    Expr< BinaryExpr< ConstExpr<typename Expr<T>::value_type>,		\
		      Expr<T>, FADOP > >				\
    OP (const typename Expr<T>::value_type&, const Expr<T>&);		\
									\
    template <typename T>						\
    Expr< BinaryExpr< Expr<T>, ConstExpr<typename Expr<T>::value_type>, \
		      FADOP > >						\
    OP (const Expr<T>&, const typename Expr<T>::value_type&);		\
  }									\
									\
  namespace Tay {							\
    template <typename T> class Taylor;					\
    template <typename T> Taylor<T> OP (const Taylor<T>&,		\
					const Taylor<T>&);		\
    template <typename T> Taylor<T> OP (const T&,			\
					const Taylor<T>&);		\
    template <typename T> Taylor<T> OP (const Taylor<T>&,		\
					const T&);			\
  }									\
									\
  namespace FlopCounterPack {						\
    template <typename T> class ScalarFlopCounter;			\
    template <typename T>						\
    ScalarFlopCounter<T> OP (const ScalarFlopCounter<T>&,		\
			     const ScalarFlopCounter<T>&);		\
    template <typename T>						\
    ScalarFlopCounter<T> OP (const T&,					\
			     const ScalarFlopCounter<T>);		\
    template <typename T>						\
    ScalarFlopCounter<T> OP (const ScalarFlopCounter<T>&,		\
			     const T&);					\
    template <typename T>						\
    ScalarFlopCounter<T> OP (const int&,				\
			     const ScalarFlopCounter<T>);		\
    template <typename T>						\
    ScalarFlopCounter<T> OP (const ScalarFlopCounter<T>&,		\
			     const int&);				\
  }									\
									\
  namespace Rad {							\
    template <typename T> class ADvari;					\
    template <typename T> class IndepADvar;				\
    template <typename T> class DoubleAvoid;				\
    template <typename T> ADvari<T>& OP (const ADvari<T>&,		\
					 const ADvari<T>&);		\
    template <typename T> ADvari<T>& OP (const IndepADvar<T>&,		\
					 const ADvari<T>&);		\
    template <typename T> ADvari<T>& OP (T,				\
					 const ADvari<T>&);		\
    template <typename T> ADvari<T>& OP (typename DoubleAvoid<T>::dtype, \
					 const ADvari<T>&);		\
    template <typename T> ADvari<T>& OP (int,				\
					 const ADvari<T>&);		\
    template <typename T> ADvari<T>& OP (long,				\
					 const ADvari<T>&);		\
    template <typename T> ADvari<T>& OP (const ADvari<T>&,		\
					 const IndepADvar<T>&);		\
    template <typename T> ADvari<T>& OP (const ADvari<T>&,		\
					 T);				\
    template <typename T> ADvari<T>& OP (const ADvari<T>&,		\
					 typename DoubleAvoid<T>::dtype); \
    template <typename T> ADvari<T>& OP (const ADvari<T>&,		\
					 int);				\
    template <typename T> ADvari<T>& OP (const ADvari<T>&,		\
					 long);				\
    template <typename T> ADvari<T>& OP (const IndepADvar<T>&,		\
					 const IndepADvar<T>&);		\
    template <typename T> ADvari<T>& OP (T,				\
					 const IndepADvar<T>&);		\
    template <typename T> ADvari<T>& OP (typename DoubleAvoid<T>::dtype, \
					 const IndepADvar<T>&);		\
    template <typename T> ADvari<T>& OP (int,				\
					 const IndepADvar<T>&);		\
    template <typename T> ADvari<T>& OP (long,				\
					 const IndepADvar<T>&);		\
    template <typename T> ADvari<T>& OP (const IndepADvar<T>&,		\
					 T);				\
    template <typename T> ADvari<T>& OP (const IndepADvar<T>&,		\
					 typename DoubleAvoid<T>::dtype); \
    template <typename T> ADvari<T>& OP (const IndepADvar<T>&,		\
					 int);				\
    template <typename T> ADvari<T>& OP (const IndepADvar<T>&,		\
					 long);				\
  }									\
									\
}									\
                                                                        \
namespace std {                                                         \
  using Sacado::Fad::OP;						\
  using Sacado::CacheFad::OP;						\
  using Sacado::Tay::OP;						\
  using Sacado::FlopCounterPack::OP;					\
  using Sacado::Rad::OP;						\
}

BINARYFUNC_MACRO(atan2, Atan2Op)
BINARYFUNC_MACRO(pow, PowerOp)
BINARYFUNC_MACRO(max, MaxOp)
BINARYFUNC_MACRO(min, MinOp)

#undef BINARYFUNC_MACRO

#endif // SACADO_MATHFUNCTIONS_HPP
