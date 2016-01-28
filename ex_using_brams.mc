/* $Id: ex04.mc,v 2.1 2005/06/14 22:16:47 jls Exp $ */

/*
 * Copyright 2005 SRC Computers, Inc.  All Rights Reserved.
 *
 *	Manufactured in the United States of America.
 *
 * SRC Computers, Inc.
 * 4240 N Nevada Avenue
 * Colorado Springs, CO 80907
 * (v) (719) 262-0213
 * (f) (719) 262-0223
 *
 * No permission has been granted to distribute this software
 * without the express permission of SRC Computers, Inc.
 *
 * This program is distributed WITHOUT ANY WARRANTY OF ANY KIND.
 */

#include <libmap.h>


void subr (int64_t I0[], int64_t Out[], int num, int64_t *time, int mapnum) {
    OBM_BANK_A (AL, int64_t, MAX_OBM_SIZE)
    OBM_BANK_B (BL, int64_t, MAX_OBM_SIZE)
    int64_t BBR[2048];
    int64_t t0, t1;
    int i;

    Stream_64 SA,SB;

    read_timer (&t0);

#pragma src parallel sections
{
#pragma src section
{
    streamed_dma_cpu_64 (&SA, PORT_TO_STREAM, I0, num*sizeof(int64_t));
}
#pragma src section
{
    int i;
    int64_t i64;

    for (i=0;i<num;i++)  {
       get_stream_64 (&SA, &i64);

       BBR[i]     = i64 + 9;
       BBR[num+i] = i64 * 5;
    }
}
}


#pragma src parallel sections
{
#pragma src section
{
    streamed_dma_cpu_64 (&SB, STREAM_TO_PORT, Out, 2*num*sizeof(int64_t));
}
#pragma src section
{
    int i;
    int64_t i64;

    for (i=0;i<2*num;i++)  {
       i64 = BBR[i];
       put_stream_64 (&SB, i64, 1);
    }
}
}
    read_timer (&t1);

    *time = t1 - t0;


    }
