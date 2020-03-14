DECLARE
v_host_cpu_util         NUMBER;
v_ora_cpu_util          NUMBER;
v_ora_cpu_wait          NUMBER;
v_Month                 VARCHAR2(50);

v_max_host_cpu_util             NUMBER;
v_max_ora_cpu_util              NUMBER;
v_max_ora_cpu_wait              NUMBER;

v_Day                   VARCHAR2(12);

v_prev_day_count                NUMBER;

v_sga_max_size                  NUMBER;
v_sga_target                    NUMBER;
v_sga_var                       NUMBER;
v_pga_target                    NUMBER;
v_pga_alloc                     NUMBER;
v_pga_used                      NUMBER;


v_max_sga_target                        NUMBER;
v_max_sga_var                   NUMBER;
v_max_pga_target                        NUMBER;
v_max_pga_alloc                 NUMBER;
v_max_pga_used                  NUMBER;

v_physical_ram                  NUMBER;
v_temp_physical_ram             NUMBER;

v_current_file_size             NUMBER;
v_dummy                         NUMBER;
v_data_size                             NUMBER;
v_curr_time                     DATE;

BEGIN

	BEGIN

        SELECT TO_CHAR(SYSDATE,'MONTH')  MONTH,
                TO_CHAR(SYSDATE,'DD-MON-YYYY')  DAY
        INTO            v_month,
                        v_day
        FROM    DUAL;


        BEGIN

                v_prev_day_count  := 0;

                SELECT COUNT(*) INTO v_prev_day_count
                FROM    TBL_MONTHLY_CPU_METRICS
                WHERE DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
            AND   INST_ID = 1;



                -- Control here means data found
                IF v_prev_day_count > 1 THEN

                        -- average values of a day
                        SELECT  AVG(ORA_CPU_UTIL_PCT) INTO v_ora_cpu_util
                        FROM            TBL_MONTHLY_CPU_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;

                        SELECT  AVG(HOST_CPU_UTIL_PCT) INTO v_host_cpu_util
                        FROM            TBL_MONTHLY_CPU_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;

                        SELECT  AVG(ORA_CPU_WAIT_PCT) INTO v_ora_cpu_wait
                        FROM            TBL_MONTHLY_CPU_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;


                        -- maximum values of a day
                        SELECT  MAX(ORA_CPU_UTIL_PCT) INTO v_max_ora_cpu_util
                        FROM            TBL_MONTHLY_CPU_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;

                        SELECT  MAX(HOST_CPU_UTIL_PCT) INTO v_max_host_cpu_util
                        FROM            TBL_MONTHLY_CPU_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;

                        SELECT  MAX(ORA_CPU_WAIT_PCT) INTO v_max_ora_cpu_wait
                        FROM            TBL_MONTHLY_CPU_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;


                        -- Delete all previous day record
                        DELETE FROM TBL_MONTHLY_CPU_METRICS  WHERE DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY') AND INST_ID = 1;


                        -- Now insert into TBL_MONTHLY_CPU_METRICS the average values calculated
                        INSERT INTO TBL_MONTHLY_CPU_METRICS ( INST_ID, MONTH, DAY , HOST_CPU_UTIL_PCT, ORA_CPU_UTIL_PCT, ORA_CPU_WAIT_PCT,
                       MAX_HOST_CPU_UTIL_PCT, MAX_ORA_CPU_UTIL_PCT, MAX_ORA_CPU_WAIT_PCT,TO_DAY)
                VALUES (1, TO_CHAR(SYSDATE-1, 'MONTH'), TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY'), v_host_cpu_util, v_ora_cpu_util, v_ora_cpu_wait,
                       v_max_host_cpu_util, v_max_ora_cpu_util, v_max_ora_cpu_wait,SYSDATE);


                END IF;


        EXCEPTION
        WHEN NO_DATA_FOUND THEN
                -- do nothing
                NULL;
        WHEN OTHERS THEN
                RETURN;
        END;

        -- Calculate today's metrics
        SELECT MAX(NVL(ORA_CPU_USAGE_PER_SEC,0))
        INTO v_ora_cpu_util
        FROM (
                select  round(value/100,3)  ORA_CPU_USAGE_PER_SEC
                from    gv$sysmetric_history
                where metric_name='CPU Usage Per Sec'
                and begin_time >= SYSDATE - INTERVAL '1' HOUR
                and end_time < TRUNC(SYSDATE, 'MI')
                and group_id=2
            and inst_id= 1
        );

        select nvl(round((prcnt.busy*parameter.cpu_count)/100,3),0)     OS_CPU_USAGE_PER_SEC
        INTO    v_host_cpu_util
        from
                ( select max(value) busy from gv$sysmetric
                  where metric_name='Host CPU Utilization (%)'
                  and group_id=2
                  and begin_time >= SYSDATE - INTERVAL '1' HOUR
                  and end_time < TRUNC(SYSDATE, 'MI')
              and inst_id = 1
                ) prcnt,
                ( select value cpu_count from gv$parameter
                  where name='cpu_count'
              and inst_id = 1 )  parameter;



        select nvl(round( sum(decode(session_state,'ON CPU',1,0))/60,2),0) ORA_CPU_WAIT_PER_SEC
        into   v_ora_cpu_wait
        from     gv$active_session_history ash
        where  sample_time > sysdate - (60/(24*60*60))
      and    inst_id = 1;

        -- Insert the above values
        INSERT INTO TBL_MONTHLY_CPU_METRICS ( INST_ID, MONTH, DAY , HOST_CPU_UTIL_PCT, ORA_CPU_UTIL_PCT, ORA_CPU_WAIT_PCT, MAX_HOST_CPU_UTIL_PCT, MAX_ORA_CPU_UTIL_PCT, MAX_ORA_CPU_WAIT_PCT,TO_DAY )
        VALUES (1, v_month, v_day, v_host_cpu_util, v_ora_cpu_util, v_ora_cpu_wait, v_host_cpu_util, v_ora_cpu_util, v_ora_cpu_wait,SYSDATE );



        --#########################################################################################################################
        -- end of CPU metric
        --#########################################################################################################################
END;

        --#########################################################################################################################
        -- this part of the program will obtain ORACLE Memory utilization - SGA_MAX, SGA_TARGET, SGA_VARIABLE,PGA_TARGET, PGA_ALLOC, PHYSICAL_RAM
        --#########################################################################################################################
BEGIN

        BEGIN

                v_prev_day_count  := 0;

                SELECT COUNT(*) INTO v_prev_day_count
                FROM    TBL_MONTHLY_MEM_METRICS
                WHERE DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
            AND   INST_ID = 1;

                -- Control here means data found
                IF v_prev_day_count > 1 THEN


                        SELECT  MAX(SGA_TARGET) into v_max_sga_target FROM TBL_MONTHLY_MEM_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;

                        SELECT  MAX(PGA_AGGREGATE_TARGET) into v_max_pga_target FROM TBL_MONTHLY_MEM_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;

                        SELECT  MAX(PGA_ALLOCATED) into v_max_pga_alloc FROM TBL_MONTHLY_MEM_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;


                        SELECT  MAX(PGA_USED) into v_max_pga_used FROM TBL_MONTHLY_MEM_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;

                        -- get the average of previous day
                        SELECT  AVG(SGA_VARIABLE_SIZE) into v_sga_var FROM TBL_MONTHLY_MEM_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;


                        SELECT  AVG(SGA_TARGET) into v_sga_target FROM TBL_MONTHLY_MEM_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;

                        SELECT  AVG(PGA_AGGREGATE_TARGET) into v_pga_target FROM TBL_MONTHLY_MEM_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;

                        SELECT  AVG(PGA_ALLOCATED) into v_pga_alloc FROM TBL_MONTHLY_MEM_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;


                        SELECT  AVG(PGA_USED) into v_pga_used FROM TBL_MONTHLY_MEM_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;


                        -- For the following just average is calculated
                        SELECT  AVG(PHYSICAL_MEMORY) INTO v_physical_ram FROM TBL_MONTHLY_MEM_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;

                        SELECT  AVG(SGA_MAX_SIZE) INTO v_sga_max_size FROM TBL_MONTHLY_MEM_METRICS
                        WHERE   DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY')
                  AND         INST_ID = 1;

                        -- Delete all previous day record
                        DELETE FROM TBL_MONTHLY_MEM_METRICS  WHERE DAY = TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY') AND INST_ID = 1;


                        -- Insert one row of previous day data
                        INSERT INTO TBL_MONTHLY_MEM_METRICS (
                                INST_ID,MONTH, DAY, SGA_MAX_SIZE, SGA_VARIABLE_SIZE, SGA_TARGET, PGA_AGGREGATE_TARGET, PGA_ALLOCATED,PGA_USED,
                    PHYSICAL_MEMORY,  MAX_SGA_TARGET, MAX_PGA_AGGREGATE_TARGET, MAX_PGA_ALLOCATED,  MAX_PGA_USED, MAX_SGA_VARIABLE_SIZE, TO_DAY
                  ) VALUES (
                        1, TO_CHAR(SYSDATE-1, 'MONTH'), TO_CHAR(TRUNC(SYSDATE-1,'DDD'),'DD-MON-YYYY'), v_sga_max_size, v_sga_var, v_sga_target,
                        v_pga_target,  v_pga_alloc,  v_pga_used, v_physical_ram , v_max_sga_target,  v_max_pga_target,  v_max_pga_alloc,
                         v_max_pga_used, v_max_sga_var, SYSDATE );


                END IF;

        EXCEPTION
        WHEN NO_DATA_FOUND THEN
                -- do nothing
                NULL;
        WHEN OTHERS THEN
                RETURN;
        END;


        -- Get the current metric values
        SELECT  ROUND(BYTES/1024/1024/1024, 2)
        INTO    v_sga_max_size
        FROM    GV$SGAINFO  WHERE NAME = 'Maximum SGA Size' AND INST_ID= 1;


        SELECT  ROUND(SUM(BYTES)/1024/1024/1024,2)
        INTO    v_sga_var
        FROM    GV$SGAINFO WHERE        RESIZEABLE='Yes'  AND INST_ID = 1;


        SELECT  ROUND(TO_NUMBER(VALUE)/1024/1024/1024,2)
        INTO    v_sga_target
        FROM    GV$PARAMETER    WHERE UPPER(NAME)='SGA_TARGET'  AND INST_ID = 1;



        SELECT  pga_aggr /(1024 * 1024 * 1024),
                        tot_pag_alloc /(1024 * 1024 * 1024),
                        (tot_pag_alloc - tot_pag_used)/ (1024* 1024* 1024)
        INTO            v_pga_target,
                        v_pga_alloc,
                        v_pga_used
        FROM
                (select value  tot_pag_used
                 from   gv$pgastat where name = 'total PGA used for auto workareas' and inst_id = 1),
                (select value tot_pag_alloc
                 from   gv$pgastat where name = 'total PGA allocated' and inst_id = 1 ),
                (select value pga_aggr  from gv$parameter where UPPER(NAME)='PGA_AGGREGATE_TARGET' and inst_id = 1);


        SELECT  ROUND(VALUE/(1024 *1024 *1024), 2)
        INTO    v_physical_ram
        FROM    GV$OSSTAT WHERE STAT_NAME = 'PHYSICAL_MEMORY_BYTES' AND INST_ID = 1;


        INSERT INTO TBL_MONTHLY_MEM_METRICS (
           INST_ID,MONTH, DAY, SGA_MAX_SIZE, SGA_VARIABLE_SIZE, SGA_TARGET, PGA_AGGREGATE_TARGET, PGA_ALLOCATED,PGA_USED, PHYSICAL_MEMORY,
            MAX_SGA_TARGET, MAX_PGA_AGGREGATE_TARGET, MAX_PGA_ALLOCATED,  MAX_PGA_USED, MAX_SGA_VARIABLE_SIZE, TO_DAY
       )  VALUES (
          1, v_month, v_day, v_sga_max_size, v_sga_var, v_sga_target,  v_pga_target,  v_pga_alloc,  v_pga_used, v_physical_ram ,
          v_sga_target,  v_pga_target,  v_pga_alloc,  v_pga_used, v_sga_var,SYSDATE
       );


        --#########################################################################################################################
        -- end of memory metric
        --#########################################################################################################################

END;

        -- Commit all changes
        COMMIT;

END; -- end of proc
/
set serverout off;
set echo on;
set linesize 80;
exit

