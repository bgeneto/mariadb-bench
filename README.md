# mariadb-bench

## Purpose
To Benchmark mariadb docker container using sysbench OLTP test with a ramdisk (no disk influence, only cpu and ram).

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
$ sysbench /usr/share/sysbench/oltp_read_write.lua \
--db-driver=$sbdb --$sbdb-host=$sbhost --$sbdb-port=$sbport --$sbdb-user=sbtest --$sbdb-password=sbtesting \
--threads=$sbthreads --tables=$sbtables --table-size=1000000 prepare
```

## Write bench first 
Perform a read-write bench first. 

```bash
sysbench /usr/share/sysbench/oltp_read_write.lua \
--db-driver=$sbdb --$sbdb-host=$sbhost --$sbdb-port=$sbport --$sbdb-user=sbtest --$sbdb-password=sbtesting \
--threads=$sbthreads --tables=$sbtables --table-size=1000000 prepare
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

It follows some results for AMD Ryzen 5 5600X running Clearlinux OS.

### Read results
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

### Read-Write results

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
