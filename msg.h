#ifdef __cplusplus
extern "C"{
#endif 

#include "stdint.h"
#include "stdlib.h"
#include <exec/types.h>
#include "ApolloRegParam.h"

extern _REG void event( _D0(long event_nr) );

extern _REG void speak( _D0(long speak_nr) );

extern _REG void msg( _A0(char *ms), _D0(long i) );

#ifdef __cplusplus
}
#endif