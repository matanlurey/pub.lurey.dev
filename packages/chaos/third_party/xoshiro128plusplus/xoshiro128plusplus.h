#include <stdint.h>

void seed(uint32_t seed[4]);
uint32_t next(void);
uint32_t rotl(const uint32_t x, int k);
void jump(void);
void long_jump(void);
