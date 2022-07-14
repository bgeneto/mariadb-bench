# mariadb-bench

## Purpose
To Benchmark mariadb docker container using sysbench OLTP test with a ramdisk (no disk bottleneck, only cpu and ram).

## Requirements 
Only docker, docker-compose and sysbench :-) 

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo apt install sysbench docker-compose-plugin -y
```

## Install 

```bash
git clone https://github.com/bgeneto/mariadb-bench.git
cd mariadb-bench
docker compose up -d 
chmod +x ./start.sh 
./start.sh 
```

## Usage 
```bash
export sbhost=$(hostname -I | awk '{print $1}')
export sbport=3306
#export sbport=5432
export sbthreads=4
export sbtables=$sbthreads
export sbtime=120
export sbdb=mysql
#export sbdb=pgsql

# populate test tables with data
sysbench /usr/share/sysbench/oltp_read_write.lua \
--db-driver=$sbdb --$sbdb-host=$sbhost --$sbdb-port=$sbport --$sbdb-user=sbtest --$sbdb-password=sbtesting \
--threads=$sbthreads --tables=$sbtables --table-size=1000000 prepare
```

## Write bench first 
Perform a read-write bench first. 

```bash
sysbench /usr/share/sysbench/oltp_read_write.lua \
--db-driver=$sbdb --$sbdb-host=$sbhost --$sbdb-port=$sbport --$sbdb-user=sbtest --$sbdb-password=sbtesting \
--threads=$sbthreads --events=0 --tables=$sbtables --table-size=1000000 \
 --time=$sbtime --report-interval=10 run
```

## Read bench twice 

Perform a read only bench twice. 

```bash
sysbench /usr/share/sysbench/oltp_read_only.lua \
--db-driver=$sbdb --$sbdb-host=$sbhost --$sbdb-port=$sbport --$sbdb-user=sbtest --$sbdb-password=sbtesting \
--tables=$sbtables --table-size=1000000 --range_selects=off --threads=$sbthreads --events=0 \
--time=$sbtime --report-interval=10 run
```
once more...

```bash
sysbench /usr/share/sysbench/oltp_read_only.lua \
--db-driver=$sbdb --$sbdb-host=$sbhost --$sbdb-port=$sbport --$sbdb-user=sbtest --$sbdb-password=sbtesting \
--tables=$sbtables --table-size=1000000 --range_selects=off --threads=$sbthreads --events=0 \
--time=$sbtime --report-interval=10 run
```

## Baseline results 

### AMD Ryzen 5 5600X
It follows some results for AMD Ryzen 5 5600X (DDR4 3200) running Clearlinux OS.

#### Read results
```
SQL statistics:
    queries performed:
        read:                            18918330
        write:                           0
        other:                           3783666
        total:                           22701996
    transactions:                        1891833 (15765.21 per sec.)
    queries:                             22701996 (189182.53 per sec.)
    ignored errors:                      0      (0.00 per sec.)
    reconnects:                          0      (0.00 per sec.)

Throughput:
    events/s (eps):                      15765.2110
    time elapsed:                        120.0005s
    total number of events:              1891833

Latency (ms):
         min:                                    0.22
         avg:                                    0.25
         max:                                    0.52
         95th percentile:                        0.30
         sum:                               479386.26
```

#### Read-Write results

```
SQL statistics:
    queries performed:
        read:                            8297296
        write:                           2370656
        other:                           1185328
        total:                           11853280
    transactions:                        592664 (4938.82 per sec.)
    queries:                             11853280 (98776.44 per sec.)
    ignored errors:                      0      (0.00 per sec.)
    reconnects:                          0      (0.00 per sec.)

Throughput:
    events/s (eps):                      4938.8219
    time elapsed:                        120.0011s
    total number of events:              592664

Latency (ms):
         min:                                    0.65
         avg:                                    0.81
         max:                                   60.16
         95th percentile:                        1.01
         sum:                               479670.64
```

### Intel i5 12600K
It follows results from a Intel i5 12600K (DDR4 3600) cpu running pop os! 22.04. 

#### Read results
```
SQL statistics:
    queries performed:
        read:                            25960860
        write:                           0
        other:                           5192172
        total:                           31153032
    transactions:                        2596086 (21633.74 per sec.)
    queries:                             31153032 (259604.84 per sec.)
    ignored errors:                      0      (0.00 per sec.)
    reconnects:                          0      (0.00 per sec.)

General statistics:
    total time:                          120.0010s
    total number of events:              2596086

Latency (ms):
         min:                                    0.14
         avg:                                    0.18
         max:                                    4.25
         95th percentile:                        0.39
         sum:                               479267.39

Threads fairness:
    events (avg/stddev):           649021.5000/1669.67
    execution time (avg/stddev):   119.8168/0.00
```

#### Read-Write results

```
SQL statistics:
    queries performed:
        read:                            9662030
        write:                           2760580
        other:                           1380290
        total:                           13802900
    transactions:                        690145 (5751.12 per sec.)
    queries:                             13802900 (115022.41 per sec.)
    ignored errors:                      0      (0.00 per sec.)
    reconnects:                          0      (0.00 per sec.)

General statistics:
    total time:                          120.0011s
    total number of events:              690145

Latency (ms):
         min:                                    0.54
         avg:                                    0.70
         max:                                    8.60
         95th percentile:                        1.27
         sum:                               479670.43

Threads fairness:
    events (avg/stddev):           172536.2500/833.06
    execution time (avg/stddev):   119.9176/0.00
```

### Cleanup

Removes data and tables.

```
sysbench /usr/share/sysbench/oltp_read_write.lua --threads=$sbthreads --mysql-host=$sbhost \
--mysql-port=$sbport --mysql-user=sbtest --mysql-password=sbtesting --tables=$sbtables \
--table-size=1000000 cleanup
```

Stop the container

```
docker compose down
```
