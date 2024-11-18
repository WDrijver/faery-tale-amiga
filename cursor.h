#ifdef __cplusplus
extern "C"{
#endif 

#include "stdint.h"
#include "stdlib.h"
#include <exec/types.h>
#include "ApolloRegParam.h"

extern _REG void cursor( _D0(long xx), _D1(long yy), _A1(struct RastPort *rp), _A0(char* answr) );

#ifdef __cplusplus
}
#endif