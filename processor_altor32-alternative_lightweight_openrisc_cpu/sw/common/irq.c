#include "mem_map.h"
#include "irq.h"

//-----------------------------------------------------------------
// irq_enable 
//-----------------------------------------------------------------
void irq_enable(int interrupt)
{
    IRQ_MASK_SET = (1 << interrupt);
}
//-----------------------------------------------------------------
// irq_disable 
//-----------------------------------------------------------------
void irq_disable(int interrupt)
{
    IRQ_MASK_CLR = (1 << interrupt);
}
//-----------------------------------------------------------------
// irq_acknowledge 
//-----------------------------------------------------------------
void irq_acknowledge(int interrupt)
{
    IRQ_STATUS = (1 << interrupt);
}
